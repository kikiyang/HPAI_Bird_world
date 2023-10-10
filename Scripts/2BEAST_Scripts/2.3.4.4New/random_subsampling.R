library(dplyr)
setwd('/Users/qiqiy/Documents/P2_WAI/manuscript/Submission/Revision')
sq <- read.csv('Sequence_name_loc.csv')

sq_af <- sq %>%
  filter(Location=='Africa') %>%
  sample_n(262)

sq_eu <- sq %>%
  filter(Location=="Europe") %>%
  sample_n(262)

sq_jp <- sq %>%
  filter(Location=="JapanKorea") %>%
  sample_n(262)

sq_us <- sq %>%
  filter(Location=="USAandCanada") %>%
  sample_n(262)

write.csv(sq_us,file="usaCanada_randsub.csv")
write.csv(sq_jp,file="JapanKorea_randsub.csv")
write.csv(sq_eu,file="Europe_randsub.csv")
write.csv(sq_af,file="Africa_randsub.csv")
