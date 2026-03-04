rm(list = ls())

# Libraries
#install.packages("paletteer")
library(paletteer)
library(tidyverse)
library(viridis)
library(ggsignif)


## PRESENTATION ##
#load data
RT_press <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/RT_num_pres.csv')
RT_press <- RT_press[-14,]

# transform to long format
long_RT <- RT_press %>% 
  pivot_longer(cols = colnames(RT_press), 
               names_to = "press",
               values_to = "value")

color_m <- c('#023743FF', '#72874EFF','#E69F00')#c("#00A087", "#F39B7F", "#8491B4")

# plot
tiff("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/RT_pres.png", units="in", width=3, height=3, res=300)

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
                            "RT_pres3" = "3rd")) + ylab("seconds") + 
  geom_signif(comparisons = list(c("RT_pres1", "RT_pres3")), map_signif_level=TRUE,y_position = 1.6)+
  geom_signif(comparisons=list(c("RT_pres1", "RT_pres2")), annotations="n.s.",
              y_position = 1.4)
dev.off()

## LAGS ##
#load data
RT_lag_pres_2 <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/RT_lag_pres_2.csv')
RT_lag_pres_2 <- RT_lag_pres_2[-1,-14]# remove the first presentation with no lag
RT_lag_pres_2 <- as.data.frame(t(RT_lag_pres_2))

# transform to long format
colnames(RT_lag_pres_2) <- c( "10", "16", "24", "38", "60")

long_RT_lag2 <- RT_lag_pres_2 %>% 
  pivot_longer(cols = colnames(RT_lag_pres_2), 
               names_to = "lag",
               values_to = "value")

#colors

color_lag <- paletteer_c("grDevices::Peach", 5)
#color_lag <- c('#023743FF',color_lag)

# plot
tiff("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/RT_lag_2nd_pres.png", units="in", width=4, height=3, res=300)

long_RT_lag2 %>%
  ggplot( aes(x=lag, y=value, fill=lag)) +
  geom_boxplot(fatten = NULL)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.75, size = 1, linetype = "solid")+
  scale_fill_manual(values = color_lag) +
 theme_bw()+
  theme(legend.position="none",text = element_text(size = 20)) +
 ylab("seconds") + ggtitle("2nd presentation")+ylim(0.5, 1.5)

dev.off()

#load data
RT_lag_pres_3 <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/RT_lag_pres_3.csv')
RT_lag_pres_3 <- RT_lag_pres_3[-1,-14]
RT_lag_pres_3 <- as.data.frame(t(RT_lag_pres_3))

# transform to long format
colnames(RT_lag_pres_3) <- c( "10", "16", "24", "38", "60")

long_RT_lag3 <- RT_lag_pres_3 %>% 
  pivot_longer(cols = colnames(RT_lag_pres_3), 
               names_to = "lag",
               values_to = "value")

# plot
tiff("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/RT_lag_3rd_pres.png", units="in", width=4, height=3, res=300)

long_RT_lag3 %>%
  ggplot( aes(x=lag, y=value, fill=lag)) +
  geom_boxplot(fatten = NULL)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.75, size = 1, linetype = "solid")+
  scale_fill_manual(values = color_lag) +
 theme_bw()+
  theme(legend.position="none",text = element_text(size = 20)) +ylab("seconds") + ggtitle("3rd presentation")+ylim(0.5, 1.5)
dev.off()

