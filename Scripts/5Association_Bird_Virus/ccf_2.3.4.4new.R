library(astsa)
library(dplyr)
library(tidyr)
# setwd('/Users/qiqiy/Documents/P2_WAI/2022/code')
setwd('/Users/qiqiy/Documents/P2_WAI/manuscript/HPAI_Bird_world/Scripts/4Markov_jump/')
## virus lineage migration between a location pair
od_month_migtimes <- read.csv('virus_od_month_migtimes_bf3_2.3.4.4New.csv')
## earliest lineage migration
#od_month_migtimes <- read.csv('../data/virus_od_month_migtimes_min_bf3.csv')

locpairs <- unique(od_month_migtimes$od)
migtimes <- list()
timeseries <- list()
for (i in 1:length(locpairs)){
  tmp <- od_month_migtimes %>%
    filter(od==locpairs[i])
  timeseries[[i]] <- unname(as.numeric(tmp$counts))
  migtimes[[i]] <- tmp
}

virus_mig <- as.data.frame(cbind(locpairs,timeseries))
virus_mig <- virus_mig %>%
  tidyr::separate(col=locpairs,sep='-',into=c('ori','dest'))
rm(tmp,migtimes)

## bird distribution at two locations
birds <- read.csv('../3Bird_month_dist/Location_Bird_Prob/output/2.3.4.4New_bird.csv')
birdorders <- c('Pelecaniformes','Gruiformes','Passeriformes','Suliformes', 
                'Ciconiiformes', 'Falconiformes','Charadriiformes', 
                'Anseriformes', 'Accipitriformes')
birddis <- list()
for (k in 1:length(birdorders)){
  b_tmp <- birds %>%
    select(starts_with(birdorders[k]) | 'Location')
  birddis[[k]] <- b_tmp
}

locs <- unique(birds$Location)
bird_loc_dis <- data.frame(loc=NULL,birdorder=NULL,disprob=NULL)
disprob <- list()
for (k in 1:length(birdorders)){
  for (l in 1:length(locs)){
    
    dis_vec <- unname(as.numeric(birddis[[k]] %>%
     filter(Location==locs[l]) %>% 
      select(-Location)))
    disprob[[length(locs)*(k-1)+l]] <- dis_vec
    
    dis_tmp <- data.frame(birdorder=birdorders[k],loc=locs[l])
                         
    bird_loc_dis <- rbind(bird_loc_dis,dis_tmp)
  }
}

bird_loc_dis2 <- as.data.frame(cbind(c(bird_loc_dis$loc),
                                     c(bird_loc_dis$birdorder),disprob))
bird_loc_dis2 <- rename(bird_loc_dis2, loc=V1, birdorder=V2)
bird_loc_dis2$loc <- as.character(bird_loc_dis2$loc)
rm(b_tmp,dis_tmp,bird_loc_dis,dis_vec,birddis,i,k,l,birds,od_month_migtimes)

## CCF for virus lineage migration between a location pair and 
## the bird distribution at the two locations
ccf_ori <- left_join(virus_mig,bird_loc_dis2,by=c("ori"="loc"),multiple='all')
ccf_dest <- left_join(virus_mig,bird_loc_dis2,by=c("dest" = "loc"),multiple='all')
ccf_ori <- rename(ccf_ori,disprob_ori=disprob)
ccf_dest <- rename(ccf_dest,disprob_dest=disprob)

ccf <- inner_join(ccf_ori,ccf_dest,by=c("ori","dest","birdorder"))
ccf <- ccf %>%
  select(-timeseries.y) %>%
  rename(virus.ts=timeseries.x)

