# Healthcare Claims Analytics with Snowflake

This project analyzes prescription discount card claims data using Snowflake. The goal was to build a reproducible data pipeline that cleans raw healthcare claims data, creates curated and aggregated tables, and supports dashboard-ready analytics around member cost burden, claim activity, and prescription usage patterns.

## Project Overview

The project follows a data warehousing workflow:

1. Curated raw prescription claims data
2. Standardized key fields such as member state, gender, age group, drug name, and claim status
3. Created reusable Snowflake SQL objects including views, stored procedures, table functions, and scheduled tasks
4. Built aggregation views for dashboard analysis
5. Developed a Streamlit dashboard connected to Snowflake

## Tools Used

- Snowflake
- SQL
- Streamlit
- Python
- Healthcare claims data
- Data warehousing concepts

## Key Features

- Cleaned and standardized raw claims data
- Created curated and aggregation schemas
- Built a weekly refresh stored procedure
- Created a scheduled Snowflake task
- Designed a table function for cost burden analysis
- Built dashboard-ready metrics for healthcare claims analysis

## Repository Structure

- `sql/` — Snowflake SQL scripts for curation, procedures, aggregation, functions, and tasks
- `dashboard/` — Streamlit dashboard code

## Main Analysis Questions

- How much are members paying out of pocket?
- Which claims have higher member cost burden?
- How do prescription costs and savings vary by claim type?
- How can claims data be curated into dashboard-ready healthcare analytics?

## Notes

This project was completed as part of a data warehousing course. The dataset was de-identified prescription claims data accessed through Snowflake Marketplace.
