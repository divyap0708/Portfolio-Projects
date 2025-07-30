--- DATA CLEANING (more usable format)


SELECT *
FROM layoffs;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

#Always create a staging table - do not alter raw data
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
partition by company, industry, total_laid_off, percentage_laid_off,`date`) AS row_num
FROM layoffs_staging;

#It needs to incude all columns to find duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

#This will not delete the duplicates - have to create another staging table
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
Delete 
FROM duplicate_cte
WHERE row_num > 1;

#Creating another staging table from first one to delete duplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num >1;

#Insert data from first staging table to this.
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

#Delete all duplicates
DELETE
FROM layoffs_staging2
WHERE row_num >1;

SELECT *
FROM layoffs_staging2;


---- Standardizing Data

#Remove leading spaces from company
SELECT DISTINCT(TRIM(company))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
order by 1;

#There are 3 different industry for Crypto -Fix it
SELECT *
FROM layoffs_staging2
WHERE industry like 'Crypto%';

#Changing all 3 crypto to the same
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_staging2
order by 1;


#United States has been written in 2 different ways
SELECT DISTINCT country
FROM layoffs_staging2
where country like 'United States%'
order by 1;

SELECT DISTINCT country, TRIM(TRAILING '.' from country)
FROM layoffs_staging2
order by 1;

#Removing '.' after United States
Update layoffs_staging2
set country = TRIM(TRAILING '.' from country)
where country like 'United States%';

#Changing date to correct format
SELECT `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_staging2
;

update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

#Changing date type to 'Date' from 'Text'
ALTER TABLE layoffs_staging2
modify column `date` DATE;


---- 3. Null Values

select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is null
;

update layoffs_staging2
set industry = NULL
where industry = '';

select *
from layoffs_staging2
where industry is null
or industry = '';

select *
from layoffs_staging2
where company = 'Airbnb';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where t1.industry is null 
and t2.industry is not null
    ;
    
#Updating known industry for company which were left blank (e.g. airbnb - one had Travel listed as Industry and other was null)
update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;


select *
from layoffs_staging2;


select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is null
;

#Deleting rows where both total_laid_off and percentage_laid_off is Null
delete
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is null
;

select *
from layoffs_staging2;

#Dropping the extra colum 'row_num' which is not needed
alter table layoffs_staging2
drop column row_num;