ccfvalue.ori <- list()
ccfvalue.dest <- list()
ccfvalue.bird <- list()
ccfP.ori <- list()
ccfP.dest <- list()
ccfP.bird <- list()
for (i in 1:nrow(ccf)){
  ccf.ori.tmp<-ccf(unlist(ts(ccf[i,'disprob_ori'])),
                   unlist(ts(ccf[i,'virus.ts'])),plot=FALSE)
  
  # print(upperCI)
  # if(any(ccf.ori.tmp$acf>upperCI | ccf.ori.tmp$acf<lowerCI)){
    ccfvalue.ori[[i]] <- as.numeric(ccf.ori.tmp$acf)
    # ccf[i,'upperCI.ori'] <- upperCI
    # ccf[i,'lowerCI.ori'] <- lowerCI
    ccfP.ori[[i]] <- as.numeric(2 * (1 - pnorm(abs(ccf.ori.tmp$acf), 
                                               mean = 0, 
                                               sd = 1/sqrt(ccf.ori.tmp$n.used))))
  # }
  
  ccf.dest.tmp<-ccf(unlist(ts(ccf[i,'disprob_dest'])),
                    unlist(ts(ccf[i,'virus.ts'])),plot=FALSE)
  # upperCI <- qnorm((1 + 0.95)/2)/sqrt(ccf.dest.tmp$n.used)
  # lowerCI <- -qnorm((1 + 0.95)/2)/sqrt(ccf.dest.tmp$n.used)
  # print(upperCI)
  # if(any(ccf.dest.tmp$acf>upperCI | ccf.dest.tmp$acf<lowerCI)){
    ccfvalue.dest[[i]] <- as.numeric(ccf.dest.tmp$acf)
    # ccf[i,'upperCI.dest'] <- upperCI
    # ccf[i,'lowerCI.dest'] <- lowerCI
    ccfP.dest[[i]] <- as.numeric(2 * (1 - pnorm(abs(ccf.dest.tmp$acf), 
                                               mean = 0, 
                                               sd = 1/sqrt(ccf.dest.tmp$n.used))))
  # }
  
  ccf.bird.tmp <- ccf(unlist(ts(ccf[i,'disprob_ori'])),
                    unlist(ts(ccf[i,'disprob_dest'])),plot=FALSE)
  # upperCI <- qnorm((1 + 0.95)/2)/sqrt(ccf.bird.tmp$n.used)
  # lowerCI <- -qnorm((1 + 0.95)/2)/sqrt(ccf.bird.tmp$n.used)
  # print(upperCI)
  # if(any(ccf.bird.tmp$acf>upperCI | ccf.bird.tmp$acf<lowerCI)){
    ccfvalue.bird[[i]] <- as.numeric(ccf.bird.tmp$acf)
    # ccf[i,'upperCI.bird'] <- upperCI
    # ccf[i,'lowerCI.bird'] <- lowerCI
    ccfP.bird[[i]] <- as.numeric(2 * (1 - pnorm(abs(ccf.bird.tmp$acf), 
                                                mean = 0, 
                                                sd = 1/sqrt(ccf.bird.tmp$n.used))))
  # }
}

ccfvalue <- as.data.frame(cbind(ccfvalue.ori,ccfP.ori,ccfvalue.dest,ccfP.dest,
                                ccfvalue.bird,ccfP.bird))
ccf2 <- cbind(ccf,ccfvalue)

## check the significance of cross correlation
upperCI <- qnorm((1 + 0.95)/2)/sqrt(ccf.ori.tmp$n.used)
lowerCI <- -qnorm((1 + 0.95)/2)/sqrt(ccf.ori.tmp$n.used)

obN <- 12
lagN <- c(-7:7)
sig <- 2*sqrt(obN)/sqrt(obN-abs(lagN))

sigdt.ori <- list()
sigdt.dest <- list()
sigdt.bird <- list()
for (i in 1:nrow(ccf2)){
  # sigdt.ori[[i]] <- abs(as.numeric(unlist(ccf2[i,]$ccfvalue.ori))) - sig
  # sigdt.dest[[i]] <- abs(as.numeric(unlist(ccf2[i,]$ccfvalue.dest))) - sig
  # sigdt.bird[[i]] <- abs(as.numeric(unlist(ccf2[i,]$ccfvalue.bird))) - sig
  sigdt.ori[[i]] <- abs(as.numeric(unlist(ccf2[i,]$ccfvalue.ori))) - upperCI
  sigdt.dest[[i]] <- abs(as.numeric(unlist(ccf2[i,]$ccfvalue.dest))) - upperCI
  sigdt.bird[[i]] <- abs(as.numeric(unlist(ccf2[i,]$ccfvalue.bird))) - upperCI
}

## filter out the significantly correlated
## https://support.minitab.com/en-us/minitab/21/help-and-how-to/statistical-modeling/time-series/supporting-topics/basics/guidelines-for-testing-the-autocorrelation-or-cross-correlation/
## time series (origin location - destination location - month lag - bird order)
sigdt <- as.data.frame(cbind(sigdt.ori,sigdt.dest,sigdt.bird))
ccf3 <- cbind(ccf2,sigdt)

