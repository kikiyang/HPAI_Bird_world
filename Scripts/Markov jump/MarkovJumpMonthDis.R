setwd('/Users/qiqiy/Documents/P2_WAI/manuscript/HPAI_Bird_world/Scripts/Correlation_bird_virus_continuous/code')

mj <- read.csv('../data/virus_od_month_migtimes_bf3.csv')

library(dplyr)

mj_yr <- mj %>%
  group_by(od) %>%
  summarise(yr_count=sum(counts))

mj <- mj %>%
  left_join(mj_yr) %>%
  mutate(freq = counts/yr_count)

month_bird_range <- read.table('../data/month_bird_range.txt',
                               header = TRUE)
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
  labs(fill="Bird annual cycle\nphase")

ggsave(filename='MarkovJumpMonthDis_NS.png',width=9)

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
  labs(fill="Bird annual cycle\nphase")

ggsave(filename='MarkovJumpMonthDis_SN.png',width=9)

