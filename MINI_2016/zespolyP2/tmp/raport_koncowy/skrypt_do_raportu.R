load("dane_ing_rozklad.rda")
load("dane_ing_kor.rda")
load("cdfy_tydzien.rda")
load("cdfy_weekend.rda")
load("final.rda")
load("rama.rda")
library(dplyr)
library(stringi)

if(.Platform$OS.type == "windows") {
  dane_ing_kor$body_korekta <- stri_encode(as.character(dane_ing_kor$body_korekta), from = "utf8", to = "cp1250")
  dane_ing_kor$body <- stri_encode(as.character(dane_ing_kor$body), from = "utf8", to = "cp1250")
  dane_ing_kor$user_name <- stri_encode(as.character(dane_ing_kor$user_name), from = "utf8", to = "cp1250")
  dane_ing_rozklad$podstawa <- stri_encode(as.character(dane_ing_rozklad$podstawa), from = "utf8", to = "cp1250")
}

now <-as.POSIXlt(strptime("2015-07-27 17:00:01", "%Y-%m-%d %H:%M:%S"))

weekday <- now$wday

### selekcja czasów

time_begin <- now - as.difftime(1, unit="days")

final %>% filter(as.POSIXct(data)<= now & as.POSIXct(data) >= time_begin) -> wydzwiek_wczoraj
dane_ing_kor %>% filter(as.POSIXct(created_at)<= now & as.POSIXct(created_at) >= time_begin) -> dane_wczoraj
dane_ing_rozklad %>% filter(as.POSIXct(data)<= now & as.POSIXct(data) >= time_begin) -> rozklady_wczoraj
rozklady_wczoraj %>% count(podstawa) %>% arrange(desc(n))-> licznosci_wczoraj

### sprawdzanie słów

slowa <- c("problem", "działać", "utrudnienie", "reklamacja", "awaria", "błąd")
slowa <- sort(slowa)

if(weekday %in% c(0,6)){
  cdfy <- cdfy_weekend
}else{
  cdfy <- cdfy_tydzien
}
pstwa <- rep(1,6)
for(i in 1:6){
  slowo <- slowa[i]
  wynik <- 1- cdfy[[slowo]](licznosci_wczoraj$n[licznosci_wczoraj$podstawa == slowo])
  if(length(wynik)>0) pstwa[i] <- wynik
}

dzien <- stri_sub(now, 1, 10)
nazwa_pliku <- stri_replace_all_fixed(as.character(now),pattern = c(":"), replacement = "_")

rmarkdown::render("raport_faza3.Rmd", encoding = "utf8", output_file = paste0("raport", nazwa_pliku, ".pdf"))

