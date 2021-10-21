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
order by TotalDeathCount desc 

--Break things down by continet -- highest death count per population 

select continent, MAX(cast(Total_deaths as Int)) as TotalDeathCount
from CovidDeaths;
-- Where location like '%states%'
where continent Is null 
Group by Location,
order by TotalDeathCount desc 

-- GLOBAL NUMBERS
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage,
from CovidDeaths;
--Where location like '%states%'
where continent is not null
Group BY date
order by 1, 2

-- Looking at Total Population vs Vaccinations
-- changing data to be an integer using CONVERT
Select * dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
  on dea.location = vac.Location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select * dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
  on dea.location = vac.Location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp TABLE

--DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255) ,
Location nvarchar(255)
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into
Select * dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
  on dea.location = vac.Location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View #PercentPopulationVaccinated as
Select * dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
  on dea.location = vac.Location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
