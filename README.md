# Liver Cancer Analysis
This repo contains notebooks on various datasets as a practice on data analysis, all notebooks include:

1. Data Cleaning.
2. Data Visualization.
3. Exploratory Data Analysis.

Each project contains detailed README file that cointains an informative description of the dataset and its columns, 
summary of exploring the dataframe and step to be taken in data cleaning phase, visualizations findings and EDA conclusions. 

# Liver Cancer Prediction - Data Analysis

## 📌 Project Overview
Liver cancer is a serious disease and one of the leading causes of cancer-related deaths worldwide. Catching it early and understanding what increases the risk can make a huge difference in saving lives. This project dives into **liver cancer data using SQL** to uncover important patterns, identify high-risk areas, and classify patients based on their risk levels.

Using **MS SQL Server**, we clean, process, and analyze data that includes patient demographics, lifestyle choices, and medical history. The goal is to find key factors—like **alcohol use, smoking, hepatitis infections, obesity, and access to healthcare**—that may contribute to the disease.

### Why This Matters
✔ Helps understand **where** and **why** liver cancer is most common.  
✔ Highlights major **risk factors** that could be targeted for prevention.  
✔ Builds a **risk classification model** to help identify high-risk patients.  

The insights from this project can support **healthcare professionals, researchers, and policymakers** in improving **prevention, screening, and treatment strategies** for liver cancer.


# Liver Cancer (Main Table)
| Column Name               | Data Type         | Description |
|---------------------------|------------------|-------------|
| ID                      | INT PRIMARY KEY | Unique identifier |
| Country                 | VARCHAR(100)    | Country name |
| Region                  | VARCHAR(100)    | Region name |
| Population              | INT             | Population count |
| Incidence Rate          | FLOAT           | Cancer incidence rate (%) |
| Mortality Rate          | FLOAT           | Mortality rate (%) |
| Gender                  | VARCHAR(10)     | Male / Female |
| Age                     | INT             | Patient age |
| Alcohol Consumption      | VARCHAR(10)     | Yes / No |
| Smoking Status          | VARCHAR(10)     | Smoker / Non-Smoker |
| Hepatitis B Status      | VARCHAR(10)     | Positive / Negative |
| Hepatitis C Status      | VARCHAR(10)     | Positive / Negative |
| Obesity                 | VARCHAR(10)     | Yes / No |
| Diabetes                | VARCHAR(10)     | Yes / No |
| Rural or Urban          | VARCHAR(10)     | Rural / Urban |
| Seafood Consumption     | VARCHAR(10)     | Low / Medium / High |
| Herbal Medicine Use     | VARCHAR(10)     | Yes / No |
| Healthcare Access       | VARCHAR(10)     | Poor / Moderate / Good |
| Screening Availability  | VARCHAR(10)     | Yes / No |
| Treatment Availability  | VARCHAR(10)     | Yes / No |
| Liver Transplant Access | VARCHAR(10)     | Yes / No |
| Ethnicity               | VARCHAR(50)     | Ethnic group |

## Liver Cancer Risk (Risk Classification Table)
| Column Name     | Data Type         | Description |
|----------------|------------------|-------------|
| ID           | INT PRIMARY KEY | Unique identifier |
| Country      | VARCHAR(100)    | Country name |
| Region       | VARCHAR(100)    | Region name |
| Age Group    | VARCHAR(20)     | Age categories: Low, Medium, High |
| Risk Level   | VARCHAR(20)     | Risk classification: Low, Medium, High |

# Key Research Questions

### **1. Incidence & Mortality Trends**
- What is the overall incidence rate of liver cancer across different regions?
- How does the mortality rate vary across countries and regions?
- Is there a correlation between incidence and mortality rates?
- How do liver cancer survival rates differ by country and region?
- What are the trends in liver cancer incidence and mortality based on age groups?

### **2. Risk Factors Analysis**
- How does alcohol consumption affect liver cancer incidence rates?
- What is the impact of smoking on liver cancer incidence and mortality?
- How does the presence of Hepatitis B and C affect liver cancer rates?
- Is there a relationship between obesity and liver cancer incidence?
- How does diabetes contribute to the likelihood of liver cancer?

### **3. Demographic & Lifestyle Insights**
- Are men more likely to develop liver cancer than women?
- How does urban vs. rural living affect liver cancer incidence?
- How does ethnicity influence liver cancer incidence and mortality?
- Does seafood consumption correlate with liver cancer rates?
- What role does the use of herbal medicine play in liver cancer incidence?

### **4. Healthcare & Economic Factors**
- How does healthcare access impact liver cancer survival rates?
- What is the relationship between screening availability and liver cancer incidence rates?
- How does the availability of treatment and liver transplants impact survival rates?
- How does the cost of treatment vary across different countries and economic levels?
- Can predictive models accurately classify patients as high or low risk for liver cancer based on available features?


