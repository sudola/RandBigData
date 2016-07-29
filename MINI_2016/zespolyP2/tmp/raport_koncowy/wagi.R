load("dane_ing_rozklad.rda")
load("slownik_wydzwieku.rda")

library(stringi)
library(dplyr)
library(rvest)

load("ramka.rda")

#####################################################################################
ramka %>% 
	select(id,data,waga,podstawa) %>% 
	group_by(id,data) %>% 
	summarise(ocena_sum=sum(waga),ilosc_slow= n()) -> rameczka

ramka %>%	
	select(id,data,podstawa,waga) %>% 
  summarise(czy_zero=count(waga==0))-> nowa_ramka

czy_zero=ifelse(ramka$waga==0,1,0)
nowa_ramka=cbind(ramka,czy_zero)

nowa_ramka %>%
	select(id,data,czy_zero) %>%
	group_by(id) %>%
	summarise(zer= sum(czy_zero)) -> new


rama <- cbind(rameczka,zer =new$zer)
zera <- numeric(nrow(rameczka))
rozne$id <-as.vector(rozne$id)
rozne$rozne <- as.vector(rozne$rozne)
rameczka$id <- as.vector(rameczka$id)
for(i in 1:nrow(rameczka))
{

	if((rameczka[i,1] %in% rozne$id)==T)
     zera[i]=as.vector(rozne[rozne$id==as.numeric(rameczka[i,1]),2])
	else 
		zera[i]==0
}
ram <- cbind(rameczka, as.vector(zera))

ramka_ranking %>% 
	group_by(id,data,ocena_sum,ocena_sr,ocena_med)%>%
	summarise(dzien=stri_extract_first_regex(data,pattern = ".*(?= )")) -> ramka_dni

ramka_dni %>% group_by(dzien)
