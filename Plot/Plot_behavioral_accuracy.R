rm(list = ls())

# Libraries
#install.packages("svglite")
library(svglite)
library(paletteer)
library(tidyverse)
library(viridis)
library(ggsignif)

## PRESENTATION ##
#load data
Accu_press <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_presentations.csv')
Accu_press <- Accu_press[-14,] #remove outlier

# transform to long format
long_accu <- Accu_press %>% 
  pivot_longer(cols = colnames(Accu_press), 
               names_to = "press",
               values_to = "value")

color_m <- c('#023743FF', '#72874EFF','#E69F00')#c("#00A087", "#F39B7F", "#8491B4")

# plot
svglite("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/Accuracy_pres.svg", width = 3, height = 3)

long_accu %>%
  ggplot( aes(x=press, y=value, fill=press)) +
  geom_boxplot(fatten = NULL)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.75, size = 1, linetype = "solid")+
  scale_fill_manual(values = color_m) +
 theme_bw()+
  theme(legend.position="none",text = element_text(size = 20)) + ylim(50,103)+
  scale_x_discrete(name ="presentation", 
                   labels=c("accuracy_plot_niko1" = "1st", "accuracy_plot_niko2" = "2nd",
                            "accuracy_plot_niko3" = "3rd")) + ylab("accuracy(%)") 
dev.off()

## LAGS ##
#load data
Accu_lag_pres_2 <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_lag_2nd.csv')
Accu_lag_pres_2 <- Accu_lag_pres_2[-14,] # outlier

long_accu_lag2 <- Accu_lag_pres_2 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

long_accu_lag2$lag <- rep(c(1:5), 31) 

# for plotting
colnames(Accu_lag_pres_2) <- c( "10", "16", "24", "38", "60")

# transform to long format
long_accu_lag2 <- Accu_lag_pres_2 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

#colors

color_lag <- paletteer_c("grDevices::Peach", 5)

# plot
svglite("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/Accu_lag_2nd_pres_no_0.svg", width = 4, height = 3)

long_accu_lag2 %>%
  ggplot( aes(x=lag, y=value, fill=lag)) +
  geom_boxplot(fatten = NULL)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.75, size = 1, linetype = "solid")+
  scale_fill_manual(values = color_lag) +
 theme_bw()+
  theme(legend.position="none",text = element_text(size = 20)) +
  scale_x_discrete(name ="lag") + ylab("accuracy(%)") + ggtitle("2nd presentation")+ylim(39, 100)
dev.off()

#load data for presentation 3
Accu_lag_pres_3 <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_lag_3rd.csv')
Accu_lag_pres_3 <- Accu_lag_pres_3[-14,] # outlier

# transform to long format
long_accu_lag3 <- Accu_lag_pres_3 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_3), 
               names_to = "lag",
               values_to = "value")

long_accu_lag3$lag <- rep(c(1:5), 31) 


#for plotting
colnames(Accu_lag_pres_3) <- c("10", "16", "24", "38", "60")

# transform to long format
long_accu_lag3 <- Accu_lag_pres_3 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

# plot
svglite("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/Accu_lag_3rd_pres_no_0.svg", width = 4, height = 3)

long_accu_lag3 %>%
  ggplot( aes(x=lag, y=value, fill=lag)) +
  geom_boxplot(fatten = NULL)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.75, size = 1, linetype = "solid")+
  scale_fill_manual(values = color_lag) +
 theme_bw()+
  theme(legend.position="none",text = element_text(size = 20)) +
  scale_x_discrete(name ="lag") + ylab("accuracy(%)") + ggtitle("3rd presentation")+ylim(39, 100)
dev.off()

