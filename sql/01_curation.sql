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

// Set schema to curation layer
USE SCHEMA CHIPMUNK_CURATION;

// Curation overview
// Each step improves data quality and usability for analytics
// and reporting

// Step 1: Create a base curated table from raw claims data
// Standardize formatting to provide consistency
// Normalize text fields using TRIM and UPPER to create 
// consistency in letter cases and eliminate spacing issues
CREATE OR REPLACE TABLE CUR_RX_BASE AS
SELECT 
    ID,
    
    // Member information
    UPPER(TRIM(MEMBER_GENDER)) AS MEMBER_GENDER,
    UPPER(NULLIF(TRIM(MEMBER_STATE), '')) AS MEMBER_STATE,
    NULLIF(TRIM(MEMBER_AGE_GROUP), '') AS MEMBER_AGE_GROUP,
    
    // Dates
    TO_DATE(DATE_FILLED) AS DATE_FILLED,
    TO_DATE(DATE_SUBMITTED) AS DATE_SUBMITTED,
    TO_DATE(MASTER_MEMBER_DATE_SUBMITTED) AS MASTER_MEMBER_DATE_SUBMITTED,
    TO_DATE(DATE_SUBMITTED_MONTH) AS DATE_SUBMITTED_MONTH,
    
    // Claim details
    TRIM(MASTER_REPEAT_USAGE) AS MASTER_REPEAT_USAGE,
    UNIQUE_MEMBER,
    TRIM(RXCLAIM_ACTUAL_STATUS) AS RXCLAIM_ACTUAL_STATUS,
    REVERSED,
    DAYS_TO_REVERSE,

    // Drug information
    NULLIF(TRIM(DRUG_NAME), '') AS DRUG_NAME,
    TRIM(DRUG_THERAPEUTIC_CLASS_NAME) AS DRUG_THERAPEUTIC_CLASS_NAME,
    TRIM(BRAND_GENERIC_CODE) AS BRAND_GENERIC_CODE,
    TRIM(DRUG_DEA_CODE) AS DRUG_DEA_CODE,
    TRIM(SPECIALITY_NON_SPECIALITY_CODE) AS SPECIALITY_NON_SPECIALITY_CODE,

    // Pharmacy information 
    NULLIF(TRIM(PHARMACY_NAME), '') AS PHARMACY_NAME,
    TRIM(PHARMACY_CITY) AS PHARMACY_CITY,
    UPPER(NULLIF(TRIM(PHARMACY_STATE), '')) AS PHARMACY_STATE,
    TRIM(PHARMACY_ZIP) AS PHARMACY_ZIP,

    // Quantity and supply information
    TOTAL_QUANTITY,
    TOTAL_DAYS_SUPPLY,
    AVG_QUANTITY_DAY,
    REFILL_NUMBER,
    REFILL_MAXIMUM,
    RETAIL_30_90_DAYS_SUPPLY,

    // Cost and savings information
    TOTAL_DRUG_COST,
    TOTAL_MEMBER_PAID,
    TOTAL_COPAY,
    MEMBER_SAVINGS,
    MEMBER_SAVINGS_PERCENT

FROM PRESCRIPTION_DISCOUNT_CARD_CLAIMS_DATA.PUBLIC.DE_IDENTIFIED_TRANSACTIONS_CLAIMS;

// Validate row count to confirm data was loaded successfully
SELECT COUNT(*)
FROM CUR_RX_BASE;

// Preview base table
SELECT *
FROM CUR_RX_BASE
LIMIT 20;

// Step 2: Time-based fields to support trend and time analysis
// Enables analysis by year, month, season, etc.
CREATE OR REPLACE VIEW CUR_RX_TIME AS
SELECT
    *,

    // Year, monthm and quarter breakdown for trend reporting
    YEAR(DATE_SUBMITTED) AS SUBMITTED_YEAR,
    MONTH(DATE_SUBMITTED) AS SUBMITTED_MONTH,
    QUARTER(DATE_SUBMITTED) AS SUBMITTED_QUARTER,

    // Different time formats
    TO_CHAR(DATE_SUBMITTED, 'YYYY-MM') AS SUBMITTED_MONTH_CODE,
    TO_CHAR(DATE_SUBMITTED, 'MON-YYYY') AS SUBMITTED_MONTH_READABLE,

    // Flag weekend submissions for trend analysis
    CASE    
        WHEN DAYNAME(DATE_SUBMITTED) IN ('Sat', 'Sun') THEN TRUE
        ELSE FALSE
    END AS WEEKEND_SUBMISSION, 

    // Processing delay between prescription fill and submission
    // Useful for analyzing claim processing
    DATEDIFF('day', DATE_FILLED, DATE_SUBMITTED) AS DAYS_BETWEEN_FILL_AND_SUBMIT

