rm(list = ls())

# Libraries
#install.packages("paletteer")
library(svglite)
library(ggplot2)
library(paletteer)
library(tidyverse)

# Paths
outputDir <- '/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/'

## Frontal ##
#load data
ERP_frontal <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/ERP_present_frontal.csv')
ERP_no_time <- ERP_frontal[,-1] # remove time information

# transform to long format
long_frontal <- ERP_no_time %>% 
  pivot_longer(cols = colnames(ERP_no_time), 
               names_to = "condition",
               values_to = "value")

long_frontal$time <- rep(ERP_frontal$time, each = 3)


colorBlindBlack8  <- c("#000000", "#E69F00", "#56B4E9", "#009E73", 
                       "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

color_m <- c('#023743FF', '#72874EFF','#E69F00')

# plot
svglite(paste0(outputDir,'ERP_frontal.svg'), width=5, height=3.8)

p1 <- long_frontal %>%
  ggplot( aes(x=time, y=value, color=condition)) +
  geom_line() + 
  #set your preferred colors
  scale_color_manual(values = color_m) +
  #set a white canvas background
  theme_bw() +
  theme(text = element_text(size = 20),legend.title = element_text(size = 20),
        legend.text = element_text(size = 15), legend.position="top",
        legend.box="horizontal") + ylab(expression(paste(mu,"V"))) +
  #position the legend
  labs(color = "Nr. of presentation")+
  guides(col = guide_legend(title.position = "top",title.hjust =0.5)) +
  #add a vertical line for the stimulus presentation onset
  geom_vline(xintercept = 0, linetype="dashed", 
             color = "grey", size=1) 

# add a grey ractangle for the time window of interest + annotate it
p1 + annotate(geom="text",x=-50, y=-4, label="stimulus", color = "#696969",angle = 90, size =5) +
  annotate(geom="text", x=430, y=0, label="FN400", color = "#696969", size =5) +
  annotate("rect", xmin = 300, xmax = 550, ymin = -Inf, ymax = Inf, alpha = .1)

dev.off()

## Parietal channels ##
#load data
ERP_parietal <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/ERP_present_parietal.csv')
ERP_no_time <- ERP_parietal[,-1] # remove time information

# transform to long format
long_parietal <- ERP_no_time %>% 
  pivot_longer(cols = colnames(ERP_no_time), 
               names_to = "condition",
               values_to = "value")

long_parietal$time <- rep(ERP_parietal$time, each = 3)

# plot
svglite(paste0(outputDir,'ERP_parietal.svg'), width=5, height=3)

p1 <- long_parietal %>%
  ggplot( aes(x=time, y=value, color=condition)) +
  geom_line() + 
  scale_color_manual(values = color_m) +
  theme_bw() +
  theme(text = element_text(size = 20),legend.position = "none") +
  geom_vline(xintercept = 0, linetype="dashed", 
             color = "grey", size=1) +
  ylab(expression(paste(mu,"V"))) 

p1 + annotate(geom="text",x=-50, y=1, label="stimulus", color = "#696969",angle = 90, size =5) +
  annotate(geom="text", x=700, y=2.5, label="LPE", color = "#696969", size =5) +
  annotate("rect", xmin = 550, xmax = Inf, ymin = -Inf, ymax = Inf, alpha = .1)

dev.off()

