-- In the dataset Location and continent have values that overlap. I.e. location as well as continent can be Africa 
Select *
From PortfolioProject..CovidDeaths
Where continent Is not null 
order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths;
order by 1, 2 

-- Looking at Total Cases vs Total Deaths 
-- Shows the likelihood of dying If you contract covid by country

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage,
from CovidDeaths;
Where location like '%states%'
order by 1, 2 

-- Looking at Total Cases vs Pupulation
-- Shows percentage of population that contracted Covid

select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected,
from CovidDeaths;
Where location like '%states%'
order by 1, 2 

-- Looking at Countries with Highest Infection Rate compared to Population

select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected,
from CovidDeaths;
-- Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc 

-- Shows Countries with Highest Death Count per Population

select Location, MAX(cast(Total_deaths as Int)) as TotalDeathCount
from CovidDeaths;
-- Where location like '%states%'
Group by Location,
order by PercentPopulationInfected desc 

--Break things down by continet -- highest death count per population 

select continent, MAX(cast(Total_deaths as Int)) as TotalDeathCount
from CovidDeaths;
-- Where location like '%states%'
where continent Is null 
Group by Location,
order by PercentPopulationInfected desc 
