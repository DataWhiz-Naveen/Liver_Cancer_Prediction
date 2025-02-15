--Create a separate Database for Liver Cancer Data Analysis
Create Database Liver_Cancer_Prediction;

--Use Created Database
Use Liver_Cancer_Prediction;

--Load the CSV File into SQL Server and View the Table 
select * from Liver_Cancer;

-- Phase 1: Data Cleaning & Preprocessing

--Creating Temporary Dataset
select * into LCD from Liver_Cancer

select * from LCD

--checking for null values
select count(*) as Null_Count from LCD
where Country is Null
	or Region is null
	or population is null
	or Incidence_Rate is null
	or Mortality_Rate is null
	or Gender is null
	or Age is null
	or Alcohol_Consumption is null
	or Smoking_Status is null
	or Hepatitis_B_Status is null
	or Hepatitis_C_Status is null
	or Obesity is null
	or diabetes is null
	or Rural_or_Urban is null
	or Seafood_Consumption is null
	or Herbal_Medicine_Use is null
	or Healthcare_Access is null
	or Screening_Availability is null
	or Treatment_Availability is null
	or Liver_Transplant_Access is null
	or Ethnicity is null
	or Preventive_Care is null
	or Survival_Rate is null
	or Cost_of_Treatment is null
	or Prediction is null;

/*--- COALESCE doesn't work well with mixed data types we get Error for this code

SELECT COUNT(*) AS Null_Count 
FROM LCD
WHERE COALESCE(
    Country, Region, Population, Incidence_Rate, Mortality_Rate, Gender, Age, 
    Alcohol_Consumption, Smoking_Status, Hepatitis_B_Status, Hepatitis_C_Status, 
    Obesity, Diabetes, Rural_or_Urban, Seafood_Consumption, Herbal_Medicine_Use, 
    Healthcare_Access, Screening_Availability, Treatment_Availability, 
    Liver_Transplant_Access, Ethnicity, Preventive_Care, Survival_Rate, 
    Cost_of_Treatment, Prediction
) IS NULL;
*/ 

--Standardize categorical values:
UPDATE LCD
SET Alcohol_Consumption = 'Low'
WHERE Alcohol_Consumption IN ('low', 'LOW');

--Phase 2: Exploratory Data Analysis (EDA)
--Descriptive Statistics

--DATA Limitation Issues (Error : arithmetic overflow error.)
ALTER TABLE LCD ALTER COLUMN Population BIGINT;
ALTER TABLE LCD ALTER COLUMN Cost_of_Treatment BIGINT;

SELECT 
    AVG(Incidence_Rate) AS Avg_Incidence,
    AVG(Mortality_Rate) AS Avg_Mortality,
    AVG(Survival_Rate) AS Avg_Survival,
    AVG(Cost_of_Treatment) AS Avg_Cost
FROM LCD;

--Distribution of Age Groups:
SELECT Age, COUNT(*) AS Age_Count
FROM LCD
GROUP BY Age
ORDER BY Age;

--Gender with Age distribution:
SELECT Age, Gender, COUNT(*) AS Total_Count
FROM LCD
GROUP BY Age, Gender
ORDER BY Age, Gender;

--Incidence & Mortality Trends
--Q1) What is the overall incidence rate of liver cancer across different regions?
select * from LCD

select Distinct Region, AVG(Incidence_Rate) as Overall_IR
from LCD
Group By Region
Order By Overall_IR DESC;

--Q2) How does the mortality rate vary across countries and regions?
select * from LCD

select distinct Country, Region, AVG(Mortality_Rate) as Avg_Mortality_Rate
from LCD
Group By Country, Region
Order By Region, Avg_Mortality_Rate DESC

--Q3)Is there a correlation between incidence and mortality rates?
--Using Concept of CTE
WITH Correlation AS (
    SELECT 
        (SUM(Incidence_Rate * Mortality_Rate) - (SUM(Incidence_Rate) * SUM(Mortality_Rate) / COUNT(*))) / 
        (SQRT((SUM(Incidence_Rate * Incidence_Rate) - (SUM(Incidence_Rate) * SUM(Incidence_Rate) / COUNT(*))) * 
              (SUM(Mortality_Rate * Mortality_Rate) - (SUM(Mortality_Rate) * SUM(Mortality_Rate) / COUNT(*))))) 
        AS Correlation_Coefficient
    FROM LCD
)
SELECT Correlation_Coefficient,
       CASE 
           WHEN Correlation_Coefficient > 0.7 THEN 'Strong Positive Correlation'
           WHEN Correlation_Coefficient BETWEEN 0.3 AND 0.7 THEN 'Moderate Positive Correlation'
           WHEN Correlation_Coefficient BETWEEN -0.3 AND 0.3 THEN 'No Significant Correlation'
           WHEN Correlation_Coefficient BETWEEN -0.7 AND -0.3 THEN 'Moderate Negative Correlation'
           WHEN Correlation_Coefficient < -0.7 THEN 'Strong Negative Correlation'
       END AS Correlation_Interpretation
