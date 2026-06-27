rm(list = ls())

# Libraries
#install.packages("paletteer")
library(tidyverse)
library(ggsignif)

## REPETITION ##
#load data
Accu_press <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_presentations.csv')
Accu_press <- Accu_press[-14,] # remove the participant who was eliminated due to poor behavioral performance

# transform to long format
long_accu <- Accu_press %>% 
  pivot_longer(cols = colnames(Accu_press), 
               names_to = "press",
               values_to = "value")

Acc_model1 <- lm(value ~ press , data = long_accu)
summary(Acc_model1)

## LAGS ##

data_dir <- c('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/')
files <- c('Accuracy_lag_2nd.csv','Accuracy_lag_3rd.csv')

# Create an empty list to store the models
model_list <- list()

for (i in 1:2) {
  current_pres <- read.csv(paste0(data_dir,files[i])) 
  current_pres <- current_pres[-14,] # remove the outlier

  #transform to the long format
  long_accu_lag <- current_pres %>% 
  pivot_longer(cols = colnames(current_pres), 
               names_to = "lag",
               values_to = "value")

  long_accu_lag$lag <- rep(c(1:5), 31) # assign lags from 1 to 5

  # linear models linking accuracy to the lag in the 2nd presentation of a stimulus
  model_list[[i]] <- lm(value ~ lag , data = long_accu_lag)
}
summary(model_list[[1]])


