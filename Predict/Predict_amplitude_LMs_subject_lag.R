rm(list = ls())

# Load libraries
library(lme4)
library(lmerTest)

#load data for the GA ERP for each presentation
data <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/subj_level_GA_ERP_lag.csv')

# inspect data

# outlier detection
out <- boxplot(data$Fz)$out
out2 <- boxplot(data$Ps)$out

indx_rem1 <-which(data$Fz %in% out)
indx_rem <- which(data$Ps %in% out2) # overlaps with out
indx_rm_all <- c(indx_rem1,indx_rem)

# remove data points that were identified as outliers
data_reduced <- data[-indx_rm_all,]
boxplot(data_reduced$Fz)
boxplot(data_reduced$Ps)

# Linear models

#remove lag 0 (first presentation of a stimulus) and use lags as continuous variable
indx_lag_0 <- which(data_reduced$lag==1)
data_reduced_v2 <- data_reduced[-indx_lag_0,]

P_model_lag <- lmer(Ps ~ lag + (1|subjID), data = data_reduced_v2)
summary(P_model_lag)

F_model_lag <- lmer(Fz ~ lag + (1|subjID), data = data_reduced_v2)
summary(F_model_lag)

