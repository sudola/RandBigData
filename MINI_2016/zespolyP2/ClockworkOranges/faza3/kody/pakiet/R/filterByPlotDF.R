#' Funkcja znajdująca jednotematyczne wątki
#' 
#' Funkcja znajduje wątki w których częściej niż f występują słowa na post.
#' 
#' @param dateStart data początku okresu w formacie "yyyy-mm-dd" jako character
#' @param dateStop data końca okresu w formacie "yyyy-mm-dd" jako character
#' @param dane ramka danych z kolumnami: created_at, id, thread_id, rzeczownik
#' @param npost minimalna liczba postów w wątku które są uwzględniane
#' @param freq minimalna częstotliwośc wytstępowania słowa na post
#' 
#' @return zwraca ramek danych wszystkich wybranych słów z ich częstościami
#' @import dplyr
#' @export

filterByPlotDF <- function(dateStart, dateStop, dane, npost=5, freq=0.5){
  okres=dane%>%filter(as.character(dane$created_at)>=dateStart, as.character(dane$created_at)<=dateStop)
  watki=okres%>%select(thread_id, id)%>%distinct(id)%>%group_by(thread_id)%>%summarise(ile=n())
  rzeczowniki=okres%>%select(rzeczownik, thread_id)%>%group_by(rzeczownik, thread_id)%>%summarise(ile_rzecz=n())
  razem=rzeczowniki%>%left_join(watki, by="thread_id")%>%mutate(f=ile_rzecz/ile)%>%ungroup()%>%filter(ile>2)%>%arrange(desc(f))
  wazne=razem%>%filter(ile>=npost, f>=freq)%>%arrange(thread_id, desc(f))
  wazne%>%left_join(okres%>%select(thread_id, created_at)%>%group_by(thread_id)%>%summarise(date=substr(min(as.character(created_at)), 1, 10)),by="thread_id")
}