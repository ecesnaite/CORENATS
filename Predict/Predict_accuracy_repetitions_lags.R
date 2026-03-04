rm(list = ls())

# Libraries
#install.packages("paletteer")
library(tidyverse)
library(ggsignif)

## REPETITION ##
#load data
Accu_press <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_presentations.csv')
Accu_press <- Accu_press[-14,]

# transform to long format
long_accu <- Accu_press %>% 
  pivot_longer(cols = colnames(Accu_press), 
               names_to = "press",
               values_to = "value")

Acc_model1 <- lm(value ~ press , data = long_accu)
summary(Acc_model1)

## LAGS ##
#load data
Accu_lag_pres_2 <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_lag_2nd.csv')
Accu_lag_pres_2 <- Accu_lag_pres_2[-14,]

long_accu_lag2 <- Accu_lag_pres_2 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

long_accu_lag2$lag <- rep(c(1:5), 31) 

Acc_model2 <- lm(value ~ lag , data = long_accu_lag2)
summary(Acc_model2)

#load data
Accu_lag_pres_3 <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_lag_3rd.csv')
Accu_lag_pres_3 <- Accu_lag_pres_3[-14,]

# transform to long format
long_accu_lag3 <- Accu_lag_pres_3 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_3), 
               names_to = "lag",
               values_to = "value")

long_accu_lag3$lag <- rep(c(1:5), 31) 

Acc_model3 <- lm(value ~ lag , data = long_accu_lag3)
summary(Acc_model3)