FROM CUR_RX_BASE;

// Validate time-based enhancements view creation
SELECT COUNT(*)
FROM CUR_RX_TIME;

// Preview time-based enhancements view
SELECT * 
FROM CUR_RX_TIME 
LIMIT 20;

// Step 3: Create categorical groupings to simplify analysis
CREATE OR REPLACE VIEW CUR_RX_CATEGORIES AS
SELECT 
    *,

    // Group members into age categories
    CASE 
        WHEN MEMBER_AGE_GROUP = '0-24 Y' THEN 'Youth'
        WHEN MEMBER_AGE_GROUP IN ('25-34 Y', '35-44 Y', '45-54 Y') THEN 'Adult'
        WHEN MEMBER_AGE_GROUP IN ('55-64 Y', '65+ Y') THEN 'Older Adult'
        ELSE 'Unknown'
    END AS MEMBER_AGE_SEGMENT,
    
    // Group savings levels
    CASE
        WHEN MEMBER_SAVINGS_PERCENT >= 0.75 THEN 'Very High Savings'
        WHEN MEMBER_SAVINGS_PERCENT >= 0.50 THEN 'High Savings'
        WHEN MEMBER_SAVINGS_PERCENT >= 0.25 THEN 'Moderate Savings'
        WHEN MEMBER_SAVINGS_PERCENT >= 0 THEN 'Low Savings'
        ELSE 'Unknown'
    END AS SAVINGS_TIER,

    // Flag controlled substance for risk analysis
    CASE
        WHEN DRUG_DEA_CODE IS NOT NULL AND DRUG_DEA_CODE <> '0' THEN TRUE
        ELSE FALSE
    END AS IS_CONTROLLED_SUBSTANCE,

    // Group prescription supply into 30-day vs 90-day
    CASE    
        WHEN RETAIL_30_90_DAYS_SUPPLY = 30 THEN '30-Day'
        WHEN RETAIL_30_90_DAYS_SUPPLY = 90 THEN '90-Day'
        ELSE 'Other'
    END AS SUPPLY_TYPE,

    // Flag reversed claims
    // Allows reversed claims to be excluded so they don't distort metrics
    CASE
        WHEN REVERSED = TRUE OR RXCLAIM_ACTUAL_STATUS = 'Reversed' THEN TRUE
        ELSE FALSE
    END AS IS_REVERSED_CLAIM

FROM CUR_RX_TIME;

// Validate category view creation
SELECT COUNT(*)
FROM CUR_RX_CATEGORIES;

// Preview category view
SELECT * 
FROM CUR_RX_CATEGORIES
LIMIT 20;

// Step 4: Add data quality checks for important fields
CREATE OR REPLACE VIEW CUR_RX_QUALITY AS
SELECT
    *,

    // Flag missing values
    // Identifies incomplete records that could impact analysis
    CASE
        WHEN MEMBER_STATE IS NULL THEN 'Missing State'
        ELSE 'State Present'
    END AS MEMBER_STATE_CHECK,

    CASE
        WHEN MEMBER_AGE_GROUP IS NULL THEN 'Missing Age Group'
        ELSE 'Age Group Present'
    END AS MEMBER_AGE_CHECK,

    CASE 
        WHEN DATE_SUBMITTED IS NULL THEN 'Missing Submission Date'
        ELSE 'Submission Date Present'
    END AS DATE_SUBMITTED_CHECK,

    CASE    
        WHEN RXCLAIM_ACTUAL_STATUS IS NULL THEN 'Missing Claim Status'
        ELSE 'Claim Status Present'
    END AS CLAIM_STATUS_CHECK,

    CASE 
        WHEN DRUG_NAME IS NULL THEN 'Missing Drug Name'
        ELSE 'Drug Name Present'
    END AS DRUG_NAME_CHECK,

    CASE    
        WHEN PHARMACY_NAME IS NULL THEN 'Missing Pharmacy Name'
        ELSE 'Pharmacy Name Present'
    END AS PHARMACY_NAME_CHECK,

    CASE
        WHEN TOTAL_DRUG_COST IS NULL THEN 'Missing Drug Cost'
        ELSE 'Drug Cost Present'
    END AS DRUG_COST_CHECK

FROM CUR_RX_CATEGORIES;

// Validate quality view creation
SELECT COUNT(*)
FROM CUR_RX_QUALITY;

// Preview quality view
SELECT * 
FROM CUR_RX_QUALITY
LIMIT 20;

