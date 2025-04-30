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

color_m <- c('#023743FF', '#72874EFF','#E69F00')#c("#00A087", "#F39B7F", "#8491B4")

# plot
tiff("/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/R/Figures/RT_pres.png", units="in", width=3, height=3, res=300)

long_RT %>%
  ggplot( aes(x=press, y=value, fill=press)) +
  geom_boxplot(fatten = NULL)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.75, size = 1, linetype = "solid")+
  scale_fill_manual(values = color_m) +
 theme_bw()+
  theme(legend.position="none",text = element_text(size = 20)) +
  scale_x_discrete(name ="presentation", 
                   labels=c("RT_pres1" = "1st", "RT_pres2" = "2nd",
                            "RT_pres3" = "3rd")) + ylab("seconds") 
dev.off()

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

RT_model2 <- lm(value ~ lag , data = long_RT_lag2)
summary(RT_model2)
#colors

color_lag <- paletteer_c("grDevices::Peach", 5)
color_lag <- c('#023743FF',color_lag)

# plot
tiff("/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/R/Figures/RT_lag_2nd_pres.png", units="in", width=4, height=3, res=300)

long_RT_lag2 %>%
  ggplot( aes(x=lag, y=value, fill=lag)) +
  geom_boxplot(fatten = NULL)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.75, size = 1, linetype = "solid")+
  scale_fill_manual(values = color_lag) +
 theme_bw()+
  theme(legend.position="none",text = element_text(size = 20)) +
  scale_x_discrete(name ="lag", 
                   labels=c("V1" = "0", "V2" = "10","V3" = "16","V4" = "24", "V5"="38",
                            "V6" = "60")) + ylab("seconds") + ggtitle("2nd presentation")+ylim(0.4, 2)
dev.off()

#load data
RT_lag_pres_3 <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/RT_lag_pres_3.csv')
RT_lag_pres_3 <- RT_lag_pres_3[,-14]
RT_lag_pres_3 <- as.data.frame(t(RT_lag_pres_3))

# transform to long format
long_RT_lag3 <- RT_lag_pres_3 %>% 
  pivot_longer(cols = colnames(RT_lag_pres_3), 
               names_to = "lag",
               values_to = "value")
RT_model3 <- lm(value ~ lag , data = long_RT_lag3)
summary(RT_model3)

# plot
tiff("/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/R/Figures/RT_lag_3rd_pres.png", units="in", width=4, height=3, res=300)

long_RT_lag3 %>%
  ggplot( aes(x=lag, y=value, fill=lag)) +
  geom_boxplot(fatten = NULL)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.75, size = 1, linetype = "solid")+
  scale_fill_manual(values = color_lag) +
 theme_bw()+
  theme(legend.position="none",text = element_text(size = 20)) +
  scale_x_discrete(name ="lag", 
                   labels=c("V1" = "0", "V2" = "10","V3" = "16","V4" = "24", "V5"="38",
                            "V6" = "60")) + ylab("seconds") + ggtitle("3rd presentation")+ylim(0.4, 2)
dev.off()

