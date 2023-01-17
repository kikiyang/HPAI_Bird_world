library(readxl)
earliest <- read_excel("Documents/P2_WAI/2022/code/Stats_mj.xlsx", 
                       sheet = "earliest", range = "C1:K5")
avg <- read_excel("Documents/P2_WAI/2022/code/Stats_mj.xlsx", 
                  sheet = "avg", range = "C1:K5")

earliest.m <- as.matrix(earliest)
avg.m <- as.matrix(avg)

dif.m <- avg.m - earliest.m 

dif.df <- as.data.frame(dif.m,row.names=c('SChina-Nchina','Europe-Russia','SChina-SEA',
                                'Europe-Africa'))
