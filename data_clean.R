.libPaths("/admin/apps/rhel8/R-4.1.1/lib64/R/library")
library(tidyverse)
library(readr)
library(lubridate)

Admissions<- read_csv("/work/physionet.org/files/mimiciii/1.4/ADMISSIONS.csv.gz")
Service <- read_csv("/work/physionet.org/files/mimiciii/1.4/SERVICES.csv.gz")
Patients<- read_csv("/work/physionet.org/files/mimiciii/1.4/PATIENTS.csv.gz")
ICUstays <- read_csv("/work/physionet.org/files/mimiciii/1.4/ICUSTAYS.csv.gz")
lab_results<- read_csv("/work/physionet.org/files/mimiciii/1.4/LABEVENTS.csv.gz")
hospital_proc <- read_csv("/work/physionet.org/files/mimiciii/1.4/PROCEDURES_ICD.csv.gz")

ICUstays %>% group_by(SUBJECT_ID, HADM_ID) %>%
  summarise(ICU_STAY_DAYS = sum(LOS)) %>% 
  mutate(MULTI_ENTRY_ICU = !(HADM_ID %in% 
                              (ICUstays %>% 
                                 arrange(SUBJECT_ID, INTIME, ROW_ID) %>% 
                                 distinct(SUBJECT_ID, .keep_all = TRUE) %>%
                                 #this select hadm record when first entering ICU
                                 select(HADM_ID))$HADM_ID)) %>%
  arrange(SUBJECT_ID, HADM_ID) -> 
  ICUstays_df

#there are 164 unique icd9 codes
top = 10
hospital_proc %>% filter( ICD9_CODE %in%
                            (hospital_proc %>%
                               group_by(ICD9_CODE) %>%
                               summarise(COUNT = n()) %>%
                               slice_max(COUNT, n = top))$ICD9_CODE) %>%
  select(SUBJECT_ID, HADM_ID, ICD9_CODE) %>%
  group_by(SUBJECT_ID, HADM_ID, ICD9_CODE) %>%
  summarise(COUNT = n()) %>%
  pivot_wider(names_from = ICD9_CODE, values_from = COUNT,
              names_prefix = "ICD9_", values_fill = 0)->
  hospital_proc_df


#it appears that the lab_results will not have an hadm_id if 
#recorded before/after the hopitalization
#I may need to seperate them into before, during, after tables

#here I only consider the results during the hopitalization
#it's hard to define what is the record prior to hospitalization
#Will 3-day period work?

#what does the delta on the flag mean?
top2 = 20
lab_results_during <- (lab_results %>% drop_na(HADM_ID) %>% 
                         mutate(flag = replace_na(FLAG, "normal")))
lab_results_during %>% filter(ITEMID %in% #top 20 frequent tests
                                (lab_results_during %>% group_by(ITEMID) %>%
                                   summarise(COUNT = n()) %>% 
                                   slice_max(COUNT, n = top2))$ITEMID) %>%
  group_by(SUBJECT_ID, HADM_ID, ITEMID) %>%
  summarise(TOTAL = n(), ABNORMAL = sum(FLAG %in% c("abnormal", "ABNORMAL", "Abnormal")), 
            PROP = ABNORMAL/TOTAL) %>%
  pivot_wider(names_from = ITEMID, values_from = c(TOTAL, ABNORMAL, PROP),
              names_prefix = "ITEMID_", values_fill = 0)->
  lab_results_during_df
  
Admissions %>% select(SUBJECT_ID, HADM_ID, ADMITTIME, DISCHTIME, 
                      ETHNICITY, DIAGNOSIS, HOSPITAL_EXPIRE_FLAG) ->
  admissions_df
Service %>% select(SUBJECT_ID, HADM_ID, CURR_SERVICE) %>%
  distinct(SUBJECT_ID, HADM_ID, CURR_SERVICE, .keep_all = TRUE) %>%
  group_by(SUBJECT_ID, HADM_ID) %>%
  mutate(SERVICES = paste0(CURR_SERVICE, collapse = ";")) %>%
  select(SUBJECT_ID, HADM_ID, SERVICES) %>%
  distinct(SUBJECT_ID, HADM_ID, .keep_all = TRUE)-> 
  service_df
Patients %>% select(SUBJECT_ID, GENDER, DOB) -> patients_df

left_join(x= admissions_df, y= patients_df, 
          by = c("SUBJECT_ID")) -> temp
temp %>% mutate(AGE_ON_AD = 
                  as.numeric(as.duration(ADMITTIME - DOB), "year")) -> temp
left_join(x= temp, y = service_df, 
          by = c("SUBJECT_ID", "HADM_ID")) -> temp
left_join(x= temp, y = ICUstays_df,
          by = c("SUBJECT_ID", "HADM_ID")) -> temp
left_join(x= temp, y = hospital_proc_df,
          by = c("SUBJECT_ID", "HADM_ID")) -> temp
left_join(x= temp, y = lab_results_during_df,
          by = c("SUBJECT_ID", "HADM_ID")) -> temp
write_csv(temp, path = "~/MIMIC_cleaned.csv")