FROM Correlation;

--Q4)How do liver cancer survival rates differ by country and region?
select * from LCD

SELECT Region, Country, COUNT(*) AS Total_Cases,
    ROUND(AVG(Survival_Rate), 2) AS Avg_Survival_Rate
FROM LCD
GROUP BY Region, Country
ORDER BY Avg_Survival_Rate DESC;

--Q5)What are the trends in liver cancer incidence and mortality based on age groups?
/*
to analyze liver cancer incidence and mortality trends based on age groups, we need to group the data by age ranges and calculate:

Total cases per age group
Average incidence rate (%) per age group
Average mortality rate (%) per age group
*/

SELECT 
    CASE 
        WHEN Age BETWEEN 0 AND 19 THEN '0-19'
        WHEN Age BETWEEN 20 AND 39 THEN '20-39'
        WHEN Age BETWEEN 40 AND 59 THEN '40-59'
        WHEN Age BETWEEN 60 AND 79 THEN '60-79'
        ELSE '80+'
    END AS Age_Group,
    COUNT(Age) AS Total_Cases,
    ROUND(AVG(Incidence_Rate), 2) AS Avg_Incidence_Rate,
    ROUND(AVG(Mortality_Rate), 2) AS Avg_Mortality_Rate
FROM LCD
GROUP BY 
    CASE 
        WHEN Age BETWEEN 0 AND 19 THEN '0-19'
        WHEN Age BETWEEN 20 AND 39 THEN '20-39'
        WHEN Age BETWEEN 40 AND 59 THEN '40-59'
        WHEN Age BETWEEN 60 AND 79 THEN '60-79'
        ELSE '80+'
    END
ORDER BY Age_Group;


--Risk Factors Analysis
--Q6) How does alcohol consumption affect liver cancer incidence rates?

--To analyze how alcohol consumption affects liver cancer incidence rates, we can group data based 
--on alcohol consumption levels and compare their average incidence rates.

select * from LCD

select 
	Distinct Alcohol_Consumption, 
	COUNT(Alcohol_Consumption) as Total_Case ,
	Round(AVG(Incidence_Rate),3) as AVG_IR
from LCD
Group By Alcohol_Consumption
Order By AVG_IR DESC;

/*
Key Observations:
Alcohol consumption has almost no impact on liver cancer incidence
The incidence rates for Low, Moderate, and High alcohol consumption groups are nearly identical.
This suggests that alcohol alone may not be a strong predictor of liver cancer
*/

--Q7)What is the impact of smoking on liver cancer incidence and mortality?
select * from LCD

select 
	Distinct Smoking_Status, COUNT(Smoking_Status) as Total_Case,
	Round(AVG(Incidence_Rate),3) as AVG_IR
	Round(AVG(Mortality_Rate),3) as AVG_MR
From LCD
Group By Smoking_Status
Order by AVG_IR, AVG_MR;

/*
Key Observations:
The incidence rate for smokers (18.545%) is nearly the same as for non-smokers (18.502%).
This suggests smoking alone is not a strong predictor of developing liver cancer in your dataset.
Mortality rates are also nearly identical.
Smokers: 15.554% vs. Non-Smokers: 15.496% → Very little difference.
This suggests that smoking does not significantly affect survival rates for liver cancer patients.
*/

--Q8)How does the presence of Hepatitis B and C affect liver cancer rates?
select * from LCD

select 
	Distinct Hepatitis_B_Status,Hepatitis_C_Status, 
	COUNT(Hepatitis_B_Status) as Total_Cases,
	Round(AVG(Incidence_Rate),3) as AVG_IR,
	Round(AVG(Mortality_Rate),3) as AVG_MR
from LCD
Group BY Hepatitis_B_Status,Hepatitis_C_Status 
order by AVG_IR DESC;

