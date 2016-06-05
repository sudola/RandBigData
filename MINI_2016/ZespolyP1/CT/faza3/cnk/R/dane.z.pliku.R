#' Wczytywanie danych o interakcjach z pliku.
#'
#' Wczytuje z pliku logów informacje o interakcjach i zwraca je w postaci
#' ramki danych.
#'
#' @param plik Ścieżka do pliku z logami cnk.
#' @return data.frame Ramka zawierająca dzień, godzinę oraz id odwiedzającego.
#' @import stringi


dane.z.pliku <- function(plik) {
    linie <- readLines(plik)

    # wybierz linie odpowiadające poczatkom interakcji
    poczatek <- grep("Added visitor ", linie,  fixed = TRUE, value = TRUE)

    # jeśli nie znaleziono zwróć NULL
    if (length(poczatek) == 0) return(NULL)

    # wydobadz id odwiedzajacych
    wzor <- "(?<=Added visitor )[0-9]+"
    gosc <- as.numeric(stri_extract_first_regex(poczatek, wzor))

    dzien <- as.numeric(substr(poczatek, 5, 6))

    godzina <- substr(poczatek, 8, 15)

    data.frame(dzien = dzien, godzina = godzina, gosc = gosc)

}