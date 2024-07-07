-- -----------------------------------------------------------------------------------
-- World_Layoff Exploratory Data Analysis
-- -----------------------------------------------------------------------------------
USE world_layoffs;
-- Checking the data beforehand to make sure you are using the correct data hehe!
SELECT * 
FROM layoffs_staging_2;

SELECT COUNT(*) -- A total of 1995 records left after Data Cleaning 
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- Checking the max of both KPI from the table
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- Checking the companies with 100 percent layoffs
SELECT * 
FROM layoffs_staging_2
WHERE percentage_laid_off = 100
ORDER BY total_laid_off DESC;
SELECT COUNT(*) -- 116 total companies went under according to this dataset geez!
FROM layoffs_staging_2
WHERE percentage_laid_off = 100;
-- -----------------------------------------------------------------------------------
-- Finding the total layoff by each company
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging_2
GROUP BY company
ORDER BY total_layoffs DESC;
-- -----------------------------------------------------------------------------------
-- Finding the start and end of data collection  
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- Total laid off 
SELECT SUM(total_laid_off)
FROM layoffs_staging_2;
-- -----------------------------------------------------------------------------------
-- What Industry had the most layoffs during 2020-03-11 to 2023-03-06
SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging_2
GROUP BY industry
ORDER BY total_layoffs DESC;
-- -----------------------------------------------------------------------------------
-- Which country had the highest layoffs?
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging_2
GROUP BY country
ORDER BY total_layoffs DESC;
-- -----------------------------------------------------------------------------------
-- Analysing the percentage layoff of each industry wrt whole layoffs season
WITH total_laid (industry ,total_layoffs) AS (
	SELECT industry, SUM(total_laid_off) AS total_layoffs
	FROM layoffs_staging_2
	GROUP BY industry
)
SELECT tl.industry, (tl.total_layoffs / SUM(l.total_laid_off))*100 AS percent_layoffs
FROM layoffs_staging_2 AS l, total_laid AS tl
GROUP BY tl.industry
ORDER BY percent_layoffs DESC;
-- -----------------------------------------------------------------------------------
-- Analysing the percentage layoff of each country wrt world wide layoffs season
WITH total_laid (country ,total_layoffs) AS (
	SELECT country, SUM(total_laid_off) AS total_layoffs
	FROM layoffs_staging_2
	GROUP BY country
)
SELECT tl.country, (tl.total_layoffs / SUM(l.total_laid_off))*100 AS percent_layoffs
FROM layoffs_staging_2 AS l, total_laid AS tl
GROUP BY tl.country
ORDER BY percent_layoffs DESC;
-- -----------------------------------------------------------------------------------
-- Analysing the total layoffs wrt year
SELECT Year(`date`), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
-- -----------------------------------------------------------------------------------
-- Rolling total Layoffs by months
WITH Rolling_Total AS(
	SELECT SUBSTRING(`date`, 1,7) AS months, SUM(total_laid_off) AS total_off
	FROM layoffs_staging_2
	WHERE SUBSTRING(`date`, 1,7) IS NOT NULL 
	GROUP BY months
	ORDER BY months
)
SELECT months, total_off,
SUM(total_off) OVER(ORDER BY months) AS rolling_total
FROM Rolling_Total;
-- -----------------------------------------------------------------------------------
-- Layoffs per year by companies and ranking them
SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging_2
GROUP BY company, YEAR(`date`)
ORDER BY total_layoffs DESC;
-- Now who comes first in the ranking
WITH Company_Year AS (
	SELECT company, YEAR(`date`) AS Year_, SUM(total_laid_off) AS total_layoffs
	FROM layoffs_staging_2
	GROUP BY company, YEAR(`date`)
), 
Company_Rank AS (
	SELECT *, DENSE_RANK() OVER(PARTITION BY Year_ ORDER BY total_layoffs DESC) AS Ranking
	FROM Company_Year
	WHERE Year_ IS NOT NULL
)
SELECt *
FROM Company_Rank
WHERE Ranking <= 5;
-- -----------------------------------------------------------------------------------
-- this can also be done with industry or country






