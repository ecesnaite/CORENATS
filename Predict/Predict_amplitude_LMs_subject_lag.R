rm(list = ls())

#load data for the GA ERP for each presentation
data <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/subj_level_GA_ERP_lag.csv')
table(data$subjID)

# inspect data

# outlier detection
out <- boxplot(data$Fz)$out
out2 <- boxplot(data$Ps)$out

indx_rem1 <-which(data$Fz %in% out)
indx_rem <- which(data$Ps %in% out2) # overlaps with out
indx_rm_all <- c(indx_rem1,indx_rem)

data_reduced <- data[-indx_rm_all,]
boxplot(data_reduced$Fz)
boxplot(data_reduced$Ps)

# linear models
library(lme4)
library(car)
#install.packages('lmerTest')
library(lmerTest)
library(ggplot2)

# if lag data
data_reduced$lag <- as.factor(data_reduced$lag)

# # ---- Fz Models ---- # #
Fz_model_present <- lmer(Fz ~ lag  + (1|subjID), data = data_reduced)
summary(Fz_model_present)

#plot data as boxplots for different presentations
plot_data <- data_reduced
plot_data$lag <- as.factor(plot_data$lag)
#plot_data$avg_lag <- as.factor(plot_data$avg_lag)

ggplot(plot_data, aes(x=lag, y=Fz)) + 
  geom_boxplot(aes(fill=lag), alpha=0.6, size = 0.8)+
  geom_point(color='black', size = 2, alpha= 0.5)+
  geom_line(aes(group=subjID), size=0.70, alpha = 0.5)

# # ---- PO3-P08 Models ---- # #
P_model_present <- lmer(Ps ~ lag + (1|subjID), data = data_reduced)
summary(P_model_present)


ggplot(plot_data, aes(x=lag, y=Ps)) + 
  geom_boxplot(aes(fill=lag), alpha=0.6, size = 0.8)+
  geom_point(color='black', size = 2, alpha= 0.5)+
  geom_line(aes(group=subjID), size=0.70, alpha = 0.5)


#if we remove lag 0
indx_lag_0 <- which(data_reduced$lag==1)
data_reduced_v2 <- data_reduced[-indx_lag_0,]
data_reduced_v2$lag <-as.numeric(data_reduced_v2$lag)

P_model_lag <- lmer(Ps ~ lag + (1|subjID), data = data_reduced_v2)
summary(P_model_lag)

F_model_lag <- lmer(Fz ~ lag + (1|subjID), data = data_reduced_v2)
summary(F_model_lag)

