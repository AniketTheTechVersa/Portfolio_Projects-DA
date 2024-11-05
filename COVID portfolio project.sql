SELECT* FROM CovidDeaths$
--SELECT * FROM Vaccinations$

--SELECT DATA THAT WE ARE GOING TO BE USING

SELECT  location, date,total_cases, new_cases, total_deaths, population
From CovidDeaths$
WHERE Continent is not null
ORDER BY 1,2

--LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- Shows the chances of dying if you got infected by COVID

SELECT  location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From CovidDeaths$
WHERE location like '%India%'
WHERE Continent is not null
ORDER BY total_cases DESC

--Looking at Total cases vs Population
--Shows what percentage of population got COVID
SELECT  location, date, Population, total_cases, (total_cases/population)*100 as POP_infectedpercentage
From CovidDeaths$
WHERE location like '%India%'
WHERE Continent is not null
ORDER BY total_cases DESC

--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT  location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as POP_infectedpercentage
From CovidDeaths$
--WHERE location like '%India%'
WHERE Continent is not null
GROUP BY location, Population
ORDER BY POP_infectedpercentage DESC

-- SHWING COUNTRUES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT  location, MAX(CAST(Total_deaths as int)) as TotaldeathCount
From CovidDeaths$
--WHERE location like '%India%'
WHERE Continent is not null
GROUP BY location
ORDER BY TotaldeathCount DESC

--BREAK DOWN BY CONTINENT
SELECT Location, MAX(CAST(Total_deaths as int)) as TotaldeathCount
FROM CovidDeaths$
WHERE continent is null AND Location IN ('Europe','North America','South America', 'Asia', 'Africa', 'Oceania')
GROUP BY Location
ORDER BY TotaldeathCount DESC

--GLOBAL NUMBERS
SELECT  
SUM(CAST(total_cases as BIGINT)) as TOTAL, 
SUM(CAST(total_deaths as BIGINT))as D_T,
(SUM(CAST(total_deaths AS BIGINT))*100.0 / NULLIF(SUM(CAST(total_cases AS BIGINT)), 0)) AS Deaths_Percentage
From CovidDeaths$
WHERE continent is not null
order by 1,2


SELECT*FROM VACCINATIONS$

--looking at total population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER(partition by dea.location Order by dea.location, dea.date) as ROLLINGPEOPLEVAC
FROM CovidDeaths$ dea
JOIN VACCINATIONS$ vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null 
order by 2,3


--SELECT 
--    dea.continent, 
--    dea.location, 
--    dea.date, 
--    dea.population, 
--    vac.new_vaccinations,
--    SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS ROLLINGPEOPLEVAC
--FROM (
--    SELECT DISTINCT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--    FROM CovidDeaths$ dea
--    JOIN VACCINATIONS$ vac
--        ON dea.location = vac.location
--        AND dea.date = vac.date
--) AS UniqueEntries
--WHERE continent IS NOT NULL
--ORDER BY location, date;


With Popsvac (Continent, location, date, Population, new_vaccinations, ROLLINGPEOPLEVAC)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER(partition by dea.location Order by dea.location, dea.date) as ROLLINGPEOPLEVAC
FROM CovidDeaths$ dea
JOIN VACCINATIONS$ vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null  AND dea.location like '%Albania%'
--order by 2,3
)
SELECT *, (ROLLINGPEOPLEVAC/Population)*100
FROM Popsvac

--Creating view to store data for later visualisations

Create View DEATHSBYCONTINENTS AS
SELECT Location, MAX(CAST(Total_deaths as int)) as TotaldeathCount
FROM CovidDeaths$
WHERE continent is null AND Location IN ('Europe','North America','South America', 'Asia', 'Africa', 'Oceania')
GROUP BY Location
--ORDER BY TotaldeathCount DESC

