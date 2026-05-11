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

// Create the scheduled task
CREATE OR REPLACE TASK TASK_REFRESH_RX_WEEKLY
    WAREHOUSE = CHIPMUNK_WH
    SCHEDULE = 'USING CRON 0 4 * * SUN America/Chicago'
AS
CALL SP_REFRESH_RX_WEEKLY();

// Resume task so it is active
ALTER TASK TASK_REFRESH_RX_WEEKLY RESUME;

// Check task details
SHOW TASKS LIKE 'TASK_REFRESH_RX_WEEKLY';

// Manually test task
CALL SP_REFRESH_RX_WEEKLY();

// Suspend task
ALTER TASK TASK_REFRESH_RX_WEEKLY SUSPEND;
