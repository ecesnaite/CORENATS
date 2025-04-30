rm(list = ls())

# Libraries
#install.packages("remotes")
#remotes::install_github("craddm/eegUtils")
library(eegUtils)
#remotes::install_github("jonocarroll/ggeasy")
library(ggeasy)

# Set paths
outputDir <- "/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/R/Figures/"

# Load data
my_data <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/SEM_difference_LPE_topo.csv')
my_chan_locs <- read.csv('/Volumes/aebusch/nbuschgold/ecesnait/Corenats/2024/Matlab code/Output/my_chan_locs.csv')

# create your own structure
plot_data <- data.frame(my_chan_locs$labels, my_chan_locs$X, my_chan_locs$Y, my_data$never_once)
colnames(plot_data) <- c('electrode', 'x','y','amplitude')

file_title = "LPE_topo_SME_never_once"
gtitle = "LPE"

tiff(paste0(outputDir,file_title,".png"), units="in", width=3.5, height=2.5, res=300)

p <- topoplot(plot_data)
p + theme(text = element_text(size = 13))  +
  ggtitle(gtitle)+
  theme(plot.title = element_text(size = 15)) +
  ggeasy::easy_center_title()

dev.off()


