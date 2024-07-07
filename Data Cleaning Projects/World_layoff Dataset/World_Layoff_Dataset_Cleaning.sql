-- -----------------------------------------------------------------------------------
-- Data Cleaning Project for the 'World Layoffs' Dataset
-- -----------------------------------------------------------------------------------
SELECT *
FROM layoffs;

-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- # Removing Duplicates
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- Creating a staging table to not tamper with the raw data
CREATE TABLE layoffs_staging
LIKE layoffs;
-- -----------------------------------------------------------------------------------
-- Inserting data into the staging table as to not touch the RAW DATA
INSERT layoffs_staging
SELECT * 
FROM layoffs;
-- -----------------------------------------------------------------------------------
-- Checking the layoffs_staging table 
SELECT * 
FROM layoffs_staging;
-- -----------------------------------------------------------------------------------
-- Identifying Duplicates in the data
WITH duplicate_cte AS (
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
        total_laid_off, percentage_laid_off, `date`, 
        stage, country, funds_raised_millions) AS row_num, ls.*
	FROM layoffs_staging as ls
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1;
-- -----------------------------------------------------------------------------------
-- Checking result example to check the rusults are actually duplicates or not
SELECT * 
FROM layoffs_staging
WHERE company = 'Wildlife Studios';

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';
-- Here in company Casper's Case there is a pair of duplicates and a non dupilicate one
-- -----------------------------------------------------------------------------------
-- So we will be creating another staging table just to be safe
CREATE TABLE `layoffs_staging_2` (
  `row_num` int,
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- -----------------------------------------------------------------------------------
-- Inserting data from layoffs_staging into layoffs_staging_2 with row_number() to identify duplicates easily
INSERT INTO layoffs_staging_2
SELECT 
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, 
	total_laid_off, percentage_laid_off, `date`, 
	stage, country, funds_raised_millions) AS row_num, ls.*
FROM layoffs_staging as ls;
-- -----------------------------------------------------------------------------------
-- Checking the layoffs_staging_2 table 
SELECT *
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- Checking the duplicates again
SELECT * 
FROM layoffs_staging_2
WHERE row_num > 1;
-- -----------------------------------------------------------------------------------
-- Setting SQL_SAFE_UPDATES to 0 to make updates to the tables
SET SQL_SAFE_UPDATES = 0;
-- -----------------------------------------------------------------------------------
-- Deleting Duplicates from layoffs_staging_2 to keep the RAW DATA intact
DELETE
FROM layoffs_staging_2
WHERE row_num > 1;
-- Checking the company Casper to make sure duplicates are deleted properly
SELECT * 
FROM layoffs_staging_2
WHERE company = 'Casper';

SELECT COUNT(*) -- 2356 distinct records after deleting duplicates as they were 2361 before
FROM layoffs_staging_2;

-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- # Standardize the Data after Data Profiling
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
SELECT *
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- After some observation, we can see the company attribute's records have white spaces
SELECT DISTINCT company, (TRIM(company))
FROM layoffs_staging_2;
-- Trim down the white spaces in company attribute
UPDATE layoffs_staging_2
SET company = TRIM(company);
SELECT *
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- Now check industry attribute for any errors, null, typos, etc
SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY 1;
-- Checking all crypto industry recordes to decide on proper changes to be made
SELECT *
FROM layoffs_staging_2
WHERE industry LIKE 'Crypto%';
-- Updating all like Crypto% to proper format
UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- -----------------------------------------------------------------------------------
-- Now check location attribute for any errors, null, typos, etc
SELECT DISTINCT location
FROM layoffs_staging_2
ORDER BY 1;
-- -----------------------------------------------------------------------------------
-- Now check country attribute for any errors, null, typos, etc
SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY 1;
-- Checking USA country records 
SELECT *
FROM layoffs_staging_2
WHERE country LIKE 'United States%';
-- Trim the period 
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging_2
ORDER BY 1;
-- Updating the findings in country attribute
UPDATE layoffs_staging_2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
-- Checking the update is made correctly
SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY 1;
-- -----------------------------------------------------------------------------------
-- Updating date attribute fro text to date format
SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y') as formatted_date
FROM layoffs_staging_2;
-- Updating the date to proper format
UPDATE layoffs_staging_2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- Checking the updates
SELECT `date`
FROM layoffs_staging_2;
-- Updating the column typr fro text to date now that we have date in proper format
ALTER TABLE layoffs_staging_2
MODIFY COLUMN `date` DATE;

