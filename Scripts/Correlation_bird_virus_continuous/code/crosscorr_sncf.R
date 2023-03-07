library(dplyr)
library(tidyr)
#install.packages('ncf')
library(ncf)
library(lubridate)
setwd('/Users/qiqiy/Documents/P2_WAI/manuscript/HPAI_Bird_world/Scripts/Correlation_bird_virus_continuous/data')
# virus <- read.csv('dataset_2.3.4.4.csv')
# bird <- read.csv('2.3.4.4_crosscorr/allbirds_prob.csv')
virus2 <- read.csv('2.3.4.4_crosscorr/virus_prob_minHPD.csv') %>%
  select(-X,-point,-lon_indx,-lat_indx) %>%
  mutate(year=year(ymd(Date)),month=month(ymd(Date)))
## viruses
virus <- virus2 %>%
  select(Date,year,month,lat,lon,virus) %>%
  arrange(year,month)
# virus_wide <- virus %>%
#   pivot_wider(id_cols = c(lat,lon),names_from = Date,
#               values_from = virus)
# virus.m <- as.matrix(virus_wide %>% select(-lat,-lon))
# virus.m[is.na(virus.m)]<-0
# snf.virus <- Sncf(x=virus_wide$lon,y=virus_wide$lat,z=virus.m,na.rm=TRUE,
#                   latlon = TRUE)
# pdf(file = 'snf.virus.pdf')
# plot(snf.virus)
# dev.off()

# virus_08_13 <- virus_wide[,c(1:73)]
# virus_14_18 <- virus_wide[,c(1:2,74:121)]

## birds
bird <- virus2 %>%
  select(-virus) %>%
  arrange(year,month)

Pelecan <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Pelecaniformes)
Grui <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Gruiformes)
Passerin <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Passeriformes)
Suli <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Suliformes)
Cicon <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Ciconiiformes)
Falcon <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Falconiformes)
Charad <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Charadriiformes)
Anser <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Anseriformes)
Accipit <- bird %>%
  pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Accipitriformes)

# Procella <- bird %>%
#   pivot_wider(id_cols = c(lat,lon),names_from=Date,values_from=Procellariiformes)
birds.dfs <- list(Pelecan,Grui,Passerin,Suli,Cicon,Falcon,Charad,Anser,Accipit)
# birds.dfs_08_13 <- list()
# birds.dfs_14_18 <- list()
# for (order in 1:length(birds.dfs)){
#   birds.dfs_08_13[[order]] <- birds.dfs[[order]][,c(1:73)]
#   birds.dfs_14_18[[order]] <- birds.dfs[[order]][,c(1:2,74:121)]
# }
birds.names <- c('Pelecaniformes','Gruiformes','Passeriformes',
                 'Suliformes', 'Ciconiiformes', 'Falconiformes',
                 'Charadriiformes', 'Anseriformes', 'Accipitriformes')




birds.m.ls <- list()
for(idx in c(1:9)){
  birds.m <- as.matrix(birds.dfs[[idx]] %>% select(-lat,-lon))
  birds.m[is.na(birds.m)]<-0
  birds.m.ls[[idx]] <- birds.m
}

snf.ls <- list()
for (idx in c(1:9)){
  snf.ls[[idx]] <- Sncf(x=birds.dfs[[idx]]$lon,y=birds.dfs[[idx]]$lat,
                        z=birds.m.ls[[idx]],na.rm=TRUE,latlon = TRUE)
  pdf(file = paste0('snf.',birds.names[idx],'.pdf'))
  plot(snf.ls[[idx]])
  dev.off()
}

# # cross-correlation
snf.Pelecan <- Sncf(x=virus_wide$lon,y=virus_wide$lat,z=virus.m,
                    w=birds.m.ls[[1]],na.rm=TRUE,latlon = TRUE)
pdf(file='snf_virus_Pelecans.pdf')
plot(snf.Pelecan)
dev.off()

