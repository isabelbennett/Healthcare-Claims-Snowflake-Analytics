// Initial Setup 
USE ROLE TRAINING_ROLE;

CREATE WAREHOUSE IF NOT EXISTS CHIPMUNK_WH;
USE WAREHOUSE CHIPMUNK_WH;
CREATE DATABASE IF NOT EXISTS CHIPMUNK_DB;
USE DATABASE CHIPMUNK_DB;

// Create schema for curation layer to clean and standardize data
CREATE OR REPLACE SCHEMA CHIPMUNK_CURATION; 

// Set schema to curation layer
USE SCHEMA CHIPMUNK_CURATION;


// Stored Procedure overview
// This procedure refreshes a weekly table and adds new fields that 
// support affordability, refill behavior, and claim timing analysis

// Step 1: Create the stored procedure
CREATE OR REPLACE PROCEDURE SP_REFRESH_RX_WEEKLY()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

    // Step 2: Create a refreshed weekly table from the curated summary view
    CREATE OR REPLACE TABLE CUR_RX_WEEKLY AS
    SELECT
        *,

        // Step 3: Categorize refill activity into stages to 
        // understand prescription refill behavior
        CASE 
            WHEN REFILL_NUMBER = 0 THEN 'New Prescription'
            WHEN REFILL_NUMBER BETWEEN 1 AND 2 THEN 'Early Refill'
            WHEN REFILL_MAXIMUM IS NOT NULL AND REFILL_NUMBER = REFILL_MAXIMUM THEN 'Max Refill Reached'
            WHEN REFILL_NUMBER >= 3 AND REFILL_MAXIMUM IS NOT NULL AND REFILL_NUMBER < REFILL_MAXIMUM THEN 'Ongoing Refill'
            ELSE 'Unknown'
        END AS REFILL_STAGE_CATEGORY,

        // Step 4: Calculate member cost burden ratio to measure the  
        // member's out of pocket share of the total value 
        TOTAL_MEMBER_PAID / NULLIF(TOTAL_MEMBER_PAID + MEMBER_SAVINGS, 0) AS MEMBER_COST_BURDEN_RATIO,

        // Step 5: Add cost burden category to simplify affordability accross claims
        CASE
            WHEN TOTAL_MEMBER_PAID / NULLIF(TOTAL_MEMBER_PAID + MEMBER_SAVINGS, 0) >= 0.75 THEN 'High Cost Burden'
            WHEN TOTAL_MEMBER_PAID / NULLIF(TOTAL_MEMBER_PAID + MEMBER_SAVINGS, 0) >= 0.5 THEN 'Moderate Cost Burden'
            WHEN TOTAL_MEMBER_PAID / NULLIF(TOTAL_MEMBER_PAID + MEMBER_SAVINGS, 0) >= 0.25 THEN 'Low Cost Burden'
            WHEN TOTAL_MEMBER_PAID / NULLIF(TOTAL_MEMBER_PAID + MEMBER_SAVINGS, 0) < 0.25 THEN 'Very Low Cost Burden'
            ELSE 'Unknown'
        END AS COST_BURDEN_CATEGORY,

        // Step 6: Group claims by how quickly they were filled after being submitted
        // to analyze timing and processing delays
        CASE 
            WHEN DAYS_BETWEEN_FILL_AND_SUBMIT = 0 THEN 'Same Day'
            WHEN DAYS_BETWEEN_FILL_AND_SUBMIT BETWEEN 1 AND 3 THEN '1 to 3 Days'
            WHEN DAYS_BETWEEN_FILL_AND_SUBMIT BETWEEN 4 AND 7 THEN '4 to 7 Days'
            WHEN DAYS_BETWEEN_FILL_AND_SUBMIT > 7 THEN 'Over 1 Week'
            ELSE 'Unknown'
        END AS FILL_AND_SUBMIT_SPEED_CATEGORY

    FROM SLV_RX_CLAIMS_SUMMARY;

    RETURN 'SP_REFRESH_RX_WEEKLY completed successfully';

END;
$$;

// Run the procedure 
CALL SP_REFRESH_RX_WEEKLY();

// Validate weekly table creation
SELECT COUNT(*)
FROM CUR_RX_WEEKLY;

// Preview weekly table
SELECT *
FROM CUR_RX_WEEKLY
LIMIT 20;
