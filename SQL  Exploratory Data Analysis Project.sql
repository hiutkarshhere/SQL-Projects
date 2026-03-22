/*
    Project: Layoffs Data Analysis (EDA) 

    Workflow:
    - Initial data exploration
    - Company-level analysis
    - Industry & country trends
    - Time-based analysis (yearly, monthly, rolling)
    - Stage-wise insights
    - Summary statistics
    
    Objective:
    Identify patterns and trends in layoffs across companies,
    industries, locations, and time.
*/

-- 1. Initial exploration
SELECT * 
FROM layoffs_dedup;

SELECT 
    MAX(total_laid_off) AS max_laid_off,
    MAX(percentage_laid_off) AS max_percentage
FROM layoffs_dedup;

-- Companies with complete layoffs
SELECT *
FROM layoffs_dedup
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- 2. Company-level insights

-- Total layoffs by company
SELECT 
    company,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_dedup
GROUP BY company
ORDER BY total_laid_off DESC;

-- Year-wise layoffs by company
SELECT 
    company,
    YEAR(`date`) AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_dedup
GROUP BY company, YEAR(`date`)
ORDER BY year, total_laid_off DESC;

-- Ranking companies by layoffs each year
WITH company_year AS (
    SELECT 
        company,
        YEAR(`date`) AS year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_dedup
    GROUP BY company, YEAR(`date`)
)
SELECT 
    company,
    year,
    total_laid_off,
    DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS rank_in_year
FROM company_year
WHERE year IS NOT NULL;


-- 3. Industry & country trends

SELECT 
    industry,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_dedup
GROUP BY industry
ORDER BY total_laid_off DESC;

SELECT 
    country,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_dedup
GROUP BY country
ORDER BY total_laid_off DESC;


-- 4. Time-based analysis

-- Date range
SELECT 
    MIN(`date`) AS start_date,
    MAX(`date`) AS end_date
FROM layoffs_dedup;

-- Yearly layoffs
SELECT 
    YEAR(`date`) AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_dedup
GROUP BY YEAR(`date`)
ORDER BY year;

-- Monthly layoffs
SELECT 
    DATE_FORMAT(`date`, '%Y-%m') AS month,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_dedup
GROUP BY month
ORDER BY month;

-- Rolling total layoffs
WITH monthly_data AS (
    SELECT 
        DATE_FORMAT(`date`, '%Y-%m') AS month,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_dedup
    GROUP BY month
)
SELECT 
    month,
    total_laid_off,
    SUM(total_laid_off) OVER (ORDER BY month) AS rolling_total
FROM monthly_data;


-- 5. Stage-wise layoffs
SELECT 
    stage,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_dedup
GROUP BY stage
ORDER BY total_laid_off DESC;


-- 6. Overall average layoffs
SELECT 
    AVG(total_laid_off) AS avg_laid_off
FROM layoffs_dedup;