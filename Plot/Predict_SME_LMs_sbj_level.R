rm(list = ls())

#load data
data <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/subj_level_SEM_CORENATS.csv')

# inspect data

# outlier detection
out <- boxplot(data$Fz)$out
out2 <- boxplot(data$Ps)$out

indx_rem1<-which(data$Fz %in% out)
indx_rem <- which(data$Ps %in% out2) # overlaps with out
indx_rem_all <- c(indx_rem1,indx_rem)

data_reduced <- data[-indx_rem_all,]
boxplot(data_reduced$Fz)
boxplot(data_reduced$Ps)
# linear models
library(lme4)
library(car)
#install.packages('lmerTest')
library(lmerTest)
library(ggplot2)

cor.test(data_reduced$num_correct, data_reduced$avg_lag)

data_reduced$num_correct <- as.factor(data_reduced$num_correct)

# # ---- Fz Models ---- # #
Fz_model1 <- lmer(Fz ~ num_correct  + (1|subjID), data = data_reduced)
summary(Fz_model1)

Fz_model2 <- lmer(Fz ~ avg_lag  + (1|subjID), data = data_reduced)
summary(Fz_model2)


vif(Fz_model)# high between presentation and lag

#plot data as boxplots for different presentations
plot_data <- data_reduced
plot_data$num_correct <- as.factor(plot_data$num_correct)
#plot_data$avg_lag <- as.factor(plot_data$avg_lag)

ggplot(plot_data, aes(x=num_correct, y=Fz)) + 
  geom_boxplot(aes(fill=num_correct), alpha=0.6, size = 0.8)+
  geom_point(color='black', size = 2, alpha= 0.5)+
  geom_line(aes(group=subjID), size=0.70, alpha = 0.5)

# check mean and median values for each condition to make sure they match with the GA ERP plot
indx_0<- which(data_reduced$num_correct==0)
indx_1<- which(data_reduced$num_correct==1)
indx_2<- which(data_reduced$num_correct==2)

mean_zero <- mean(data_reduced$Fz[indx_0])
median_zero <- median(data_reduced$Fz[indx_0])

mean_one <- mean(data_reduced$Fz[indx_1])
median_one <- median(data_reduced$Fz[indx_1])

mean_two <- mean(data_reduced$Fz[indx_2])
median_two <- median(data_reduced$Fz[indx_2])

# # ---- PO3-P08 Models ---- # #
P_model1 <- lmer(Ps ~ num_correct + (1|subjID), data = data_reduced)
summary(P_model1)

P_model2 <- lmer(Ps ~ avg_lag + (1|subjID), data = data_reduced)
summary(P_model2)

vif(P_model)# high between presentation and lag
kappa(model.matrix(P_model))


ggplot(plot_data, aes(x=num_correct, y=Ps)) + 
  geom_boxplot(aes(fill=num_correct), alpha=0.6, size = 0.8)+
  geom_point(color='black', size = 2, alpha= 0.5)+
  geom_line(aes(group=subjID), size=0.70, alpha = 0.5)

 
ggplot(plot_data, aes(x=num_correct, y=avg_lag)) + 
  geom_boxplot()+
  stat_summary(fun=median, geom="line", aes(group=1, colour = 'red'), size = 0.7)  + 
  stat_summary(fun=median, geom="point")

