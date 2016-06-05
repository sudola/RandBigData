install.packages("eurostat")
library(eurostat)

eur=get_eurostat(id="cens_01rdhh")

debug(get_eurostat)
get_eurostat(id="cens_01rdhh")
undebug(get_eurostat)

#wstrzykujemy
trace(eurostat:::tidy_eurostat, quote(if( time_format!="raw" && length(levels(dat2$time))==1) {  time_format<-"raw" }),at=9 )

get_eurostat(id="cens_01rdhh")
untrace(eurostat:::tidy_eurostat)
