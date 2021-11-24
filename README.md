# BIOSTATS Final Project
Using the MIMIC III data to explore the factors influencing the outcome in ICU. This project can provide insights into identifying the riskiest patient and prioritize the ICU administration. More specifically, we would like to predict whether a patient would die given certain features in the ICU with emergency admission. We are also interested in identifying the factors that may impact the time period a person will stay in ICU. Furthermore, we want to use explainable machine learning to explain and analyze the model results. 

## Background information
“In recent years there has been a concerted move towards the adoption of digital health record systems in hospitals. In the US, for example, the number of non-federal acute care hospitals with basic digital systems increased from 9.4 to 75.5% over the 7 year period between 2008 and 2014 (ref. 1).

Despite this advance, interoperability of digital systems remains an open issue, leading to challenges in data integration. As a result, the potential that hospital data offers in terms of understanding and improving care is yet to be fully realized. In parallel, the scientific research community is increasingly coming under criticism for the lack of reproducibility of studies2.

## Data Set
Here we reported the release of the MIMIC-III database, an update to the widely-used MIMIC-II database (Data Citation 1, demo data available at https://physionet.org/content/mimiciii-demo/1.4/). MIMIC-III integrates deidentified, comprehensive clinical data of patients admitted to the Beth Israel Deaconess Medical Center in Boston, Massachusetts, and makes it widely accessible to researchers internationally under a data use agreement (Fig. 1). The open nature of the data allows clinical studies to be reproduced and improved in ways that would not otherwise be possible.”

The MIMIC-III database is a relational database consisting of 26 tables linked by identifier HADM_ID.

## Project Objective 
Online machine learning algorithm

## Project Plan
- Exploratory Data Analysis
    
    -Table incldued: ADMISSION.gz.csv, DIAGNOSES_ICD.gv.csv, LABEVENTS.gz.csv  
    
    -There are 46520 subject involved with 38983 of them had 1 admission to ICU and 7537 of them have 
     multiple admissions to ICU.
    
    -Variables of interest:
        
        ID variables: SUBJECT_ID, HADM_ID,
        
        Output: HOSPITAL_EXPIRE_FLAG: Boolean variable obtained from ADMISSIONS table. This variable indicates 
               whether the patient passed away during hospitalization.
        
        Input: Ethnicity,
               
               DIAGNOSIS, 
               
               GENDER, 
               
               DOB, 
               
               AGE, 
               
               ICU_STAY_DAYS (total days of ICU stays during hospitalization for each HADM_ID, 
               
               MULTI_ENTRY_ICU (boolean variable, set True if patients have entered the ICU before this hospital admission)
               
               ICD9_code (top 10 frequent procedures or diagnosis),
                   
                    3961: Extracorporeal circulat
                    3891: Arterial catheterization	
                    3893: Venous cath NEC	
                    8856: Coronar arteriogr-2 cath	
                    9604: Insert endotracheal tube	
                    966: Entral infus nutrit sub	
                    9671: Cont inv mec ven <96 hrs	
                    9672: Cont inv mec ven 96+ hrs	
                    9904: Packed cell transfusion	
                    9955: Vaccination NEC
               
               TOTAL_ITEMID_code (top 20 frequent lab test),
               
               ABNORMAL_ITEMID_code (proportion of abnormal lab test for the above 20 procedures).
                    
     Lab items:
                    
     ITEMID | LABEL | FLUID | CATEGORY 
    ------------- | ------------- | ------------- | ------------- 
    50820  | pH | Blood | Blood Gas
    50868  | CAnion Gap | Blood | Chemistry 
    50882  | Bicarbonate| Blood | Chemistry 
    50902  | Chloride	  | Blood |  Chemistry
    50912  | Creatinine |Blood	 | Chemistry 
    50931  | Glucose	 |  Blood |	 Chemistry 
    50960  | Magnesium	 |  Blood |	  Chemistry
    50970	| Phosphate	|  Blood|  Chemistry	
    50971	| Potassium	|  Blood|Chemistry
    0983 |	Sodium|	   Blood|Chemistry
    51006	|Urea Nitrogen|  Blood|	Chemistry
    51221	|Hematocrit	 |   Blood|	 Hematology
    51222	|Hemoglobin	 |  Blood	|  Hematology
    51248	| MCH	|  Blood|Hematology
    51249	|MCHC	 |  Blood|	Hematology
    51250	|MCV	|  Blood|Hematology
    51265	|Platelet Count	| Blood|Hematology
    51277	|RDW  |  Blood	|  Hematology
    51279	|Red Blood Cells|Blood|	Hematology
    51301	|White Blood Cells|	Blood|Hematology
                    
                    
     
-Feature engineering:
    -de-identification: 
        Removed patient name, telephone number and address from ADMISSIONs.gz.csv tabel.
        Dates were shifted into the future intervals preserved. Time of the day, day of the week and 
        approximate seasonality were conserved.
        Patients > 89 yrs appear with ages of over 300 yrs.
        Protected health information was removed, such as diagnostic reports and physician notes.
   
   -train and test split by ratio = 0.2. The training data contains 47180 rows.
   
   -There is missingness in the top ten ICD9_code. We replaced NA with 0.
   
   -Scaled ICU_STAY_DAYS, ICD9_code, Proportion of abnormal lab tests for multilayer perceptron.

- Model training
   
    -Logistic regression
   
    -Random forest
    
    -Multilayer perceptron

- Model Evaluation

- Model Interpretation

- Timeline

    -Oct 20: confirmed group members
    
    -Nov 1: confirmed project topic applied for data access
    
    -Nov 5: went through the whole database. Confirmed primary outcome.
    
    -We had regular group meetings each week to discuss our weekly plan for this project.

## Team Members and Responsibilities

Jiaman (Betty) Wu: jiaman.wu@duke.edu

Betty constructed the multilayer perceptron deep learning model, tuned its hyperparameters and interpreted the results. She also  

Lujun (Lucas) Zhang: lujun.zhang@duke.edu

Lucas cleaned and prepared the data, derived the defition of the variables of interests, combined the results and wrote the documentation.

Mengyi (Ashley) Hu: mengyi.hu@duke.edu

Ashley trained the logistic regerssion model, constructed random forest model and tuned its hyperparameters, and interpreted results of these models.
