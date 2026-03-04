rm(list = ls())

# Libraries
#install.packages("paletteer")
library(paletteer)
library(tidyverse)
library(viridis)
library(ggsignif)

## PRESENTATION ##
#load data
Accu_press <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_presentations.csv')
Accu_press <- Accu_press[-14,]

# transform to long format
long_accu <- Accu_press %>% 
  pivot_longer(cols = colnames(Accu_press), 
               names_to = "press",
               values_to = "value")

color_m <- c('#023743FF', '#72874EFF','#E69F00')#c("#00A087", "#F39B7F", "#8491B4")

# plot
tiff("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/Accuracy_pres.png", units="in", width=3, height=3, res=300)

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
                            "accuracy_plot_niko3" = "3rd")) + ylab("accuracy(%)") +
  geom_signif(comparisons = list(c("accuracy_plot_niko1", "accuracy_plot_niko3")), 
              map_signif_level=TRUE)+
  geom_signif(comparisons=list(c("accuracy_plot_niko1", "accuracy_plot_niko2")), annotations="n.s.",
              y_position = 88)
dev.off()

## LAGS ##
#load data
Accu_lag_pres_2 <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_lag_2nd.csv')
Accu_lag_pres_2 <- Accu_lag_pres_2[-14,]

long_accu_lag2 <- Accu_lag_pres_2 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

long_accu_lag2$lag <- rep(c(1:5), 31) 

# for plotting
#Accu_lag_pres_2$lag0 <- Accu_press$accuracy_plot_niko1

#Accu_lag_pres_2<- Accu_lag_pres_2[,c(6,1:5)]
colnames(Accu_lag_pres_2) <- c( "10", "16", "24", "38", "60")

# transform to long format
long_accu_lag2 <- Accu_lag_pres_2 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

#colors

color_lag <- paletteer_c("grDevices::Peach", 5)
#color_lag <- c('#023743FF',color_lag)
# plot
tiff("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/Accu_lag_2nd_pres_no_0.png", units="in", width=4, height=3, res=300)

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

#load data
Accu_lag_pres_3 <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/Accuracy_lag_3rd.csv')
Accu_lag_pres_3 <- Accu_lag_pres_3[-14,]

# transform to long format
long_accu_lag3 <- Accu_lag_pres_3 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_3), 
               names_to = "lag",
               values_to = "value")

long_accu_lag3$lag <- rep(c(1:5), 31) 


#for plotting
#Accu_lag_pres_3$lag0 <- Accu_press$accuracy_plot_niko1

#Accu_lag_pres_3<- Accu_lag_pres_3[,c(6,1:5)]
colnames(Accu_lag_pres_3) <- c("10", "16", "24", "38", "60")

# transform to long format
long_accu_lag3 <- Accu_lag_pres_3 %>% 
  pivot_longer(cols = colnames(Accu_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

# plot
tiff("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/Accu_lag_3rd_pres_no_0.png", units="in", width=4, height=3, res=300)

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

