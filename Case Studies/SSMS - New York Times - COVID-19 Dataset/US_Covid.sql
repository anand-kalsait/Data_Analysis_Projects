-- Using Master to Initiate
USE master;
GO

-- Checking existing DB_ID 
IF	DB_ID('US_Covid') IS NOT NULL
BEGIN
	ALTER DATABASE US_Covid SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE US_Covid;
END;
GO

-- Creating Database without Schema
CREATE DATABASE US_Covid;
GO

-- Database In Use here
USE US_Covid;
GO

-- Imported 3 csv files as flat files with the following names:
-- us_states, us_counties, us_country 
-- no PK or FK configured as the data collected in different ways

-- Checking the row count to make sure the data was imported safely
SELECT COUNT(*) FROM us_country;
SELECT COUNT(*) FROM us_counties;
SELECT COUNT(*) FROM us_states;
SELECT COUNT(*) FROM us_states;

