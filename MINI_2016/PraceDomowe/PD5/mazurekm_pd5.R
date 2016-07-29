
library(eurostat)
trace(eurostat:::tidy_eurostat, quote( if(length(unique(dat2$time))==1) time_format<-"raw" ),at=9 )
cens_01rdhh<-get_eurostat(id="cens_01rdhh")
untrace(eurostat:::tidy_eurostat)