-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- # Dealing with Null Values or Missing Values
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- Observing NULL values in all attribute
SELECT *
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- Focusing on total_laid_off attribute for dealing with NULL values
SELECT * 
FROM layoffs_staging_2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
SELECT COUNT(*) -- 361 Records with NULL in both total_laid_off and percentage_laid_off
FROM layoffs_staging_2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
-- -----------------------------------------------------------------------------------
-- Focusing on industry attribute with NULL values
SELECT industry
FROM layoffs_staging_2
ORDER BY 1;
-- Checking records with the missing and NULL values
SELECT *
FROM layoffs_staging_2
WHERE industry IS NULL OR industry = '';
-- Checking some results to see if they can be populated or not
SELECT *
FROM layoffs_staging_2
WHERE company = 'Airbnb';
-- -----------------------------------------------------------------------------------
-- Checking if there are any other industries like Airbnb in other locations with null or missing values
SELECT t1.industry AS t1_ind, t2.industry AS t2_ind
FROM layoffs_staging_2 AS t1
INNER JOIN
	layoffs_staging_2 AS t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
-- Updating Missing Values to NULL because Missing Values will interfere with assignment of Null Values
UPDATE layoffs_staging_2
SET industry = NULL 
WHERE industry = '';
-- Updating the industry attribute's missing or NUll Values
UPDATE layoffs_staging_2 AS t1
INNER JOIN 
	layoffs_staging_2 AS t2 
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
-- Checking if this worked
SELECT t1.industry AS t1_ind, t2.industry AS t2_ind
FROM layoffs_staging_2 AS t1
INNER JOIN
	layoffs_staging_2 AS t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
-- Checking the assigned industry to the Airbnb result
SELECT *
FROM layoffs_staging_2
WHERE company = 'Airbnb';
-- -----------------------------------------------------------------------------------
-- Checking the industry attribute for the changes made or any other missing or null values
SELECT * 
FROM layoffs_staging_2
WHERE industry = '' or industry IS NULL;
-- Finding other Bally's Interactive company's records
SELECT *
FROM layoffs_staging_2
WHERE company LIKE 'Bally%';
-- -----------------------------------------------------------------------------------
-- The percentage_laid_off attribute needs to be INT type but is text
SELECT percentage_laid_off
FROM layoffs_staging_2;
-- Converting percentage_laid_off values into readable format
UPDATE layoffs_staging_2
SET percentage_laid_off = percentage_laid_off*100.00;
-- Converting percentage_laid_off from text to int type
ALTER TABLE layoffs_staging_2
MODIFY COLUMN percentage_laid_off INT;
-- Confirming the changes
SELECT * 
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- Coming back to NULL in both total_laid_off and percentage_laid_off
SELECT * 
FROM layoffs_staging_2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
SELECT COUNT(*) -- 361 Records with NULL in both total_laid_off and percentage_laid_off
FROM layoffs_staging_2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
-- Deleting these records might not affect the analysis as the KPI need both of the values
DELETE
FROM layoffs_staging_2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
-- Remaining records in the layoffs_staging_2
SELECT COUNT(*) -- 1995 Records remaining from the 2361 initial Records
FROM layoffs_staging_2;

-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- # Romoving any Columns deemed unnecessary
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- Dropping the row_num column as it is not needed anymore
ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;
-- Observing the Finalize data for any more cleaning
SELECT *
FROM layoffs_staging_2;
-- -------------------------------------END-------------------------------------------







