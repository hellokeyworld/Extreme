library(MASS)
library(coin)
library(ggplot2)
library(plyr)  
library(reshape2)
library(scales)
library(rstatix)
library(dplyr)
setwd("working DIR")

totalTMB<-read.table("Genomic_Data.txt", sep="\t" ,header=T)


##total TMB statistic Test
plot.mw <- function (data,notch=FALSE,omm=FALSE){
  options(scipen=999)
  res <- wilcox.test(data[,1] ~ data[,2],conf.int=TRUE,alt="greater")
  U <- wilcox.test(data[,1] ~ data[,2])$statistic
  print(paste("p-value=",res$p.value))
  samples.size <- count (data[,2]) #requires the plyr package
  PS <- round(U/(samples.size[1,2] * samples.size[2,2]), 3)
  z <- round(wilcox_test(data[,1] ~ data[,2],alt="greater")@statistic@teststatistic,3) #requires the coin package
  r <- round(abs(z/sqrt(samples.size[1,2] + samples.size[2,2])), 3)
  boxplot(data[,1] ~ data[,2], data = data, notch = notch,ann=FALSE)
  stripchart(data[,1] ~ data[,2], vertical = TRUE, data = data, method = "jitter", add = TRUE, pch = 16, col = 'black', cex = 0.85)
  title(main="Jittered BoxPlots", sub=paste("Wilcoxon rank-sum test", "P-value =", round(res$p.value,3)), cex.sub=1.3)
  if (omm==TRUE) {
    abline(h=mean(data[,1]), lty=2, col="red")
    abline(h=median(data[,1]), lty=3, col="blue")
  } else {
  }
}


total_out=lm(nonsynonymous~Response	 ,data=totalTMB) 
shapiro.test(resid(total_out)) ## normality test
var.test(totalTMB$nonsynonymous~totalTMB$Response	)
t.test(totalTMB$nonsynonymous~totalTMB$Response	,alt="greater")
wilcox.test(totalTMB$nonsynonymous~totalTMBResponse	,alt="greater")
M.totalTMB<-totalTMB[,c("nonsynonymous","Response	")]
plot.mw(M.totalTMB)

