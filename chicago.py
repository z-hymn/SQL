# Querying three tables of Chicago datasets. Census, Public Schools, and Crime
# Datasets are directly from the Chicago Data Portal. It was stored in a database and then used Python to SQL query. 

!pip install sqlalchemy 
!pip install ibm_db_sa 
!pip install sqlalchemy==1.3.9
!pip install ibm_db_sa 
!pip install ipython-sql

%load_ext sql

# The connection string is of the format:
# %sql ibm_db_sa://my-username:my-password@my-hostname:my-port/my-db-name?security=SSL
%sql ibm_db_sa://<my-user-name>:aMlJNBOdTQvzLl9m@ba99a9e6-d59e-4883-8fc0-d6a8c9f7a08f.c1ogj3sd0tgtu0lqde00.databases.appdomain.cloud:31321/BLUDB?security=SSL

# The total number of crimes 
%sql select count(*) as total_number_of_crimes from chicago_crime_data

Community areas with per capita income less than $11,000
%sql SELECT community_area_name, per_capita_income FROM census_data 
WHERE per_capita_income < 11000 ORDER BY per_capita_income DESC 

# Case numbers for crime involving minors, example of wild card and LIKE
%sql select case_number, primary_type, description from chicago_crime_data where description like '%MINOR%' or PRIMARY_TYPE LIKE '%MINOR%'

# Example of LIMIT, DESC. 5 community areas with highest % of households below poverty line 
%sql select community_area_name, percent_households_below_poverty from census_data /
     order by percent_households_below_poverty  desc nulls last limit 5
     
# Example of SQL Magic
%%sql Most crime prone community area
SELECT COMMUNITY_AREA_NUMBER from CHICAGO_CRIME_DATA
        group by COMMUNITY_AREA_NUMBER order by COUNT(*) DESC NULLS LAST LIMIT 1
        
# Example of sub-queries -- highest hardship index community area 
%sql SELECT community_area_name, hardship_index FROM census_data where \
    hardship_index= (select MAX(hardship_index) from census_data)
    
#Sub-query Community area name with most number of crimes 

%%sql 
    Select COMMUNITY_AREA_NAME from CENSUS_DATA 
    where community_area_number IN (SELECT COMMUNITY_AREA_NUMBER 
    FROM CHICAGO_CRIME_DATA group by COMMUNITY_AREA_NUMBER order by COUNT(*) DESC LIMIT 1)
