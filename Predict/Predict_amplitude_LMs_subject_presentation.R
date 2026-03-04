rm(list = ls())

# Load libraries
library(lme4)
library(car)
#install.packages('lmerTest')
library(lmerTest)
library(ggplot2)

#load data for the GA ERP for each presentation
data <- read.csv('/Users/ecesnaite/Desktop/BuschLab/CORENATS/Output/subj_level_GA_ERP_presentation.csv')

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

P_model_presentation <- lmer(Ps ~ presentation + (1|subjID), data = data_reduced)
summary(P_model_presentation)

F_model_presentation <- lmer(Fz ~ presentation + (1|subjID), data = data_reduced)
summary(F_model_presentation)

