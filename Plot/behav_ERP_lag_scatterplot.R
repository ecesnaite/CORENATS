rm(list = ls())

# Libraries
#install.packages("paletteer")
library(paletteer)
library(tidyverse)

## Parietal ##
#load data
ERP <- read.csv('/Users/ecesnaite/Desktop/BuschLab/CORENATS/Output/subj_level_GA_ERP_lag.csv')

#remove lag 0 (first presentation of a stimulus) from the data
indx_lag_0 <- ERP$lag==1
ERP <- ERP[-which(indx_lag_0),]
ERP <- as.data.frame(ERP)

# remove outliers
data <- ERP

Q_Fz <- quantile(data$Fz, probs=c(.25, .75), na.rm = FALSE)
iqr_Fz <- IQR(data$Fz)

indx_out_Fz<- which(data$Fz > (Q_Fz[1] - 1.5*iqr_Fz) & data$Fz < (Q_Fz[2]+1.5*iqr_Fz))
data <- data[indx_out_Fz,]

Q_Pz <- quantile(data$Ps, probs=c(.25, .75), na.rm = FALSE)
iqr_Pz <- IQR(data$Ps)

indx_out_Pz <- which(data$Ps > (Q_Pz[1] - 1.5*iqr_Pz) & data$Ps < (Q_Pz[2]+1.5*iqr_Pz))
data <- data[indx_out_Pz,]

hist(data$Fz)
hist(data$Ps)

ERP <- data

#take only parietal: ERP amplitude for each lag condition for each subject, but no lag 0
ERP_parietal <- ERP[,-2]

#behavioral data: accuracy for each lag each participant

Accu_lag_pres_2 <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_lag_2nd.csv')
Accu_lag_pres_2 <- Accu_lag_pres_2[-14,]

Accu_lag_pres_3 <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_lag_3rd.csv')
Accu_lag_pres_3 <- Accu_lag_pres_3[-14,]

Accu_lag_together <- (Accu_lag_pres_2+Accu_lag_pres_3)/2

long_accu<- Accu_lag_together %>% 
  pivot_longer(cols = colnames(Accu_lag_together), 
               names_to = "lag",
               values_to = "value")

long_accu <- long_accu[indx_out_Fz,]
long_accu <- long_accu[indx_out_Pz,]

# join both measures to the long format
scatter_data <- ERP_parietal
 
scatter_data$accu <- long_accu$value
scatter_data$lag <- as.factor(scatter_data$lag)

 # plot scatterplot
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
cols = gg_color_hue(5)

 ggplot(scatter_data, aes(x=Ps, y=accu, color=lag)) +
   geom_point() + scale_color_manual(labels = c("10", "16", "24", "38", "60"), values = cols) +
   xlab("ERP amp") + ylab("Accuracy (%)")

 #plot boxplot
 ggplot(scatter_data, aes(x=lag, y=accu, fill=lag)) +
   geom_boxplot() +
   scale_x_discrete(labels=c("10", "16", "24", "38", "60"))+
   guides(fill="none")+
   xlab("Lag") + ylab("Accuracy (%)")
 
 # find mean for each lag condition
 mean_lag_erp <- c(mean(scatter_data$Ps[scatter_data$lag==2]), mean(scatter_data$Ps[scatter_data$lag==3]),
   mean(scatter_data$Ps[scatter_data$lag==4]),mean(scatter_data$Ps[scatter_data$lag==5]),
   mean(scatter_data$Ps[scatter_data$lag==6]))
 
 ggplot(scatter_data, aes(x=lag, y=Ps, fill=lag)) +
   geom_boxplot(mapping = NULL)+ 
   scale_x_discrete(labels=c("10", "16", "24", "38", "60"))+
   stat_summary(fun.y=mean, geom="text", label = round(mean_lag_erp,2), size=5)+
   guides(fill="none")+
   xlab("Lag") + ylab("ERP amp")
 