#' Funkcja wczytuje nazwy plikow cnk.
#' 
#' Wczytuje wczytuje nazwy plików postaci cnk[liczba] znajdujących się
#' w katalogu folder.
#' 
#' @param folder Ścieżka, w której szukamy logów cnk.
#' @return pliki Nazwy plików z logami cnk.
#' @import stringi
#' 

wczytaj.nazwy.plikow <- function(folder) {

    # wczytaj nazwy wszystkich plików
    pliki <- list.files(folder, recursive = TRUE, pattern = "cnk[0-9]+.*\\.log$")

    # wybierz pliki logów
    #pliki <- grep(".+\\.log", pliki, value = TRUE)

    # wybierz pliki o nazwie postaci cnk[liczba].log
    #pliki <- grep("cnk", pliki, value = TRUE, fixed = TRUE)

    pliki
    
    
}