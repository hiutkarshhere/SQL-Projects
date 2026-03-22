/*
-Project: Layoffs Data Cleaning (Data used is attached in the Github repositry)

-Workflow Overview:
    1. Create staging table from raw data
    2. Identify and remove duplicate records
    3. Standardize text fields (company, industry, country)
    4. Convert date column to proper format
    5. Handle missing and null values
    6. Output cleaned dataset for analysis

-Note to the reader:
    This script transforms raw layoffs data into a clean,
    analysis-ready dataset suitable for EDA and visualization
*/

-- 1. Create a working table
CREATE TABLE layoffs_staging AS
SELECT *
FROM layoffs;

SELECT * FROM layoffs_staging;


-- 2. Remove duplicate records
DROP TABLE IF EXISTS layoffs_dedup;

CREATE TABLE layoffs_dedup AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry,
                            total_laid_off, percentage_laid_off,
                            `date`, stage, country, funds_raised_millions
           ) AS rn
    FROM layoffs_staging
) t
WHERE rn = 1;


-- 3. Standardize text fields

-- Clean company names
UPDATE layoffs_dedup
SET company = TRIM(company);

-- Fix industry naming inconsistencies
UPDATE layoffs_dedup
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

-- Normalize country names
UPDATE layoffs_dedup
SET country = 'United States'
WHERE country LIKE '%United States%';


-- 4. Fix date format
UPDATE layoffs_dedup
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_dedup
MODIFY COLUMN `date` DATE;


-- 5. Handle missing values

-- Convert blanks to NULL
UPDATE layoffs_dedup
SET industry = NULL
WHERE industry = '' OR industry = ' ';

-- Fill missing industry using same company data
UPDATE layoffs_dedup t1
JOIN layoffs_dedup t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Remove unusable rows
DELETE FROM layoffs_dedup
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- 6. Final cleaned dataset
SELECT * FROM layoffs_dedup;