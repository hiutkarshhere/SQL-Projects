-- ============================================================
-- STEP 1: Create a working copy (staging table)
-- ============================================================
CREATE TABLE layoffs_testing AS
SELECT *
FROM layoffs;

-- Quick check
SELECT * FROM layoffs_testing;


-- ============================================================
-- STEP 2: Remove duplicates
-- ============================================================
-- Use ROW_NUMBER() to identify duplicates based on key columns
DROP TABLE IF EXISTS tablex;
CREATE TABLE tablex AS
WITH cte1 AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry,
                            total_laid_off, percentage_laid_off,
                            `date`, stage, country, funds_raised_millions
               ORDER BY company
           ) AS row_num
    FROM layoffs_testing
)
SELECT *
FROM cte1;

-- Inspect duplicates
SELECT * FROM tablex WHERE row_num > 1;

-- Store duplicates separately (optional audit table)
CREATE TABLE tabley AS
SELECT *
FROM tablex
WHERE row_num > 1;

-- Delete duplicates from main table
DELETE FROM tablex
WHERE row_num > 1;


-- ============================================================
-- STEP 3: Refresh staging table with cleaned data
-- ============================================================
TRUNCATE TABLE layoffs_testing;

INSERT INTO layoffs_testing
SELECT company, location, industry,
       total_laid_off, percentage_laid_off,
       `date`, stage, country, funds_raised_millions
FROM tablex;

-- Verify
SELECT * FROM layoffs_testing;


-- ============================================================
-- STEP 4: Standardize text fields
-- ============================================================

-- Remove leading/trailing spaces in company names
UPDATE tablex
SET company = TRIM(company);

-- Standardize industry names (example: crypto variations → "Crypto")
UPDATE tablex
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

-- Standardize country names
UPDATE tablex
SET country = 'United States'
WHERE country LIKE '%United States%';

-- Remove trailing dots in country names (alternative approach)
-- UPDATE tablex
-- SET country = TRIM(TRAILING '.' FROM country)
-- WHERE country LIKE 'United States%';


-- ============================================================
-- STEP 5: Standardize date column
-- ============================================================
-- Convert string dates to proper DATE type
UPDATE tablex
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` LIKE '%/%/%';

-- Alter column type to DATE
ALTER TABLE tablex
MODIFY COLUMN `date` DATE;


-- ============================================================
-- STEP 6: Handle NULLs and blanks
-- ============================================================

-- Normalize blank industries to NULL
UPDATE tablex
SET industry = NULL
WHERE industry IS NULL OR industry = '' OR industry = ' ';

-- Fill missing industry values using other rows from same company
UPDATE tablex t1
JOIN tablex t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Remove rows where both layoff counts are missing
DELETE FROM tablex
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- ============================================================
-- STEP 7: Final verification
-- ============================================================
SELECT * FROM tablex;
