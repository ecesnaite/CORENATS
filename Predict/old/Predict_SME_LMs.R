rm(list = ls())

#load data
data <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/subj_level_SEM_CORENATS_hemisphere_parietal.csv')#avg_SEM_lm_CORENATS.csv')#avg_ERPs_lm_CORENATS.csv')

# inspect data
# distribution of the response variables
hist(data$Fz)
max(data$Fz)

# remove outliers
Q <- quantile(data$Fz, probs=c(.25, .75), na.rm = FALSE)
iqr <- IQR(data$Fz)

data_clean<- subset(data, 
                    data$Fz > (Q[1] - 1.5*iqr) & data$Fz < (Q[2]+1.5*iqr))

Q2 <- quantile(data_clean$Ps, probs=c(.25, .75), na.rm = FALSE)
iqr2 <- IQR(data_clean$Ps)

data_clean2<- subset(data_clean, 
                     data_clean$Ps > (Q2[1] - 1.5*iqr2) & data_clean$Ps < (Q2[2]+1.5*iqr2))
hist(data_clean2$Fz)
hist(data_clean2$Ps)

table(data_clean2$subjID)

# linear models
library(lme4)
library(car)
#install.packages('lmerTest')
library(lmerTest)
library(ggplot2)

# num correct as factor to compare different conditions to one another
data_clean2$num_correct <- as.factor(data_clean2$num_correct)

# # ---- Fz Models ---- # #
Fz_model <- lmer(Fz ~ num_correct + (1|subjID), data = data_clean2)
summary(Fz_model)
vif(Fz_model)# high between presentation and lag

# # ---- PO3-P08 Models ---- # #
P_model <- lmer(Ps ~ num_correct + (1|subjID), data = data_clean2)
summary(P_model)


## MODEL ASSUMPTIONS ##

plot(mixed.lmer)  # looks alright, no patterns evident

qqline(resid(mixed.lmer))  # points fall nicely onto the line - good!

# remove the first presentation to test the lag effect
indx_1st <- which(data_clean2$Present_no == 1)
data_subsequent_present <- data_clean2[-indx_1st,]

subseq_model <- lmer(Fz ~ Present_no*lag  + (1|subjID), data = data_subsequent_present)
summary(subseq_model)

#Parietal electrodes might show an effect of a lag
data_subsequent_present$lag <- as.factor(data_subsequent_present$lag)
data_subsequent_present$Present_no <- as.factor(data_subsequent_present$Present_no)

ggplot(data_subsequent_present, aes(x=Present_no, y=Ps)) + 
  geom_boxplot()+
  stat_summary(fun=median, geom="line", aes(group=1, colour = 'red'), size = 0.7)  + 
  stat_summary(fun=median, geom="point")

