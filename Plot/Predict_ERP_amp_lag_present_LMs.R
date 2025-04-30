rm(list = ls())

#load data
data <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/avg_ERPs_lm_CORENATS.csv')

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


# linear models
library(lme4)
library(car)
install.packages('lmerTest')
library(lmerTest)
library(ggplot2)

# # ---- Fz Models ---- # #
Fz_model <- lmer(Fz ~ Present_no*lag  + (1|subjID), data = data_clean2)
summary(Fz_model)
vif(Fz_model)# high between presentation and lag

# compare reduced models
Fz_model_presentation <- lmer(Fz ~ Present_no  + (1|subjID), data = data_clean2)
summary(Fz_model_presentation)

Fz_model_lag <- lmer(Fz ~ lag  + (1|subjID), data = data_clean2)
summary(Fz_model_lag)

#model comparisson
install.packages('AICcmodavg')
library(AICcmodavg)

#define list of models
models <- list(Fz_model, Fz_model_presentation, Fz_model_lag)

#specify model names
mod.names <- c('full', 'presentation', 'lag')

#calculate AIC of each model. Model with the lowest AICc fits the data the best
aictab(cand.set = models, modnames = mod.names) # the presentation models fits the data slightly better than the lag model
#plot data as boxplots for different presentations
plot_data <- data_clean2
plot_data$Present_no <- as.factor(plot_data$Present_no)
plot_data$lag <- as.factor(plot_data$lag)

ggplot(plot_data, aes(x=Present_no, y=Fz)) + 
  geom_boxplot()+
  stat_summary(fun=median, geom="line", aes(group=1, colour = 'red'), size = 0.7)  + 
  stat_summary(fun=median, geom="point")

# # ---- PO3-P08 Models ---- # #
P_model <- lmer(Ps ~ Present_no*lag  + (1|subjID), data = data_clean2)
summary(P_model)
vif(Fz_model)# high between presentation and lag

# compare reduced models
P_model_presentation <- lmer(Ps ~ Present_no  + (1|subjID), data = data_clean2)
summary(P_model_presentation)

P_model_lag <- lmer(Ps ~ lag  + (1|subjID), data = data_clean2)
summary(P_model_lag)

#model comparisson

#define list of models
models <- list(P_model, P_model_presentation, P_model_lag)

#specify model names
mod.names <- c('full', 'presentation', 'lag')

#calculate AIC of each model. Model with the lowest AICc fits the data the best
aictab(cand.set = models, modnames = mod.names) # the presentation models fits the data slightly better than the lag model

ggplot(plot_data, aes(x=Present_no, y=Ps)) + 
  geom_boxplot()+
  stat_summary(fun=median, geom="line", aes(group=1, colour = 'red'), size = 0.7)  + 
  stat_summary(fun=median, geom="point")

ggplot(plot_data, aes(x=lag, y=Ps)) + 
  geom_boxplot()+
  stat_summary(fun=median, geom="line", aes(group=1, colour = 'red'), size = 0.7)  + 
  stat_summary(fun=median, geom="point")

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

