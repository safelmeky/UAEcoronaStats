-- Looking at the data related to the UAE stats with the corona viruse  : 
select *
from CovidDeathx 
where location like '%united arab%' 

-----------------------------------------------------------------------------------------------------------------------------------
-- First case:-

select location,date,Population,total_cases,total_deaths
from CovidDeathx 
where location ='United Arab Emirates' and total_cases is not NULL
-- we can see that the first cases recorded were on the second of Feb.

-- First death:-

select location,date,Population,total_cases,total_deaths
from CovidDeathx 
where location ='United Arab Emirates' and total_deaths is not null
-- The first death was recorded on the 22th of march (which is arund 50 days from the first case).

--------------------------------------------------------------------------------------------------------------------------------
--                                        Aggregation:

-- The data types of teh total_cases and the total_deaths columns are narvars so we have to convert them to ints or floats to be able to aggregate 

Alter table CovidAnalysis..CovidDeathx  alter column total_deaths float
Alter table CovidAnalysis..CovidDeathx  alter column total_cases  float

-- A query that shwos the ratios of the Cases,Deaths,population 

select distinct location,date,Population,(total_cases),total_deaths,(total_deaths/total_cases)*100 as ratio_deathTocases, 
(total_cases/Population)*100 as ratio_casesTopopulation,(total_deaths/Population)*100 as ratio_deathTopopulation
from CovidDeathx 
where location ='United Arab Emirates' and total_deaths is not null

-- The ratio of people who cought the viruse and died starts with 1.3 % then gradually decrease till it reaches 0.22%.
-- Amount of people infected =1067030 from which 2349 died .
-- Last cases recorded on the 2023-05-14 .
-- 11.3% of people living in the UAE cought the viruse.

-----------------------------------------------------------------------------------------------------------------------------
--                                            Vaccination table

-- a look at both tables :
select distinct * from CovidAnalysis..CovidDeathx dea
join CovidAnalysis..CovidVacx vac
on dea.location=vac.location and dea.date=vac.date
where dea.location ='United Arab Emirates' and total_deaths is not NULL
order by 4	

--a look at  the accination numberes with the death numberes  
select distinct dea.location,dea.date,dea.Population,dea.total_cases,dea.total_deaths,vac.people_vaccinated
from CovidAnalysis..CovidDeathx dea
join CovidAnalysis..CovidVacx vac
on dea.location=vac.location and dea.date=vac.date
where dea.location ='United Arab Emirates' and vac.people_vaccinated is not NULL
order by 4	

-- First amount of people vaccinated wrere on the 10th of jan 2021 which is arond a year from the start of the viruse.

-- The effect of the vaccination on the death rate?

select distinct dea.location,dea.date,dea.Population,dea.total_cases,dea.total_deaths,vac.total_vaccinations,vac.people_vaccinated
,(total_deaths/total_cases)*100 as ratio_deathTocases,(vac.people_vaccinated/dea.population) as ratio_vacctopop
from CovidAnalysis..CovidDeathx dea
join CovidAnalysis..CovidVacx vac
on dea.location=vac.location and dea.date=vac.date
where dea.location ='United Arab Emirates' and dea.total_deaths is not NULL
order by 4

-- The % of death was around 0.3 on Avg before the vaccination and decreased to 0.22 after the vacinatio 
-- The Uae has one of the hiehst ratios of vaccinatiosns to population as more than %100 of the people were vacinated in the uae 
-- The reason is beacuse some people came to the uae from outside the country and took the vaccine while on their trip.


-- Creating a table using "WITH" clouse to do further calculations aka "CTE":

WITH UaeCorona(location,date,Population,total_cases,total_deaths,total_vaccinations,people_vaccinated
,ratio_deathTocases,ratio_vacctopop)
as
(
select distinct dea.location,dea.date,dea.Population,dea.total_cases,dea.total_deaths,vac.total_vaccinations,vac.people_vaccinated
,(total_deaths/total_cases)*100 as ratio_deathTocases,(vac.people_vaccinated/dea.population) as ratio_vacctopop
from CovidAnalysis..CovidDeathx dea
join CovidAnalysis.	.CovidVacx vac
on dea.location=vac.location and dea.date=vac.date
where dea.location ='United Arab Emirates' and dea.total_deaths is not NULL
)
select* from UaeCorona

-- creating  a view for working on the data later on if needed:


create view uaeCorona as(
select distinct dea.location,dea.date,dea.Population,dea.total_cases,dea.total_deaths,vac.total_vaccinations,vac.people_vaccinated
,(total_deaths/total_cases)*100 as ratio_deathTocases,(vac.people_vaccinated/dea.population) as ratio_vacctopop
from CovidAnalysis..CovidDeathx dea
join CovidAnalysis.	.CovidVacx vac
on dea.location=vac.location and dea.date=vac.date
where dea.location ='United Arab Emirates' and dea.total_deaths is not NULL
)