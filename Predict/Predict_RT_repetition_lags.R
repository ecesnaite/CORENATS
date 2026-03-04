rm(list = ls())

# Libraries
#install.packages("paletteer")
library(paletteer)
library(tidyverse)
library(viridis)

## PRESENTATION ##
#load data
RT_press <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/RT_num_pres.csv')
RT_press <- RT_press[-14,]

# transform to long format
long_RT <- RT_press %>% 
  pivot_longer(cols = colnames(RT_press), 
               names_to = "press",
               values_to = "value")
RT_model1 <- lm(value ~ press , data = long_RT)
summary(RT_model1)

## LAGS ##
#load data
RT_lag_pres_2 <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/RT_lag_pres_2.csv')
RT_lag_pres_2 <- RT_lag_pres_2[,-14]
RT_lag_pres_2 <- as.data.frame(t(RT_lag_pres_2))

# transform to long format
long_RT_lag2 <- RT_lag_pres_2 %>% 
  pivot_longer(cols = colnames(RT_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

indx_rm_v1 <- which(long_RT_lag2$lag == 'V1')

long_RT_lag2_model <- long_RT_lag2[-indx_rm_v1,]
long_RT_lag2_model$lag <- rep(c(1:5), 31)

RT_model2 <- lm(value ~ lag , data = long_RT_lag2_model)
summary(RT_model2)

#load data
RT_lag_pres_3 <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/RT_lag_pres_3.csv')
RT_lag_pres_3 <- RT_lag_pres_3[,-14]
RT_lag_pres_3 <- as.data.frame(t(RT_lag_pres_3))

# transform to long format
long_RT_lag3 <- RT_lag_pres_3 %>% 
  pivot_longer(cols = colnames(RT_lag_pres_3), 
               names_to = "lag",
               values_to = "value")


indx_rm_v1 <- which(long_RT_lag3$lag == 'V1')

long_RT_lag3_model <- long_RT_lag3[-indx_rm_v1,]
long_RT_lag3_model$lag <- rep(c(1:5), 31)

RT_model3 <- lm(value ~ lag , data = long_RT_lag3_model)
summary(RT_model3)