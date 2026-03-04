rm(list = ls())

# Libraries
#install.packages("remotes")
#remotes::install_github("craddm/eegUtils")
library(eegUtils)
#remotes::install_github("jonocarroll/ggeasy")
library(ggeasy)
library(ggplot2)
library(RColorBrewer)
library(tidyverse)

brewer.pal(n = 7, name = "RdBu")

ERP_lim <- c(-3,1.5)
lags <- c(-6.2, 4.2)

sme <- c(-1,5)

# Set paths
outputDir <- "/Users/ecesnaite/Desktop/BuschLab/CORENATS/Final_figures/"

# Load data
my_data <- read.csv('/Users/ecesnaite/Desktop/BuschLab/CORENATS/Output/ERP_difference_LPE_topo.csv')
my_chan_locs <- read.csv('/Users/ecesnaite/Desktop/BuschLab/CORENATS/Output/my_chan_locs.csv')

# create your own structure for plotting
plot_data <- data.frame(my_chan_locs$labels, my_chan_locs$X, my_chan_locs$Y, my_data$second_first)
colnames(plot_data) <- c('electrode', 'x','y','amplitude')

#channel data is rotated for no clear reason.
plot_data <- rotate_angle(plot_data, 90)

# take channels that should be marked with an asterisk
chan <- c("CPz", "Pz", "P1", "P2")#c("CPz", "Pz", "P1", "P2")#c("AFz", "Fz", "F1", "F2")

#chan <- c('PO7', 'PO3', 'PO8', 'PO4') # SME LPE

high_x <- plot_data$x[plot_data$electrode %in% chan]
high_y <- plot_data$y[plot_data$electrode %in% chan]

# prepare titles for plotting

file_title = "LPE_topo_second_first"
gtitle = "LPE \n (second-first)"

# plot data

tiff(paste0(outputDir,file_title,".png"), units="in", width=4, height=3, res=300)

p <- topoplot(plot_data)+
  annotate("text", x = high_x, y = high_y, label = "*", vjust=0.78, size = 12)

p + scale_fill_gradient2(low="#4575B4", mid="#F7F7F7", high="#D73027",midpoint=0, lim=ERP_lim)+#
  theme(text = element_text(size = 13))  +
  ggtitle(gtitle)+
  theme(plot.title = element_text(size = 15)) +
  ggeasy::easy_center_title()

dev.off()

