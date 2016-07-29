#' Funkja wczytuje nazwę eksponatu, rok i miesiąc ze ścieżki do pliku.
#' 
#' Wczytuje nazwę eksponatu, rok i miesiąc ze ścieżki do pliku cnk.
#' 
#' @param plik Scieżka do pliku z logiem cnk.
#' @return list Lista zawierająca nazwę eksponatu, rok i miesiąc użycia.
#' 

dane.ze.sciezki <- function(plik) {

    eksponat <- strsplit(basename(plik), "\\.")[[1]][1]

    # TODO: sprawdzić czy to działa na Windowsie
    podzielona.sciezka <- strsplit(plik, "/")[[1]]
    len <- length(podzielona.sciezka)

    rok     <- as.numeric(podzielona.sciezka[len - 3])
    miesiac <- as.numeric(podzielona.sciezka[len - 2])

    list(eksponat = eksponat, rok = rok, miesiac = miesiac)
}