#' Funkcja wypisuje okresy czasowe dla ktorych wzmaga sie czestotliwosc
#' wystepowania slow ze slownika we wpsiach dla bankow
#'
#' @description
#' Funkcja porownaj_wpisy() dla zadanego przedzialu czasowego analizuje czestotliwosci
#' wystepowania slow ze slownika we wpsiach dla bankow i w przypadku sie jej zwiekszenia
#' wypisuje przedzial czasowy w ktorym sie to znajduje oraz "podejrzane" slowa
#'
#' @param data_start Poczatek rozpatrywanego okresu
#' @param data_koniec Koniec rozpatrywanego okresu
#' @param podzial liczba dni w analizowanym okresie
#' @export

porownaj_wpisy <- function (data_start='2013-08-01',data_koniec='2014-01-01',podzial=10) {
  stopifnot(!is.na(data_start), !is.na(data_koniec), !is.na(podzial),
            is.numeric(podzial), podzial == as.integer(podzial), podzial > 0,
            length(data_start) == 1, length(data_koniec) == 1, length(podzial) == 1,
            !is.null(data_start), !is.null(data_koniec), !is.null(podzial),
            as.Date(data_start) <= as.Date(data_koniec),
            as.Date(data_start) + podzial <= as.Date(data_koniec))
  #wczytujemy nasz slownik dla sprecyzowanej awarii - nie moze byc zbyt duzy, aby nie wychwytywac innych szumow

  flaga <- 1
  #podziel odcinek czasowy
  wektor_dni <- seq( as.Date(data_start),as.Date(data_koniec), by = stringi::stri_paste(podzial," days"))
  for (i in (2:length(wektor_dni))) {
    #cat(stringi::stri_paste(as.Date(wektor_dni[i-1])," ",as.Date(wektor_dni[i])),"\n")
    #oblicz czestotliwosci dla bankow
    dane_BZ <- czestotliwosc_bank("BZWBK", as.Date(wektor_dni[i-1]),as.Date(wektor_dni[i]))
    dane_ALIOR <- czestotliwosc_bank("ALIOR", as.Date(wektor_dni[i-1]),as.Date(wektor_dni[i]))
    dane_ING <- czestotliwosc_bank("ING", as.Date(wektor_dni[i-1]),as.Date(wektor_dni[i]))

    #czy wyrazy ze slownika wystepuja w czlowoce naszych czestotliwosci
    porownania=numeric(7)
    for (j in 1:7) {
      porownania[j]= porownania[j] + (awarie[j] %in% names(dane_BZ)[1:20]) +
        (awarie[j] %in% names(dane_ALIOR)[1:20])  + (awarie[j] %in% names(dane_ING)[1:20])
    }
    #sprawdz czy co najmniej 3 wyrazy ze slownika wystepuja w postach co najmniej 2 banków z osobna
    #jesli tak to wystepuja podejrzane posty zwiazane z tymi slowami na tym przedziale czasowym
    if (sum(porownania>=2)>=3) {
      cat("Warto przeanalizowac wpisy z przedzialu: ",stringi::stri_paste(as.Date(wektor_dni[i-1])," -> ",as.Date(wektor_dni[i])),"\n")
      cat("Zwrócić uwagę na wpisy zawierające słowa: ",awarie[porownania>=2],"\n")
      flaga <- 0
    }
  }
  if (flaga == 1) {
    cat("Brak podejrzanych postów dla wybranego okresu czasu na zadanym podziale")
  }
  return (invisible(NULL))
}
