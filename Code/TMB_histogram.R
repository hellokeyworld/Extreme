library(MASS)
library(coin)
library(ggplot2)
library(plyr)  
library(reshape2)
library(scales)
library(rstatix)
library(dplyr)



totalTMB<-read.table("Genomic_Data.txt", sep="\t" ,header=T)


##summary
mean(totalTMB$nonsynonymous)
sd(totalTMB$nonsynonymous)
summary(totalTMB$nonsynonymous)
sum(totalTMB$nonsynonymous)
summary(totalTMB$NsBurden)

##histogram
total.mut<-subset(totalTMB,select = c(sample,Response,Subtype,missense,nonsense,start_lost.stop_lost,splice,frameshift,inframe))
total.mut_1<-melt(subset(total.mut, select=-c(Response,Subtype), id.var="sample"))
total.mut_1$R.NR<-rep(total.mut$Response)
total.mut_1$Group<-rep(total.mut$Subtype)
total.mut_1$tumor <- "tumor"

library(RColorBrewer)
f <- function(pal) brewer.pal(brewer.pal.info[pal, "maxcolors"], pal)
(cols <- f("Pastel1"))
s.palette=c("#FBB4AE","#B3CDE3")
p.palette=c("#ABD7D8","#67A9A8", "#2C7379", "#ECD0A0","#BFD1D3" ,"#85a3b1")
c.palette=c("#C02D2F", "#377EB8")


library(gtable)
library("grid")
ggplot(data=total.mut_1,aes(x=sample, y=value, fill=variable)) +
  ggtitle("Non-synonymous Mutation Burden")+
  geom_bar(stat='identity')+ 
  scale_fill_manual(values=p.palette) +
  theme(axis.title=element_blank(), 
        axis.text.x = element_blank(),
        panel.border=element_rect(colour="white",fill=NA,size=0.1), 
        strip.background = element_rect(colour="black", fill=NA),
        axis.ticks.x=element_blank(),
        legend.title=element_blank(),
        legend.key =element_rect(size = 0.8 ,fill=NA),
        legend.text = element_text(size=10), 
        legend.key.height = unit(0.8,"cm"), 
        legend.key.width = unit(0.8,"cm"),
        plot.margin = unit(c(1,0,-1,1), "lines"),
        panel.background=element_rect(fill="white"))
p1 <-ggplotGrob(last_plot())

ggplot(data=total.mut_1,aes(x=sample,y=tumor,fill=R.NR))+geom_tile(colour="white",stat="identity")+
  theme(axis.title=element_blank(), 
        axis.text = element_blank(),
        axis.ticks=element_blank(),
        panel.border=element_rect(colour="white",fill=NA,size=0.1), 
        strip.background = element_rect(colour="black", fill=NA),
        axis.ticks.x=element_blank(),
        legend.key =element_rect(size = 0.1,fill=NA),
        legend.text = element_text(size=5), 
        legend.key.height = unit(0.5,"cm"), 
        legend.key.width = unit(0.5,"cm"),
        legend.title =element_blank(),
        legend.position="right",
        legend.direction="horizontal",
        legend.margin=unit(0.065,"cm"),
        plot.margin = unit(c(0,0,0.2,0), "lines"),
        panel.background=element_blank())+
  coord_fixed(ratio=0.8)+ 
  guides(fill=guide_legend(label.position="bottom",label.hjust =0.2, label.vjust =0.2,
                           label.theme = element_text(angle = 0, size=7)))
p2 <-ggplotGrob(last_plot())


ggplot(data=total.mut_1,aes(x=sample,y=tumor,fill=Group))+geom_tile(colour="white",stat="identity")+
  scale_fill_manual(values= s.palette)+
  theme(axis.title=element_blank(), 
        axis.text.y = element_blank(),
        axis.text.x=element_text(angle = -20,vjust= 0.7,  hjust=0.2, size=7), 
        axis.ticks=element_blank(),
        panel.border=element_rect(colour="white",fill=NA,size=0.1), 
        strip.background = element_rect(colour="black", fill=NA),
        axis.ticks.x=element_blank(),
        legend.key =element_rect(size = 0.1,fill=NA),
        legend.text = element_text(size=5), 
        legend.key.height = unit(0.5,"cm"), 
        legend.key.width = unit(0.5,"cm"),
        legend.title =element_blank(),
        legend.position="right",
        legend.direction="horizontal",
        legend.margin=unit(0.065,"cm"),
        plot.margin = unit(c(0.2,0,0,0), "lines"),
        panel.background=element_blank())+
  coord_fixed(ratio=0.8)+ 
  guides(fill=guide_legend(label.position="bottom",label.hjust =0.2, label.vjust =0.2,
                           label.theme = element_text(angle = 0, size=7)))

p3 <-ggplotGrob(last_plot())

p <- rbind(p1,p2, p3, size="first")
grid.draw(p)
