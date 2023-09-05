# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(version = "3.15")
# library(BiocManager)
# install('ggtree')
rm(list=ls())
setwd('/Users/qiqiy/Documents/P2_WAI/P2_WAI/Phylo_Analysis/DTA/location/2.3.2.1fAreaDTA_empT')
library(ggtree)
library(ape)
library(ggplot2)
library(treeio)
# library(RColorBrewer)

tree <- read.beast("2.3.2.1fAreaDTA.MCC.sub100.tree")
x <- root(tree@phylo, outgroup = "116930/Chicken/China/2007-05-13/H5N1", resolve.root = TRUE)
tree@phylo <- x

col2<-c('#091E57','#1F5CA7','#99E1D9','grey','#83CB84',
        '#FC8F42','#FEDB74','#810828','#FD4723',
        '#DC94A5','#E31F20','#252525')
# "Russia","Europe","USAandCanada","JapanKorea","Qinghai","NChina",
# "NChina+SChina","SChina","CA","SEA","Africa"
tree@data$location <- factor(tree@data$location, levels = c(
  "Russia","Europe","Mongolia","Mongolia+WA","JapanKorea","Qinghai","NChina",
  "SChina","CA","WA","SEA","Africa"))
levels(tree@data$location)
options(ignore.negative.edge=TRUE)
ggtree(tree,aes(color=location),mrsd = "2018-01-01")+
  theme_tree2()+
  scale_color_manual(values = col2)+
  theme(legend.position = "right")+
  scale_x_continuous(breaks=seq(2004,2018,1),label = c('2004','','2006','','2008','','2010','','2012','','2014','','2016','','2018'))
ggsave('2.3.2.1.DTA.MCC.tree.png',height=8,width=6)
