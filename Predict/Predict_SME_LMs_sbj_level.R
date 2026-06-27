rm(list = ls())

# load libraries
#install.packages('lmerTest')
library(lme4)
library(lmerTest)

#load data
data <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/subj_level_SEM_CORENATS.csv')

# inspect data

# outlier detection
out <- boxplot(data$Fz)$out
out2 <- boxplot(data$Ps)$out

indx_rem1<-which(data$Fz %in% out)
indx_rem <- which(data$Ps %in% out2) # overlaps with out
indx_rem_all <- c(indx_rem1,indx_rem)

#remove outliers
data_reduced <- data[-indx_rem_all,]
boxplot(data_reduced$Fz)
boxplot(data_reduced$Ps)

# linear models

data_reduced$num_correct <- as.factor(data_reduced$num_correct)

# # ---- Fz Models ---- # #
# random intercept model
Fz_model1 <- lmer(Fz ~ num_correct  + (1|subjID), data = data_reduced)
summary(Fz_model1)

# # ---- PO3-P08 Models ---- # #
P_model1 <- lmer(Ps ~ num_correct + (1|subjID), data = data_reduced)
summary(P_model1)

## check mean and median values for each condition to make sure they match with the GA ERP plot
#indx_0<- which(data_reduced$num_correct==0)
#indx_1<- which(data_reduced$num_correct==1)
#indx_2<- which(data_reduced$num_correct==2)

#mean_zero <- mean(data_reduced$Fz[indx_0])
#median_zero <- median(data_reduced$Fz[indx_0])

#mean_one <- mean(data_reduced$Fz[indx_1])
#median_one <- median(data_reduced$Fz[indx_1])

#mean_two <- mean(data_reduced$Fz[indx_2])
#median_two <- median(data_reduced$Fz[indx_2])

