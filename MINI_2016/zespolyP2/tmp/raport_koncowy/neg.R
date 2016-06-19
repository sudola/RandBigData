negatywne=read.table("https://raw.githubusercontent.com/MarcinKosinski/web-scraping/master/Analizy/Sentyment/negatywne.txt")

neg=as.vector(unlist(neg))

pozytywne=read.table("https://raw.githubusercontent.com/MarcinKosinski/web-scraping/master/Analizy/Sentyment/pozytywne.txt")

poz=as.vector(unlist(pozytywne))

czy_poz=ifelse(dane_ing_rozklad$podstawa %in% poz,1,0)
head(dane_neg)

dane=cbind(dane_neg,czy_poz)


dane %>% 
	select(id,data,czy_neg,czy_poz) %>%	
	group_by(id,data) %>% 
	summarise(ile_neg= sum(czy_neg),ile_poz= sum(czy_poz),ile_slow=n()) -> ile_dane


head(ile_dane)

czy_n=(ile_dane$ile_neg/ile_dane$ile_slow>0.1)
czy_p=(ile_dane$ile_poz/ile_dane$ile_slow>0.1)


razem=cbind(ile_dane,czy_n,czy_p)
head(razem)

jakie=rep("0",nrow(razem))
for(i in 1:nrow(razem))
{
	jakie[i]=ifelse(razem$czy_n[i]==1,"neg",ifelse(razem$czy_p[i]==1,"poz","neut"))
}



final=cbind(razem,jakie)
head(final)
final=final[,c(1,2,8)]
head(final)
save(final,file = "final")





#############################
dzien=stri_extract_first_regex(ile_neg$data,pattern = ".*(?= )")
head(dzien)
head(ile_neg)

ile_neg_new=cbind(ile_neg,dzien)

head(ile_neg_new)


czy_neg=(ile_neg_new$ile_neg/ile_neg_new$ile_slow>0.1)


ram=cbind(ile_neg_new,czy_neg)

head(ram)


ram %>% 
	select(dzien,czy_neg) %>%	
	group_by(dzien) %>% 
	summarise(ile_neg= sum(czy_neg),ile_post=n()) -> rank_dni

head(rank_dni[order(rank_dni$ile_neg,decreasing = TRUE),])

sum(rank_dni$ile_neg/rank_dni$ile_post>0.999)

setwd("C:\\Users\\Rafał\\Desktop\\II projekt")
save(rank_dni,file="rank_dni")


head(ile_neg[order(ile_neg$ile_neg,decreasing = TRUE),])

czy_neg=ifelse(dane_ing_rozklad$podstawa %in% neg,1,0)

dane_neg=cbind(dane_ing_rozklad,czy_neg)

head(dane_neg)

head(czy_neg)
head(dane_ing_rozklad$podstawa)

sum(czy_neg)
head(negatywne)
neg=as.vector(negatywne)
negatywne[1,]
"zaburzenia" %in% neg
neg=as.vector(unlist(neg))
head(neg)
