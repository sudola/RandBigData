#' Funkcja wczytuje dane z logów.
#'
#' Wczytuje dane z logów cnk i zapisuje je do bazy danych RSQLite.
#' 
#' @param sciezka Ścieżka do pliku z logami cnk.
#' @param baza Baza, do której będą zapisywane dane.
#' @return NULL
#' @export
#'

wczytaj.dane <- function(sciezka, baza) {

    time <- as.POSIXct(Sys.time())
    setwd(sciezka)

    pliki <- wczytaj.nazwy.plikow(sciezka)

    czytaj.logi(pliki, baza)

    print(as.POSIXct(Sys.time()) - time)
    invisible()
}
