-- ================================
-- 1. Basic Exploration
-- ================================
SELECT * 
FROM tablex;

-- Maximum layoffs and percentage
SELECT 
    MAX(total_laid_off) AS max_laid_off, 
    MAX(percentage_laid_off) AS max_percentage
FROM tablex;

-- Companies with 100% layoffs, ordered by funds raised
SELECT *
FROM tablex
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- ================================
-- 2. Company-Level Aggregations
-- ================================
-- Total layoffs per company
SELECT 
    company, 
    SUM(total_laid_off) AS total_laid_off
FROM tablex
GROUP BY company
ORDER BY total_laid_off DESC;

-- Company layoffs by year
SELECT 
    company, 
    YEAR(`date`) AS year, 
    SUM(total_laid_off) AS total_laid_off
FROM tablex
GROUP BY company, YEAR(`date`)
ORDER BY total_laid_off DESC;

-- Ranking layoffs per company by year
WITH CompanyYear AS (
    SELECT 
        company, 
        YEAR(`date`) AS year, 
        SUM(total_laid_off) AS total_laid_off
    FROM tablex
    GROUP BY company, YEAR(`date`)
)
SELECT 
    company, 
    year, 
    total_laid_off,
    DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
FROM CompanyYear
WHERE year IS NOT NULL
ORDER BY year ASC, total_laid_off DESC;

-- ================================
-- 3. Industry & Country-Level Aggregations
-- ================================
-- Layoffs per industry
SELECT 
    industry, 
    SUM(total_laid_off) AS total_laid_off
FROM tablex
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Layoffs per country
SELECT 
    country, 
    SUM(total_laid_off) AS total_laid_off
FROM tablex
GROUP BY country
ORDER BY total_laid_off DESC;

-- ================================
-- 4. Date-Based Analysis
-- ================================
-- Earliest and latest layoff dates
SELECT 
    MIN(`date`) AS first_date, 
    MAX(`date`) AS last_date
FROM tablex;

-- Layoffs per year
SELECT 
    YEAR(`date`) AS year, 
    SUM(total_laid_off) AS total_laid_off
FROM tablex
GROUP BY YEAR(`date`)
ORDER BY year DESC;

-- Layoffs per month
SELECT 
    SUBSTRING(`date`,1,7) AS month, 
    SUM(total_laid_off) AS total_laid_off
FROM tablex
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY month
ORDER BY month ASC;

-- Rolling total layoffs per month
WITH MonthlyLayoffs AS (
    SELECT 
        SUBSTRING(`date`,1,7) AS month, 
        SUM(total_laid_off) AS total_off
    FROM tablex
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY month
    ORDER BY month ASC
)
SELECT 
    month, 
    total_off, 
    SUM(total_off) OVER (ORDER BY month) AS rolling_total
FROM MonthlyLayoffs;

-- ================================
-- 5. Stage-Level Analysis
-- ================================
SELECT 
    stage, 
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- ================================
-- 6. Averages
-- ================================
-- Average layoffs across all companies
SELECT 
    AVG(total_laid_off) AS avg_laid_off
FROM tablex;
