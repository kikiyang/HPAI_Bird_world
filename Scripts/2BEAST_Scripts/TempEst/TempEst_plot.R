data<-read.table('TempEst_2.3.4.4New.txt',header = TRUE)
tiff(file = "tempest_2.3.4.4New.tiff", res = 300, 
     width = 1200, height = 1200, compression = "lzw")

par(lwd=2) 

plot(data[,2],data[,3],ylab="root-to-tip distance",xlab="time",
     pch=16,col="grey",cex.lab=1.3,cex.axis=1)
abline(lm(data[,3]~data[,2]),lwd=2) 

dev.off()
getwd()



