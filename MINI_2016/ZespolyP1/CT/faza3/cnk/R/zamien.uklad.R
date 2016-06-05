#' Funkcja zamienia układ współrzędnych.
#' 
#' Zamienia wspX i wspY z układu współrzędnych odpowiającego obrazkowi 
#' o rozmiarach rozmiarX x roazmiarY na układ wykresu R o danym parametrze usr 
#' zwracanym przez funkcję par.
#'
#' @param wspX Współrzędne x punktów na mapie eksponatów.
#' @param wspY Współrzędne y punktów na mapie eksponatów.
#' @param rozmiarX Szerokość obrazu z pikselach.
#' @param rozmiarY Wysokość obrazu w pikselach.
#' @param usr Parametr usr zwracany przez funkcję par().
#' @return list Lista zawierająca nowy ukłąd współrzędnych (współrzędne x i y).
#'

zamien.uklad <- function(wspX, wspY, rozmiarX, rozmiarY, usr) {
  list(wspX / rozmiarX * (usr[2] - usr[1]) + usr[1],
       wspY / rozmiarY * (usr[3] - usr[4]) + usr[4])
}