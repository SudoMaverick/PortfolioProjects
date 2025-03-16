-- EXPLORATORY DATA ANALYSIS

USE world_layoffs;

SELECT * 
FROM world_layoffs.layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;


-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;
-- these are mostly startups that went out of business during that time period

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- by location
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Following queries give us an insight into total layoffs in the time period of 3 years grouped by different columns

SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, SUM(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Following query gives us an insight into month wise Progression of Layoffs in that time period

With rolling_total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


-- Ranking Companies on the basis of layoffs made year-wise

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5
;


