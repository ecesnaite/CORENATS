rm(list = ls())

# Libraries
#install.packages("paletteer")
library(paletteer)
library(tidyverse)

## Frontal ##
#load data
ERP_frontal <- read.csv('/Users/ecesnaite/Desktop/BuschLab/CORENATS/Output/ERP_lag_frontal.csv')
ERP_no_time <- ERP_frontal[,c(-1,-2)]

# transform to long format
long_frontal <- ERP_no_time %>% 
  pivot_longer(cols = colnames(ERP_no_time), 
               names_to = "condition",
               values_to = "value")

long_frontal$time <- rep(ERP_frontal$time, each = 5)
long_frontal$condition <- as.character(rep(c(10,16,24,38,60), 256)) 

#colors

color_lag <- paletteer_c("grDevices::Peach", 5)
#color_lag <- c('#023743FF',color_lag)

# plot
tiff("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/ERP_frontal_lag_no_0.png", units="in", width=5, height=3.8, res=150)

p1 <- long_frontal %>%
  ggplot( aes(x=time, y=value, color=condition)) +
  geom_line() + 
  scale_color_manual(values = color_lag) +
  theme_bw() +
  theme(text = element_text(size = 20),legend.title = element_text(size = 20),
        legend.text = element_text(size = 15), legend.position="top",
        legend.box="horizontal") + 
  guides(col = guide_legend(title.position = "top",title.hjust =0.5)) +
  geom_vline(xintercept = 0, linetype="dashed", 
             color = "grey", size=1) +
  ylab(expression(paste(mu,"V"))) +labs(color = "Lags")

p1 + annotate(geom="text",x=-50, y=-4, label="stimulus", color = "#696969",angle = 90, size =5) +
  annotate(geom="text", x=430, y=0, label="FN400", color = "#696969", size =5) +
  annotate("rect", xmin = 300, xmax = 550, ymin = -Inf, ymax = Inf, alpha = .1)

dev.off()



## Parietal ##
#load data
ERP_parietal <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/ERP_lag_parietal.csv')
ERP_no_time <- ERP_parietal[,c(-1,-2)]

# transform to long format
long_parietal <- ERP_no_time %>% 
  pivot_longer(cols = colnames(ERP_no_time), 
               names_to = "condition",
               values_to = "value")

long_parietal$time <- rep(ERP_parietal$time, each = 5)

# plot
tiff("/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/ERP_parietal_lag_no_0.png", units="in", width=5, height=3, res=150)

p1 <- long_parietal %>%
  ggplot( aes(x=time, y=value, color=condition)) +
  geom_line() + 
  scale_color_manual(values = color_lag) +
  theme_bw() +
  theme(text = element_text(size = 20),legend.position = "none") +
  geom_vline(xintercept = 0, linetype="dashed", 
             color = "grey", size=1) +
  ylab(expression(paste(mu,"V"))) 

p1 + annotate(geom="text",x=-50, y=1.8, label="stimulus", color = "#696969",angle = 90, size =5) +
  annotate(geom="text", x=700, y=6, label="LPE", color = "#696969", size =5) +
  annotate("rect", xmin = 550, xmax = Inf, ymin = -Inf, ymax = Inf, alpha = .1)

dev.off()