// Step 5: Add a data quality score
// Higher scores indicate more reliable (and complete) records
CREATE OR REPLACE VIEW CUR_RX_QUALITY_SCORE AS
SELECT
    *,

    // Remove points for each missing field to represent missing data
    // Score is 0 at minimum to prevent negative values
    GREATEST(0,
        100 - (
            (CASE WHEN MEMBER_STATE IS NULL THEN 15 ELSE 0 END) +
            (CASE WHEN MEMBER_AGE_GROUP IS NULL THEN 15 ELSE 0 END) +
            (CASE WHEN DATE_SUBMITTED IS NULL THEN 15 ELSE 0 END) +
            (CASE WHEN RXCLAIM_ACTUAL_STATUS IS NULL THEN 15 ELSE 0 END) +
            (CASE WHEN DRUG_NAME IS NULL THEN 15 ELSE 0 END) +
            (CASE WHEN PHARMACY_NAME IS NULL THEN 15 ELSE 0 END) +
            (CASE WHEN TOTAL_DRUG_COST IS NULL THEN 15 ELSE 0 END)
        ) 
    ) AS DATA_QUALITY_SCORE
FROM CUR_RX_QUALITY;

// Validate data quality score
SELECT 
    COUNT(*),
    AVG(DATA_QUALITY_SCORE),
    MIN(DATA_QUALITY_SCORE),
    MAX(DATA_QUALITY_SCORE)
FROM CUR_RX_QUALITY_SCORE;

// Step 6: Create a final curated summary view
// Combines all transformations into a single dataset
CREATE OR REPLACE VIEW SLV_RX_CLAIMS_SUMMARY AS
SELECT  
    ID,

    // Member fields
    MEMBER_GENDER,
    MEMBER_STATE,
    MEMBER_AGE_GROUP,
    MEMBER_AGE_SEGMENT,
    MASTER_REPEAT_USAGE,
    UNIQUE_MEMBER,

    // Time fields
    DATE_FILLED,
    DATE_SUBMITTED,
    MASTER_MEMBER_DATE_SUBMITTED,
    DATE_SUBMITTED_MONTH,
    SUBMITTED_YEAR,
    SUBMITTED_MONTH,
    SUBMITTED_QUARTER,
    SUBMITTED_MONTH_CODE,
    SUBMITTED_MONTH_READABLE,
    WEEKEND_SUBMISSION,
    DAYS_BETWEEN_FILL_AND_SUBMIT,

    // Claim status fields
    RXCLAIM_ACTUAL_STATUS,
    REVERSED,
    DAYS_TO_REVERSE,
    IS_REVERSED_CLAIM,

    // Drug and pharmacy fields
    DRUG_NAME,
    DRUG_THERAPEUTIC_CLASS_NAME,
    BRAND_GENERIC_CODE,
    DRUG_DEA_CODE,
    SPECIALITY_NON_SPECIALITY_CODE,
    PHARMACY_NAME,
    PHARMACY_CITY,
    PHARMACY_STATE,
    PHARMACY_ZIP,

    // Quantity and supply
    TOTAL_QUANTITY,
    TOTAL_DAYS_SUPPLY,
    AVG_QUANTITY_DAY,
    REFILL_NUMBER,
    REFILL_MAXIMUM,
    RETAIL_30_90_DAYS_SUPPLY,
    SUPPLY_TYPE,

    // Financial fields
    TOTAL_DRUG_COST,
    TOTAL_MEMBER_PAID,
    TOTAL_COPAY,
    MEMBER_SAVINGS,
    MEMBER_SAVINGS_PERCENT,
    SAVINGS_TIER,

    // Flags
    IS_CONTROLLED_SUBSTANCE,

    // Quality fields
    MEMBER_STATE_CHECK,
    MEMBER_AGE_CHECK,
    DATE_SUBMITTED_CHECK,
    CLAIM_STATUS_CHECK,
    DRUG_NAME_CHECK,
    PHARMACY_NAME_CHECK,
    DRUG_COST_CHECK,
    DATA_QUALITY_SCORE

FROM CUR_RX_QUALITY_SCORE

// Exclude low quality records missing key fields
// Choose under 70 because this indicates a significant amount of missing data
WHERE DATA_QUALITY_SCORE >= 70;  

// Validate final summary view
SELECT  
    COUNT(*),
    COUNT(DISTINCT MEMBER_STATE),
    COUNT(DISTINCT DRUG_THERAPEUTIC_CLASS_NAME),
    AVG(DATA_QUALITY_SCORE)
FROM SLV_RX_CLAIMS_SUMMARY;

// Preview final summary view
SELECT *
FROM SLV_RX_CLAIMS_SUMMARY
LIMIT 20;
