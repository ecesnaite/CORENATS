rm(list = ls())

# Libraries
#install.packages("paletteer")
library(paletteer)
library(tidyverse)
library(svglite)

outputDir <- '/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/'

## Frontal ##
#load data
SEM_frontal <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/SEM_frontal.csv')
SEM_no_time <- SEM_frontal[,-1] # remove the column associated with time

# transform to long format
long_frontal <- SEM_no_time %>% 
  pivot_longer(cols = colnames(SEM_no_time), 
               names_to = "condition",
               values_to = "value")

long_frontal$time <- rep(SEM_frontal$time, each = 3)

color_m <- c('#B2B2B2','#5F9BBC','#14405A')#c("#00A087", "#F39B7F", "#8491B4")

# plot
svglite(paste0(outputDir,'SME_frontal.svg'), width=5, height=3.8)

p1 <- long_frontal %>%
  ggplot( aes(x=time, y=value, color=condition)) +
  geom_line() + 
  scale_color_manual(values = color_m) +
  theme_bw() +
  theme(text = element_text(size = 20),legend.title = element_text(size = 20),
        legend.text = element_text(size = 15), legend.position="top",
        legend.box="horizontal") + 
  guides(col = guide_legend(title.position = "top",title.hjust =0.5)) +
  geom_vline(xintercept = 0, linetype="dashed", 
             color = "grey", size=1) +
  ylab(expression(paste(mu,"V"))) +labs(color = "Nr. times remembered")

p1 + annotate(geom="text",x=-50, y=-4, label="stimulus", color = "#696969",angle = 90, size =5) +
  annotate(geom="text", x=430, y=0, label="FN400", color = "#696969", size =5) +
  annotate("rect", xmin = 300, xmax = 550, ymin = -Inf, ymax = Inf, alpha = .1)

dev.off()


## Parietal channels ##
#load data
SEM_parietal <- read.csv('/Volumes/aebusch/aebuschgold/ecesnait/Corenats/2024/Matlab code/Output/SEM_parietal_centroparietal.csv')
SEM_no_time <- SEM_parietal[,-1] # remove time

# transform to long format
long_parietal <- SEM_no_time %>% 
  pivot_longer(cols = colnames(SEM_no_time), 
               names_to = "condition",
               values_to = "value")

long_parietal$time <- rep(SEM_parietal$time, each = 3)

color_m <- c('#B2B2B2','#5F9BBC','#14405A')#c("#00A087", "#F39B7F", "#8491B4")

# plot
svglite(paste0(outputDir,'SME_parietal.svg'), width=5, height=3)

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