filtered <- list()
for (i in 1:nrow(ccf3)){
  metadata <- ccf3 %>%
    select(birdorder,ori,dest)
  metadata$birdorder <- unlist(metadata$birdorder)
  
  filtered[[i]] <- as.list(metadata[i,],ccf.ori,ori.p,ccf.dest,dest.p,ccf.bird,
                           bird.p)
  
  ccf.ori <- unlist(ccf3[i,'ccfvalue.ori'])[which(as.logical(unlist(ccf3[i,'sigdt.ori'])>0))]
  names(ccf.ori) <- lagN[which(as.logical(unlist(ccf3[i,'sigdt.ori'])>0))]
  filtered[[i]]$ccf.ori <- ccf.ori
  filtered[[i]]$ori.p <- unlist(ccf3[i,'ccfP.ori'])[which(as.logical(unlist(ccf3[i,'sigdt.ori'])>0))]
  
  ccf.dest <- unlist(ccf3[i,'ccfvalue.dest'])[which(as.logical(unlist(ccf3[i,'sigdt.dest'])>0))]
  names(ccf.dest) <- lagN[which(as.logical(unlist(ccf3[i,'sigdt.dest'])>0))]
  filtered[[i]]$ccf.dest <- ccf.dest
  filtered[[i]]$dest.p <- unlist(ccf3[i,'ccfP.dest'])[which(as.logical(unlist(ccf3[i,'sigdt.dest'])>0))]
  
  ccf.bird <- unlist(ccf3[i,'ccfvalue.bird'])[which(as.logical(unlist(ccf3[i,'sigdt.bird'])>0))]
  names(ccf.bird) <- lagN[which(as.logical(unlist(ccf3[i,'sigdt.bird'])>0))]
  filtered[[i]]$ccf.bird <- ccf.bird
  filtered[[i]]$bird.p <- unlist(ccf3[i,'ccfP.bird'])[which(as.logical(unlist(ccf3[i,'sigdt.bird'])>0))]
  
}
rm(sigdt.ori,sigdt.dest,sigdt.bird,sigdt,ccf,ccf2,ccf3,metadata)

## Bird pop @origin leads bird pop @destination
## with a negative(breeding<->non-breeding grounds)/
## positive(stopover<->stopover) correlation
bird.df <- data.frame()
for (i in 1:length(filtered)){
  if(length(filtered[[i]]$ccf.bird)!=0){
    for (k in 1:length(filtered[[i]]$ccf.bird)){
      df_tmp <- data.frame(birdorder=filtered[[i]]$birdorder,
                           ori=filtered[[i]]$ori,
                           dest=filtered[[i]]$dest,
                           lag=as.numeric(names(filtered[[i]]$ccf.bird)[k]),
                           corr=filtered[[i]]$ccf.bird[k],
                           p=filtered[[i]]$bird.p[k])
      if(df_tmp$lag<0 | df_tmp$lag==0){
        bird.df <- bird.df %>%
          rbind(df_tmp)
      }
    }
  }
}

## Bird pop @origin leads virus lineage movement from origin to destination
## with a positive correlation
ori.df <- data.frame()
for (i in 1:length(filtered)){
  if(length(filtered[[i]]$ccf.ori)!=0){
    for (k in 1:length(filtered[[i]]$ccf.ori)){
      df_tmp <- data.frame(birdorder=filtered[[i]]$birdorder,
                           ori=filtered[[i]]$ori,
                           dest=filtered[[i]]$dest,
                           lag=as.numeric(names(filtered[[i]]$ccf.ori)[k]),
                           corr=filtered[[i]]$ccf.ori[k],
                           p=filtered[[i]]$ori.p[k])
      if(!df_tmp$lag>0){
        ori.df <- ori.df %>%
          rbind(df_tmp)
      }
    }
  }
}

## Bird pop @destination lags virus lineage movement from origin to destination
## with a positive correlation
dest.df <- data.frame()
for (i in 1:length(filtered)){
  if(length(filtered[[i]]$ccf.dest)!=0){
    for (k in 1:length(filtered[[i]]$ccf.dest)){
      df_tmp <- data.frame(birdorder=filtered[[i]]$birdorder,
                           ori=filtered[[i]]$ori,
                           dest=filtered[[i]]$dest,
                           lag=as.numeric(names(filtered[[i]]$ccf.dest)[k]),
                           corr=filtered[[i]]$ccf.dest[k],
                           p=filtered[[i]]$dest.p[k])
      if(!df_tmp$lag<0 &df_tmp$corr>0){
        dest.df <- dest.df %>%
          rbind(df_tmp)
      }
    }
  }
}

