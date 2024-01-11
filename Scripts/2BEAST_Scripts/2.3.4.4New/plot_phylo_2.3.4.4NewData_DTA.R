# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(version = "3.15")
# library(BiocManager)
# install('ggtree')
rm(list=ls())
library(ggtree)
library(ape)
library(ggplot2)
library(treeio)
# library(RColorBrewer)

tree <- read.beast("randSampSub_AreaDTA.MCC.tree")
# x <- root(tree@phylo)
# tree@phylo <- x

col2<-c('black','#1F5CA7','#3EB5C3','#7A871E','#83CB84',
        '#FC8F42','#FEDB74','darkgrey','#FD4723','#EC9EC0','#E31F20','#B21368')

tree@data$location <- factor(tree@data$location, levels = c("Russia","Europe",
  "Mongolia","USAandCanada","JapanKorea","NChina","SChina","CA","WA","SEA",
  "Africa","LA"))
levels(tree@data$location)
options(ignore.negative.edge=TRUE)
ggtree(tree,aes(color=location),mrsd = "2023-07-11")+
  theme_tree2()+
  scale_color_manual(values = col2)+
  theme(legend.position = "right")+
  scale_x_continuous(breaks=seq(2012,2024,1),label = c('2012','','2014','','2016','','2018','','2020','',
                                                       '2022','',''))
ggsave('2.3.4.4NewData.areaDTA.MCC.tree2.pdf',width=5,height=5)

