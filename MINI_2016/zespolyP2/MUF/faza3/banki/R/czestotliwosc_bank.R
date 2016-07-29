#' Funkcja wyznacza srednia czestotliwosc rzeczownikow wybranego banku
#'
#' @description
#' Funkcja czestotliwosc_bank() wyznacza srednia czestotliwosc rzeczownikow w formie podstawoej
#' wystepujacych we wpisach dla zadanego banku i przedzialu czasowego
#'
#' @param nazwa_banku Nazwa banku, obecnie do wyboru "ALIOR", "ING", "BZWBK"
#' @param data_start Poczatek rozpatrywanego okresu
#' @param data_koniec Koniec rozpatrywanego okresu
#' @return wektor named_num czestotliwosci danego slowa
#' @export

czestotliwosc_bank <- function (nazwa_banku, data_start="2013-09-01", data_koniec="2014-01-01") {
  stopifnot(!is.na(nazwa_banku), !is.na(data_start), !is.na(data_koniec),
            is.character(nazwa_banku),
            length(nazwa_banku) == 1, length(data_start) == 1, length(data_koniec) == 1,
            !is.null(nazwa_banku), !is.null(data_start), !is.null(data_koniec),
            as.Date(data_start) <= as.Date(data_koniec))

  nazwa_banku <- toupper(nazwa_banku)

  #obciecie do zadanego przedzialu czasowego
  daty <- eval(as.name(stringi::stri_paste("daty_",nazwa_banku)))
  nowe_daty <- daty[daty>=data_start & daty<=data_koniec]

  nouns <- eval(as.name(stringi::stri_paste("nouns_", nazwa_banku)))
  wszystkie_rzecz <- nouns[daty>=data_start & daty<=data_koniec]

  unikalne <- eval(as.name(stringi::stri_paste("unikalne_",nazwa_banku)))
  unikalne_rzecz <-unikalne[daty>=data_start & daty<=data_koniec]

  #wylicz ile dany rzeczownik wystapil razy we wszystkich postach
  wektor_rzeczownikow <- unlist(wszystkie_rzecz)
  pomocniczy <- numeric(length(wektor_rzeczownikow))+1
  zagregowane <- unlist(lapply(split(pomocniczy,wektor_rzeczownikow), sum))
  zagr_order <- zagregowane[order(zagregowane,decreasing=TRUE)]

  #wylicz w ilu postach istnieje danych rzeczownik
  wektor_rzeczownikow_istniejacych <- unlist( unikalne_rzecz)
  pomocniczy <- numeric(length(wektor_rzeczownikow_istniejacych))+1
  zagregowane_istn <- unlist(lapply(split(pomocniczy,wektor_rzeczownikow_istniejacych), sum))
  zagr_order_istn <- zagregowane_istn[order(zagregowane_istn,decreasing=TRUE)]

  #oblicz czestotliwosci dla rzeczownikow
  ile_razy_na_post <- zagr_order/zagr_order_istn[names(zagr_order)]
  ile_razy_na_post <- ile_razy_na_post[zagr_order_istn[names(zagr_order)]>2]
  ile_razy_order <- ile_razy_na_post[order(ile_razy_na_post,decreasing = TRUE)]
  return ( ile_razy_order )
}
