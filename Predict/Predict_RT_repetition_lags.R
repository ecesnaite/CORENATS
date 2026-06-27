rm(list = ls())

# Libraries
library(tidyverse)

## PRESENTATION ##
#load data
RT_press <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/RT_num_pres.csv')
#RT_press <- RT_press[-14,] # remove the remaining participant due to poor behavioral performance

# transform to long format
long_RT <- RT_press %>% 
  pivot_longer(cols = colnames(RT_press), 
               names_to = "press",
               values_to = "value")

# linear model linking reaction time to the number of presentations
RT_model1 <- lm(value ~ press , data = long_RT)
summary(RT_model1)

## LAGS ##
#load data from the 2nd and 3rd presentations of a stimulus
data_dir <- c('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/')
files <- c('RT_lag_pres_2.csv','RT_lag_pres_3.csv')

# Create an empty list to store the models
model_list <- list()

for (i in 1:2) {
  current_pres <- read.csv(paste0(data_dir,files[i])) 
  RT_lag_pres <- as.data.frame(t(current_pres))
  RT_lag_pres <- RT_lag_pres[-14,] # remove outlier
  
  # transform to long format
  long_RT_lag <- RT_lag_pres %>% 
    pivot_longer(cols = colnames(RT_lag_pres), 
                 names_to = "lag",
                 values_to = "value")
  
  # remove the first repetition since there was no lag
  indx_rm_v1 <- which(long_RT_lag$lag == 'V1') 
  
  long_RT_lag_model <- long_RT_lag[-indx_rm_v1,]
  long_RT_lag_model$lag <- rep(c(1:5), 31)
  
  # linear model linking reaction times to the lag
  model_list[[i]] <- lm(value ~ lag , data = long_RT_lag_model)
}
summary(model_list[[1]])


