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

tree <- read.beast("2.3.4.4fAreaDTA.MCC.tree")
x <- root(tree@phylo, outgroup = "180649/Goose/China/2009-12-10/H5N1", resolve.root = TRUE)
tree@phylo <- x

# col2<-c('#091E57','#1F5CA7','#3EB5C3','#83CB84',
#         '#FC8F42','#FEDB74','darkgrey','#810828','#FD4723','#E31F20','#252525')

col2<-c('black','#1F5CA7','#7A871E','#83CB84','#B4F8C8',
        '#FC8F42','#FBE7C6','#FEDB74','darkgrey','#EC9EC0','#E31F20')

tree@data$location <- factor(tree@data$location, levels = c(
  "Russia","Europe","USAandCanada","JapanKorea","Qinghai","NChina",
  "NChina+SChina","SChina","CA","SEA","Africa"))
levels(tree@data$location)
options(ignore.negative.edge=TRUE)

p <- ggtree(tree,aes(color=location),mrsd = "2018-01-10")+
  theme_tree2()+
  scale_color_manual(values = col2)+
  theme(legend.position = "right")+
  scale_x_continuous(breaks=seq(2010,2018,1),
                     label = c('2010','','2012','','2014','','2016','','2018'))
  # geom_text(aes(label=node))

flip(p, node1 = 1847, node2 = 1848)
ggsave('2.3.4.4.DTA.MCC.tree_filp.pdf',width=5,height=6.7)
