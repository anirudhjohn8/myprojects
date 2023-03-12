SELECT * FROM PortfolioProject..Covid
Where continent is not null
Order by 3,4


SELECT location,date,total_cases,new_cases,total_deaths,population FROM PortfolioProject..Covid
Order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract Covid in India
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage FROM PortfolioProject..Covid
Where location like '%india%'
Order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid in India

SELECT location,date,total_cases,population,(total_cases/population)*100 as InfectionRate FROM PortfolioProject..Covid
Where location like '%india%'
Order by 1,2

--Looking at countries with highest infection rate as compared to population

SELECT location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as InfectionRate FROM PortfolioProject..Covid
Group by location,population
Order by InfectionRate DESC

--Looking at continents with highest death count

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount FROM PortfolioProject..Covid
Where continent is not null
Group by continent
Order by TotalDeathCount DESC

--Global Numbers Datewise

SELECT date,SUM(new_cases)as totalcases, SUM(cast(new_deaths as int))as totaldeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as TotalDeathPercentage FROM PortfolioProject..Covid
Where continent is not null
Group by date
Order by 1

--Looking at Total Population Vs Vaccinations

SELECT dea.date,dea.continent,dea.location,dea.population, vac.new_vaccinations,vac.total_vaccinations,(vac.total_vaccinations/dea.population)*100 as VaccinationRate
FROM PortfolioProject..Covid dea
JOIN PortfolioProject..vaccine vac
	ON dea.location=vac.location
	AND dea.date=vac.date
	WHERE dea.continent is not null

--Creating view to store data for later visulaizations

CREATE View HighestInfectionRate as
SELECT location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as InfectionRate FROM PortfolioProject..Covid
Group by location,population