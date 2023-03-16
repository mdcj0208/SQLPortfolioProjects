--The dataset that I'm working with contains world covid data
--Looking at Total Cases vs Total Deaths

SELECT
	location,
	date,
	CAST(total_cases AS FLOAT) AS total_cases,
	CAST(total_deaths AS FLOAT) AS total_deaths,
	(CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT)) *100 AS death_percentage
FROM
	SQLPortfolioProject.dbo.covid_deaths
ORDER BY 1,2


--Since I live in the United States, I'm going to limit the filter to US first
--Gives us insight on the likelihood of dying from Covid

SELECT
	location,
	date,
	CAST(total_cases AS FLOAT) AS total_cases,
	CAST(total_deaths AS FLOAT) AS total_deaths,
	(CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT)) *100 AS death_percentage
FROM
	SQLPortfolioProject.dbo.covid_deaths
WHERE location LIKE '%States%'
ORDER BY 1,2


--Now we'll look into the same data but for Russia then China

SELECT
	location,
	date,
	CAST(total_cases AS FLOAT) AS total_cases,
	CAST(total_deaths AS FLOAT) AS total_deaths,
	(CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT)) *100 AS death_percentage
FROM
	SQLPortfolioProject.dbo.covid_deaths
WHERE location LIKE '%Russia%'
ORDER BY 1,2

SELECT
	location,
	date,
	 total_cases,
	 total_deaths,
	(CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT)) *100 AS death_percentage
FROM
	SQLPortfolioProject.dbo.covid_deaths
WHERE location LIKE '%China%'
ORDER BY 1,2

--We'll next look at the Case to Population ratio next in US

SELECT
	location,
	date,
	total_cases,
	population,
	(CAST(total_cases AS FLOAT)/population)*100 AS case_percentage
FROM
	SQLPortfolioProject.dbo.covid_deaths
WHERE 
	location LIKE '%States%'
ORDER BY 1,2


--We then check the medain age to cases over an extended period of time along with the total deaths amongst the median age 

SELECT
	location,
	date,
	median_age,
	total_cases,
	total_deaths,
	population,
	(median_age/CAST(total_cases AS FLOAT)) AS median_age_cases,
	(median_age/CAST(total_deaths AS FLOAT)) AS median_age_deaths
FROM 
	SQLPortfolioProject.dbo.covid_deaths
WHERE location ='United States'
ORDER BY
	1,
	2,
	median_age_cases,
	median_age_deaths

--Now we'll look at the continents for total cases and death count

SELECT DISTINCT
	location,
	MAX(CAST(total_cases AS INT)) AS total_case_count
FROM 
	SQLPortfolioProject.dbo.covid_deaths
WHERE
	continent IS NOT NULL
GROUP BY
	location
ORDER BY total_case_count
DESC

SELECT DISTINCT
	location,
	MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM 
	SQLPortfolioProject.dbo.covid_deaths
WHERE
	continent IS NOT NULL
GROUP BY
	location
ORDER BY total_death_count
DESC

--Looking at the total deaths per location in North America
SELECT
	covid_deaths.continent,
	covid_deaths.location,
	covid_deaths.date,
	covid_deaths.population,
	SUM(CAST(total_deaths AS INT)) OVER (PARTITION BY location) AS deaths_by_location
FROM 
	SQLPortfolioProject.dbo.covid_deaths
WHERE 
	continent='North America'
ORDER BY 1,2

--Using a CTE

WITH deaths_per_loc (continent, location, date, population, deaths_by_location) AS 
(
SELECT
	covid_deaths.continent,
	covid_deaths.location,
	covid_deaths.date,
	covid_deaths.population,
	SUM(CAST(total_deaths AS INT)) OVER (PARTITION BY location) AS deaths_by_location
FROM 
	SQLPortfolioProject.dbo.covid_deaths
WHERE 
	continent='North America'
)
SELECT * FROM deaths_per_loc