snf.ls <- list()
snf.ls[[1]] <- snf.Pelecan
for (idx in c(2:9)){
  snf.ls[[idx]] <- Sncf(x=virus_wide$lon,y=virus_wide$lat,z=virus.m,
                        w=birds.m.ls[[idx]],na.rm=TRUE,latlon = TRUE)
  pdf(file = paste0('snf_virus_',birds.names[idx],'.pdf'))
  plot(snf.ls[[idx]])
  dev.off()
}
# 08-13
virus.m_08 <- as.matrix(virus_08_13 %>% select(-lat,-lon))
virus.m_08[is.na(virus.m_08)]<-0
birds.m.ls_08 <- list()
for(idx in c(1:9)){
  birds.m <- as.matrix(birds.dfs_08_13[[idx]] %>% select(-lat,-lon))
  birds.m[is.na(birds.m)]<-0
  birds.m.ls_08[[idx]] <- birds.m
  
}
# cross-correlation
snf.Pelecan_08 <- Sncf(x=virus_08_13$lon,y=virus_08_13$lat,z=virus.m_08,
                    w=birds.m.ls_08[[1]],na.rm=TRUE,latlon = TRUE)
pdf(file='snf_08_13/snf_virus_Pelecans.pdf')
plot(snf.Pelecan_08)
dev.off()

snf.ls_08 <- list()
snf.ls_08[[1]] <- snf.Pelecan_08
for (idx in c(2:9)){
  snf.ls_08[[idx]] <- Sncf(x=virus_08_13$lon,y=virus_08_13$lat,z=virus.m_08,
                        w=birds.m.ls_08[[1]],na.rm=TRUE,latlon = TRUE)
  pdf(file = paste0('snf_08_13/snf08_virus_',birds.names[idx],'.pdf'))
  plot(snf.ls_08[[idx]])
  dev.off()
}
save(snf.ls_08,file='snf_08_13/snf_08_13.RData')
# 14-18
virus.m_14 <- as.matrix(virus_14_18 %>% select(-lat,-lon))
virus.m_14[is.na(virus.m_14)]<-0
birds.m.ls_14 <- list()
for(idx in c(1:9)){
  birds.m <- as.matrix(birds.dfs_14_18[[idx]] %>% select(-lat,-lon))
  birds.m[is.na(birds.m)]<-0
  birds.m.ls_14[[idx]] <- birds.m
}
# cross-correlation
snf.Pelecan_14 <- Sncf(x=virus_14_18$lon,y=virus_14_18$lat,z=virus.m_14,
                       w=birds.m.ls_14[[1]],na.rm=TRUE,latlon = TRUE)
pdf(file='snf_14_18/snf_virus_Pelecans.pdf')
plot(snf.Pelecan_14)
dev.off()

snf.ls_14 <- list()
snf.ls_14[[1]] <- snf.Pelecan_14
for (idx in c(2:9)){
  snf.ls_14[[idx]] <- Sncf(x=virus_14_18$lon,y=virus_14_18$lat,z=virus.m_14,
                           w=birds.m.ls_14[[1]],na.rm=TRUE,latlon = TRUE)
  pdf(file = paste0('snf_14_18/snf14_virus_',birds.names[idx],'.pdf'))
  plot(snf.ls_14[[idx]])
  dev.off()
}
save(snf.ls_14,file='snf_14_18/snf_14_18.RData')

## regional sncf
virus_wide_order <- virus_wide %>%
  arrange(lat,lon)

china <- virus_wide %>%
  filter(lat>18 & lat<53 & lon>73 & lon<135)
for(i in 1:length(birds.m.ls)){
  birds.m.ls[[i]] <- birds.dfs[[i]] %>%
    filter(lat>18 & lat<53 & lon>73 & lon<135) %>%
    select(-lat,-lon)
}

snf.ls.china<-list()
snf.china.Pelecan <- Sncf(x=china$lon,y=china$lat,z= china %>% select(-lat,-lon),
                       w=birds.m.ls[[1]],na.rm=TRUE,latlon = TRUE)
pdf(file='snf_china/snf_virus_Pelecans.pdf')
plot(snf.china.Pelecan)
dev.off()

for (idx in c(2:9)){
  snf.ls.china[[idx]] <- Sncf(x=china$lon,y=china$lat,z= china %>% select(-lat,-lon),
     w=birds.m.ls[[idx]],na.rm=TRUE,latlon=TRUE)
  pdf(file = paste0('snf_china/snf_virus_',birds.names[idx],'.pdf'))
  plot(snf.ls_14[[idx]])
  dev.off()
}
save(snf.ls_14,file='snf_china/snf_china.RData')

