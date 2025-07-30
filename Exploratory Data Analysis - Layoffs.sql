-- Exploratory Data Analysis

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers
select *
from layoffs_staging2;

-- EASIER QUERIES
select MAX(total_laid_off), MAX(percentage_laid_off)
from layoffs_staging2;

-- Which companies had 1 which is basically 100 percent of they company laid off
select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funds_raised_millions we can see how big some of these companies were
select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- Companies with the most Total Layoffs
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 DESC;

-- by location
SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

select min(`date`), max(`date`)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 DESC;

select *
from layoffs_staging2;

-- by country
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 DESC;

-- this it total in the past 3 years or in the dataset
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 DESC;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 1 DESC;


-- TOUGHER QUERIES------------------------------------------------------------------------------------------------------------------------------------

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.

WITH Company_Year (company, years, total_laid_off) AS
(
select company, YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
FROM Company_Year
where years is not null
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5;

#Progression - Rolling Total Layoffs

select substring(`date`,1,7) as `Month`, SUM(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc;

-- now use it in a CTE so we can query off of it
WITH Rolling_Total As
(
select substring(`date`,1,7) as `Month`, SUM(total_laid_off) As total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`, total_off , sum(total_off) OVER(order by `Month`) As rolling_total
from Rolling_Total;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 DESC;

select company, YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, YEAR(`date`)
order by 3 desc;





# The argument here is that a large company with a layoff proportion of 0.05 could still show more people being laid off, then a smaller company with a layoff proportion of 0.7, even though this gives valuable insight that the past 3 years have hit small companies very hard.

SELECT stage, ROUND(AVG(percentage_laid_off),2)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