write.csv(ori.df %>% filter(p<0.05/9),'../5Association_Bird_Virus/ori.df.multiCom_2.3.4.4New.csv')
write.csv(dest.df %>% filter(p<0.05/9),'../5Association_Bird_Virus/dest.df.multiCom_2.3.4.4New.csv')

## CCF plots for examining if the time series is stationary
# library(ggplot2)
# acfplots.bird <- list()
# for (i in 1:nrow(ccf2)){
#   v_tmp <- ccf2[i,'ccfvalue.bird'][[1]]
#   names(v_tmp) <- c(-7:7)
#   df_tmp <- data.frame(lag=names(v_tmp),acf=v_tmp,
#                        birdorder=ccf2[i,'birdorder'][[1]],
#                        ori=ccf2[i,'ori'][[1]],dest=ccf2[i,'dest'][[1]])
#   acfplots.bird[[i]] <- ggplot(df_tmp,aes(x = lag, y=acf)) +
#     geom_hline(aes(yintercept = 0)) +
#     geom_segment(mapping = aes(xend = lag, yend = 0)) +
#     labs(title=df_tmp[1,'birdorder'],x='Month lag',y='ACF')
# }
# 
# for(bird in 1:length(birdorders)){
#   ls_tmp <- acfplots.bird[c((9*bird-8):(9*bird))]
#   plot_tmp <- gridExtra::arrangeGrob(grobs=ls_tmp,nrow=3,ncol=3)
#   # setwd('../output/ccf_bird_ori_dest/')
#   ggsave(plot=plot_tmp,
#          filename=paste0(ls_tmp[[1]]$data$ori[1],"_",
#                          ls_tmp[[1]]$data$dest[1],".png"),
#          width = 7.5)
#   dev.off()
# }
# 
# acfplots.ori <- list()
# for (i in 1:nrow(ccf2)){
#   v_tmp <- ccf2[i,'ccfvalue.ori'][[1]]
#   names(v_tmp) <- c(-7:7)
#   df_tmp <- data.frame(lag=names(v_tmp),acf=v_tmp,
#                        birdorder=ccf2[i,'birdorder'][[1]],
#                        ori=ccf2[i,'ori'][[1]],dest=ccf2[i,'dest'][[1]])
#   acfplots.ori[[i]] <- ggplot(df_tmp,aes(x = lag, y=acf)) +
#     geom_hline(aes(yintercept = 0)) +
#     geom_segment(mapping = aes(xend = lag, yend = 0)) +
#     labs(title=df_tmp[1,'birdorder'],x='Month lag',y='ACF')
# }
# for(bird in 1:length(birdorders)){
#   ls_tmp <- acfplots.ori[c((9*bird-8):(9*bird))]
#   plot_tmp <- gridExtra::arrangeGrob(grobs=ls_tmp,nrow=3,ncol=3)
#   setwd('../ccf_birdori_virusmig/')
#   ggsave(plot=plot_tmp,
#          filename=paste0(ls_tmp[[1]]$data$ori[1],"_",
#                          ls_tmp[[1]]$data$dest[1],".png"),
#          width = 7.5)
#   dev.off()
# }
# 
# 
# acfplots.dest <- list()
# for (i in 1:nrow(ccf2)){
#   v_tmp <- ccf2[i,'ccfvalue.dest'][[1]]
#   names(v_tmp) <- c(-7:7)
#   df_tmp <- data.frame(lag=names(v_tmp),acf=v_tmp,
#                        birdorder=ccf2[i,'birdorder'][[1]],
#                        ori=ccf2[i,'ori'][[1]],dest=ccf2[i,'dest'][[1]])
#   acfplots.dest[[i]] <- ggplot(df_tmp,aes(x = lag, y=acf)) +
#     geom_hline(aes(yintercept = 0)) +
#     geom_segment(mapping = aes(xend = lag, yend = 0)) +
#     labs(title=df_tmp[1,'birdorder'],x='Month lag',y='ACF')
# }
# 
# for(bird in 1:length(birdorders)){
#   ls_tmp <- acfplots.dest[c((9*bird-8):(9*bird))]
#   plot_tmp <- gridExtra::arrangeGrob(grobs=ls_tmp,nrow=3,ncol=3)
#   setwd('../ccf_birddest_virusmig/')
#   ggsave(plot=plot_tmp,
#          filename=paste0(ls_tmp[[1]]$data$ori[1],"_",
#                          ls_tmp[[1]]$data$dest[1],".png"),
#          width = 7.5)
#   dev.off()
# }