/*
Key Observation
1) Hepatitis B & C do not show a significant impact on liver cancer incidence
   Incidence rates for all groups are nearly the same (~18.5%).
2) Mortality rates are also similar across groups (~15.5%).
*/

--Q9)Is there a relationship between obesity and liver cancer incidence?
select * from LCD

Select 
	Distinct Obesity, Count(Obesity) as Total_Cases,
	ROUND(AVG(Incidence_Rate),3) as AVG_IR
From LCD
Group By Obesity
Order By AVG_IR DESC;

/*
Key Observation
1) No strong relationship between obesity and liver cancer incidence.
   Typically, obesity is linked to fatty liver disease & liver inflammation, increasing cancer risk.
*/

--Q10)How does diabetes contribute to the likelihood of liver cancer?
select * from LCD

Alter Table LCD
Alter Column Diabetes Varchar(3); --Converting Data Type byte to Varchar

Update LCD
SET Diabetes = 
	CASE
		when CAST(Diabetes as varchar) = 1 then 'YES'
		when CAST(Diabetes as varchar)= 0 then 'No'
	End
where Diabetes in (0,1);

select 
	Distinct Diabetes, COUNT(Diabetes) as Total_Cases,
	Round(AVG(Incidence_Rate),3) as AVG_IR
From LCD
Group By Diabetes
Order By AVG_IR;

/*
Key observation
Diabetes has almost no significant impact on liver cancer incidence
The difference of only 0.022% suggests diabetes alone is not a strong predictor of liver cancer risk
*/

--Demographic & Lifestyle Insights
/*
Demographic & lifestyle analysis helps identify high-risk groups, shape prevention policies, 
improve treatments, and reveal hidden causes of liver cancer.
*/

--Q11) Are men more likely to develop liver cancer than women?
select * from LCD

select 
	Distinct Gender, Count(Gender) as No_of_Persons,
	ROUND(AVG(Incidence_Rate),3) as AVG_IR,
	ROUND(AVG(Mortality_Rate),3) as AVG_MR,
	MAX(Hepatitis_B_Status) as Common_HB_Status,
	MAX(Hepatitis_C_Status) as Common_HC_Status
From LCD
Group By Gender, Hepatitis_B_Status,Hepatitis_C_Status
Order By AVG_IR DESC;

/* 
Key Observation
Males have a slightly higher incidence and mortality rate than females.
	- Incidence Rate: Males (18.538%) have a higher risk of developing liver cancer than females (18.49%).
	- Mortality Rate: Males (15.546%) also have a higher chance of dying from liver cancer than females (15.477%).
Reasons
	-Hormonal Differences: Estrogen (in females) may offer some protection against liver damage.
	-Lifestyle Factors likely to consume alcohol and tobacco
	-men have higher Hepatitis B & C rates
*/

--Q12)How does urban vs. rural living affect liver cancer incidence?
Select * From LCD

select 
	Distinct Rural_or_Urban, Count(*) as No_of_Persons,
	ROUND(AVG(Incidence_Rate),3) as AVG_IR,
	ROUND(AVG(Mortality_Rate),3) as AVG_MR
From LCD
Group By Rural_or_Urban
Order By AVG_IR DESC;

/*
Key observation
Rural Areas Have a Slightly Higher Incidence Rate
	-Rural incidence rate (18.532%) is slightly higher than Urban (18.511%).
	-This suggests a slightly higher risk of developing liver cancer in rural areas.
Reasons
	-Limited healthcare access sunch as  lower vaccination & medical resources.
	-Due to High Environmental toxins
*/

--Q13) How does ethnicity influence liver cancer incidence and mortality?
select * from LCD

select 
	Distinct Ethnicity, Count(*) as Total_Cases,
	ROUND(AVG(Incidence_Rate),3) as AVG_IR,
	ROUND(AVG(Mortality_Rate),3) as AVG_MR
From LCD
Group By Ethnicity
Order By AVG_IR DESC; 

/*
Key Observations
-Asians Have the Highest Incidence (18.608%) & Mortality Rates (15.621%). 
-Mixed Ethnicity Has the 2nd Highest Incidence Rate (18.544%)
-African & Hispanic Populations Have the Lowest Incidence Rates (18.477%) 
*/

--Q14) Does seafood consumption correlate with liver cancer rates?
select * from LCD

select 
	Distinct Seafood_Consumption , Count(*) as No_of_Consumers,
	ROUND(AVG(Incidence_Rate),3) as AVG_IR
