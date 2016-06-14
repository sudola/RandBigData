#' Funkcja wybiera wpisy zawierajace slowo w zadanym przedziale czasowym
#'
#' @description
#' Funkcja wybierz_wpisy() dla zadanego banku i napisu zwraca wszystkie wpisy
#' w zadanym przedziale czasowym
#'
#' @param nazwa_banku Nazwa banku, obecnie do wyboru "ALIOR", "ING", "BZWBK"
#' @param slowo Slowo ktore ma wystepowac we wpisie
#' @param data_start Poczatek rozpatrywanego okresu
#' @param data_koniec Koniec rozpatrywanego okresu
#' @return wektor named_num czestotliwosci danego slowa
#' @export

wybierz_wpisy <- function(nazwa_banku, slowo, data_start = "2013-09-01", data_koniec="2014-01-01"){
  stopifnot(!is.na(nazwa_banku), !is.na(data_start), !is.na(data_koniec), !is.na(slowo),
            is.character(nazwa_banku), is.character(slowo),
            length(nazwa_banku) == 1, length(data_start) == 1, length(data_koniec) == 1,
            !is.null(nazwa_banku), !is.null(data_start), !is.null(data_koniec), !is.null(slowo),
            as.Date(data_start) <= as.Date(data_koniec))

  nouns <- eval(as.name(stringi::stri_paste("nouns_",nazwa_banku)))
  ile_razy <- sapply(lapply(nouns, "%in%", slowo), sum)
  daty <- eval(as.name(stringi::stri_paste("daty_",nazwa_banku)))

  #ograniczamy sie do zadanego przedzialu czasowego
  ktore_daty_w_przedziale <- which(daty >= data_start & daty <= data_koniec)
  wpisy_w_przedziale <- eval(as.name(stringi::stri_paste("wpisy_",nazwa_banku)))[ktore_daty_w_przedziale, ]
  ile_razy_w_przedziale <- ile_razy[ktore_daty_w_przedziale]

  return(wpisy_w_przedziale[which(ile_razy_w_przedziale != 0), 9])
}
