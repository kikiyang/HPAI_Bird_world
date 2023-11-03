# setwd('/Users/qiqiy/Documents/P2_WAI/manuscript/HPAI_Bird_world/Scripts/Correlation_bird_virus_continuous/code')
setwd('/Users/qiqiy/Documents/P2_WAI/manuscript/HPAI_Bird_world/Scripts/4Markov_jump')
# mj <- read.csv('virus_od_month_migtimes_bf3.csv')
# mj <- read.csv('virus_od_month_migtimes_bf3_2.3.2.1.csv')
mj <- read.csv('virus_od_month_migtimes_bf3_2.3.4.4New.csv')
library(dplyr)
# loc <- read.csv('2.3.4.4f_location.csv')
# loc <- read.csv('2.3.2.1f_location.csv')
loc <- read.csv('2.3.4.4Newf_location.csv')

for(i in 1:nrow(mj)){
  mj[i,'origin'] <- strsplit(mj[i,'od'],'-')[[1]][1]
  mj[i,'dest'] <- strsplit(mj[i,'od'],'-')[[1]][2]
}

# total_trees <- 4501 #2.3.2.1
# total_trees <- 81000 #2.3.4.4
total_trees <- 5631 #2.3.4.4 new

mj <- mj %>%
  inner_join(loc,by=c('origin'='Location'))  %>%
  inner_join(loc,by=c('dest'='Location')) %>%
  mutate(direction=ifelse(lat.x-lat.y<0,'SN','NS'),delta_lat=lat.x-lat.y) %>%
  arrange(delta_lat)
routes <- unique(mj$od)
mj_yr <- mj %>%
  group_by(od) %>%
  summarise(yr_count=sum(counts))

mj <- mj %>%
  left_join(mj_yr) %>%
  mutate(freq = counts/yr_count/total_trees)

month_bird_range <- read.table('month_bird_range.txt',header = TRUE)
library(tidyr)
month_bird_range <- month_bird_range %>%
  pivot_longer(cols=c('NS','SN'),names_to = 'direction',values_to = 'bird_range')
  

mj.color <- mj %>%
  left_join(month_bird_range,by=c("month"="Month","direction"="direction"))
  
library(ggplot2)
ggplot(data=mj.color %>% filter(direction=="NS"),mapping=aes(x=month,y=freq,fill=bird_range))+
  geom_col()+
  scale_x_discrete(limits = c("Jan", "Feb","Mar","Apr","May","Jun","Jul",
                              "Aug","Sep","Oct","Nov","Dec"), 
                   labels=c("Jan", "","Mar","","May",
                            "","Jul","","Sep","","Nov","")) + 
  facet_wrap(~od) +
  scale_fill_manual(values=c('#D99D7A','#EEEA76','#9CBEE2','grey'))+
  geom_hline(yintercept=1/6,linetype='dashed',colour='darkred') +
  ylab('Frequency') +
  labs(fill="Bird annual cycle\nphase")+
  theme_bw()
# ggsave(filename='MarkovJumpMonthDis_NS_2.3.2.1.png',width=9,height=6)
# ggsave(filename='MarkovJumpMonthDis_NS_2.3.4.4New.png',width=11)
ggsave(filename='MarkovJumpMonthDis_NS_2.3.4.4.png')

ggplot(data=mj.color %>% filter(direction=="SN"),mapping=aes(x=month,y=freq,fill=bird_range))+
  geom_col()+
  scale_x_discrete(limits = c("Jan", "Feb","Mar","Apr","May","Jun","Jul",
                              "Aug","Sep","Oct","Nov","Dec"), 
                   labels=c("Jan", "","Mar","","May",
                            "","Jul","","Sep","","Nov","")) + 
  facet_wrap(~od) +
  scale_fill_manual(values=c('#D99D7A','#EEEA76','#9CBEE2','grey'))+
  geom_hline(yintercept=1/6,linetype='dashed',colour='darkred') +
  ylab('Frequency') +
  labs(fill="Bird annual cycle\nphase")+
  theme_bw()
# ggsave(filename='MarkovJumpMonthDis_SN_2.3.2.1.png',width=9,height=6)
# ggsave(filename='MarkovJumpMonthDis_SN_2.3.4.4New.png',width=10)
ggsave(filename='MarkovJumpMonthDis_SN_2.3.4.4.png',width=10)

ggplot(data=mj.color %>% filter(direction=="NS"),mapping=aes(x=month,y=counts/total_trees,fill=bird_range))+
  geom_col()+
  scale_x_discrete(limits = c("Jan", "Feb","Mar","Apr","May","Jun","Jul",
                              "Aug","Sep","Oct","Nov","Dec"), 
                   labels=c("Jan", "","Mar","","May",
                            "","Jul","","Sep","","Nov","")) + 
  facet_wrap(~od) +
  scale_fill_manual(values=c('#D99D7A','#EEEA76','#9CBEE2','grey'))+
  # geom_hline(yintercept=1/6,linetype='dashed',colour='darkred') +
  ylab('Posterior mean of Markov jump counts') +
  xlab('Month') + 
  labs(fill="Bird annual cycle\nphase")+
  theme_bw()
# ggsave(filename='MarkovJumpCountsMonthDis_NS_2.3.2.1.png',width=9,height=6)
ggsave(filename='MarkovJumpCountsMonthDis_NS_2.3.4.4New.png',width=10, height=7)
# ggsave(filename='MarkovJumpCountsMonthDis_NS_2.3.4.4.png',width=8.5,height=5)

ggplot(data=mj.color %>% filter(direction=="SN"),mapping=aes(x=month,y=counts/total_trees,fill=bird_range))+
  geom_col()+
  scale_x_discrete(limits = c("Jan", "Feb","Mar","Apr","May","Jun","Jul",
                              "Aug","Sep","Oct","Nov","Dec"), 
                   labels=c("Jan", "","Mar","","May",
                            "","Jul","","Sep","","Nov","")) + 
  facet_wrap(~od) +
  scale_fill_manual(values=c('#D99D7A','#EEEA76','#9CBEE2','grey'))+
  # geom_hline(yintercept=1/6,linetype='dashed',colour='darkred') +
  ylab('Posterior mean of Markov jump counts') +
  xlab('Month') + 
  labs(fill="Bird annual cycle\nphase")+
  theme_bw()

# ggsave(filename='MarkovJumpCountsMonthDis_SN_2.3.2.1.png',width=9,height=6)
ggsave(filename='MarkovJumpCountsMonthDis_SN_2.3.4.4New.png',width=10, height=6)
# ggsave(filename='MarkovJumpCountsMonthDis_SN_2.3.4.4.png',width=8.5,height=5)

