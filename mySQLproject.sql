/*
SQL Portfolio Project
prepared by Mohamed Ibrahim
July 2024

There are 2 parts:
- Data Exploration
- Data Cleaning
*/

/*//////////
/ PART ONE /	DATA EXPLORATION
////////////	COVID 19

Input file: https://github.com/owid/covid-19-data/blob/master/public/data/owid-covid-data.csv 
The columns of file are split into 2 files: CovidDeaths.xlsx and CovidVaccinations.xlsx where the first few columns are common in both files.
*/

-- Number of rows
Select count(*)
From CovidDeaths
-- result is 409924

-- Names and types of columns
Select COLUMN_NAME, DATA_TYPE
From INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'CovidDeaths'

Select top (1000) *
From PortfolioProject..CovidDeaths
Where continent is not null 		-- to exclude aggregation rows
order by 3,4						-- by location and date


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you get covid

Select Location, date, total_cases, total_deaths, (total_deaths/cast(total_cases as int))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2

-- For a specific country like Canada
Select Location, date, total_cases, total_deaths, (total_deaths/cast(total_cases as int))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
and location = 'Canada'
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/cast(population as int))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location = 'Canada'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max(total_cases/cast(population as int))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location = 'Canada'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine and shows Cumulative Vaccinated per day per country

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on 'Partition By' in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinatedPercent
From PopvsVac



-- Using Temp Table to perform Calculation on 'Partition By' in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinatedPercent
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 




/*//////////
/ PART TWO /	DATA CLEANING
////////////	NASHVILLE HOUSING

Input file: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning%20(reuploaded).xlsx
*/

-- Number of rows
Select count(*)
From Nashville
-- result is 56477

-- Names and types of columns
Select COLUMN_NAME, DATA_TYPE
From INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'Nashville'

Select top (1000) *
From PortfolioProject..Nashville

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format (remove time)

Select SaleDate
From PortfolioProject.dbo.Nashville

Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.Nashville

ALTER TABLE Nashville
ALTER COLUMN SaleDate date;

Select SaleDate
From PortfolioProject.dbo.Nashville

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data (having NULL value)

Select *
From PortfolioProject.dbo.Nashville
--Where PropertyAddress is null
order by ParcelID

-- The result shows that any 2 rows having the same ParcelID value have identical PropertyAddress value. So, if a row has
-- PropertyAddress as NULL, it is copied from a row with identical ParcelID.

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Nashville a
JOIN PortfolioProject.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Nashville a
JOIN PortfolioProject.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- PropertyAddress column

Select PropertyAddress
From PortfolioProject.dbo.Nashville


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Street
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2 , LEN(PropertyAddress)) as City
From PortfolioProject.dbo.Nashville


ALTER TABLE Nashville
Add PropertyStreet Nvarchar(255);

Update Nashville
SET PropertyStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashville
Add PropertyCity Nvarchar(255);

Update Nashville
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2 , LEN(PropertyAddress))


Select top(1000) *
From PortfolioProject.dbo.Nashville



-- OwnerAddress column

Select OwnerAddress
From PortfolioProject.dbo.Nashville


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.Nashville


ALTER TABLE Nashville
Add OwnerStreet Nvarchar(255);
Update Nashville
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Nashville
Add OwnerCity Nvarchar(255);
Update Nashville
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Nashville
Add OwnerState Nvarchar(255);
Update Nashville
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select top(1000) OwnerAddress, OwnerStreet, OwnerCity, OwnerState
From PortfolioProject.dbo.Nashville
Where OwnerAddress is not null


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SoldAsVacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.Nashville
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.Nashville


Update Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.Nashville
Group by SoldAsVacant
order by 2


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicate rows

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
					) row_num
From PortfolioProject.dbo.Nashville
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Delete
From RowNumCTE
Where row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select top(1000) *
From PortfolioProject.dbo.Nashville

ALTER TABLE PortfolioProject.dbo.Nashville
DROP COLUMN OwnerAddress, PropertyAddress


-- END OF PROJECT