From LCD
Group By Seafood_Consumption
Order By AVG_IR DESC; 

/*
Key Observation
Higher Seafood Consumption Correlates with Slightly Higher Incidence Rates (18.577%)
	- Consumption of Seafood from polluted waters
	- Industrial Wastes may lead to higher toxins
*/

--Q15) What role does the use of herbal medicine play in liver cancer incidence?
select * from LCD

alter table LCD
alter column Herbal_Medicine_Use varchar(3);

Update LCD
set Herbal_Medicine_Use =
	CASE 
		when Herbal_Medicine_Use = 1 then 'YES'
		when Herbal_Medicine_Use = 0 then 'NO'
	END
where Herbal_Medicine_Use in (0,1)

select distinct Herbal_Medicine_Use from LCD

select 
	Distinct Herbal_Medicine_Use , Count(*) as No_of_Consumers,
	ROUND(AVG(Incidence_Rate),3) as AVG_IR
From LCD
Group By Herbal_Medicine_Use
Order By AVG_IR DESC; 

/*
Key Observation
Herbal Medicine Users Show a Slightly Higher AVG Incidence Rate (18.562%)
	-herbal medicines contain some toxin Acids
	-unregulated use of herbal products
*/

--Healthcare & Economic Factors

--Q16) How does healthcare access impact liver cancer survival rates?
select * from LCD

select 
	Distinct Healthcare_Access , Count(*) as No_of_Cases,
	ROUND(AVG(Survival_Rate),3) as AVG_Survival_Rate,
	ROUND(AVG(Incidence_Rate),3) as AVG_IR
From LCD
Group By Healthcare_Access
Order By AVG_Survival_Rate DESC; 

/*
Key Observation
Survival Rates Remain Similar Across Different Healthcare Access Levels
	-Moderate healthcare access shows the highest survival rate (50.026%), 
	 slightly better than both good (49.900%) and poor (49.924%) healthcare.
	-healthcare quality may not be the dominant factor influencing survival
*/

--Q17) What is the relationship between screening availability and liver cancer incidence rates?
select * from LCD

select 
	Distinct Screening_Availability , Count(*) as No_of_Cases,
	ROUND(AVG(Incidence_Rate),3) as AVG_IR
From LCD
Group By Screening_Availability
Order By AVG_IR DESC; 

/*
Key Observation
the difference between Incidence rates in available and not available screening groups is minimal (0.041), 
it suggests screening alone doesn’t drastically impact incidence rates.
*/

--Q18)How does the availability of treatment and liver transplants impact survival rates?
select * from LCD

select 
	Distinct Treatment_Availability , Count(*) as No_of_Cases,
	ROUND(AVG(Survival_Rate),3) as AVG_Survival_Rate
From LCD
Group By Treatment_Availability
Order By AVG_Survival_Rate DESC; 

/*
Key Observation
Survival Rates Remain Similar Across Different treatment_Availability Levels
	-But there is a higher Chance of Survival_Rate if Treatment is Available
*/

--Q19) How does the cost of treatment vary across different countries and economic levels?
select * from LCD

select MAX(Cost_of_treatment) as Max_Cost from LCD
select MIN(Cost_of_treatment) as Min_Cost from LCD

SELECT 
    Country,
    Treatment_Cost,
    COUNT(*) AS Total_Cases
FROM (
    SELECT 
        Country, 
        Region,
        CASE 
            WHEN Cost_of_Treatment BETWEEN 0 AND 20000 THEN 'Low_cost'
            WHEN Cost_of_Treatment BETWEEN 20001 AND 40000 THEN 'Medium_Cost'
            ELSE 'High_Cost'
        END AS Treatment_Cost
    FROM LCD
) AS Subquery
GROUP BY Country, Treatment_Cost
ORDER BY Treatment_Cost;

/*
Q20) Can predictive models accurately classify patients as 
high or low risk for liver cancer based on available features?
*/
select * from LCD
 
SELECT 
    Age, Gender, Smoking_Status, Alcohol_Consumption, Obesity,
    Hepatitis_B_Status, Hepatitis_C_Status, Diabetes, Healthcare_Access,
    Incidence_Rate, Mortality_Rate,
    CASE 
        WHEN Incidence_Rate > (SELECT ROUND(AVG(Incidence_Rate), 2) FROM LCD) THEN 'High Risk'
        ELSE 'Low Risk'
    END AS Risk_Level
FROM LCD
ORDER BY Incidence_Rate;
