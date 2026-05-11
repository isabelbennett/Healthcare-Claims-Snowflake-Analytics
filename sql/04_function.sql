/////////////////////////////////////////////////////////////////////
// Prescription Claims Analysis Project
// Isabel Bennett
// Spring 2026, SEIS 732
//
// Purpose: Transform raw prescription claims data into a
// structured, analysis friendly format.
/////////////////////////////////////////////////////////////////////

// Initial Setup 
USE ROLE TRAINING_ROLE;

CREATE WAREHOUSE IF NOT EXISTS CHIPMUNK_WH;
USE WAREHOUSE CHIPMUNK_WH;
CREATE DATABASE IF NOT EXISTS CHIPMUNK_DB;
USE DATABASE CHIPMUNK_DB;

// Create schema for curation layer to clean and standardize data
CREATE OR REPLACE SCHEMA CHIPMUNK_CURATION; 

// Create schehma for aggregation layer to optimize data for analysis
CREATE OR REPLACE SCHEMA CHIPMUNK_AGGREGATION;

// Set schema to aggregation layer
USE SCHEMA CHIPMUNK_AGGREGATION;

// Create table function from aggregated view
// This table function allows filtering of cost burden results
// based on minimum claim volume and category selection to support analytics
CREATE OR REPLACE FUNCTION FN_COST_BURDEN_ANALYSIS(
    min_claims INTEGER,
    cost_burden_filter VARCHAR
)
RETURNS TABLE(
    COST_BURDEN_CATEGORY VARCHAR,
    TOTAL_CLAIMS NUMBER,
    AVG_MEMBER_PAID NUMBER,
    AVG_MEMBER_SAVINGS NUMBER,
    AVG_COST_BURDEN_RATIO NUMBER,
    MIN_MEMBER_PAID NUMBER,
    MAX_MEMBER_PAID NUMBER
)
AS
$$
    SELECT 
        COST_BURDEN_CATEGORY,
        TOTAL_CLAIMS,
        AVG_MEMBER_PAID,
        AVG_MEMBER_SAVINGS,
        AVG_COST_BURDEN_RATIO,
        MIN_MEMBER_PAID,
        MAX_MEMBER_PAID
FROM AGG_COST_BURDEN_DISTRIBUTION
WHERE TOTAL_CLAIMS >= min_claims AND (cost_burden_filter IS NULL OR COST_BURDEN_CATEGORY = cost_burden_filter)
$$;

// Validate function
// Test: Return all cost burden categories with at least 500 claims
// Shows the function without category filtering
SELECT * 
FROM TABLE(FN_COST_BURDEN_ANALYSIS(500, NULL::VARCHAR))
ORDER BY TOTAL_CLAIMS DESC;

// Test: Return only High Cost Burden category with at least 500 claims
// Shows the use of category filtering
SELECT * 
FROM TABLE(FN_COST_BURDEN_ANALYSIS(500, 'High Cost Burden'))
ORDER BY TOTAL_CLAIMS DESC;
