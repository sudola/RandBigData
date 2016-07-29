#' Funkcja generuje ścieżkę odwiedzanych eksponatów cnk.
#' 
#' Generuje ścieżkę odwiedzanych eksponatów cnk na podstawie macierzy przejścia
#'  w kolejnych krokach.
#' 
#' @param first Numer id pierwszego eksponatu w ścieżce.
#' @param l Pożądana długość generowanej ścieżki.
#' @param mat Macierz prawdopodobieństw przejścia
#' @return sciezka Ścieżka dlugości "l" od eksponatu "first".
#' @export
#'

generuj.sciezke <- function(first, l, mat){
  sciezka <- vector("numeric", l)
  names(first) <- first
  
  for(i in 1:l){
    sciezka[i] <- first
    mat[, names(first)] <- -1
    first <- names(which.max(mat[first, ]))
    names(first) <- first
  }
  
  sciezka
}