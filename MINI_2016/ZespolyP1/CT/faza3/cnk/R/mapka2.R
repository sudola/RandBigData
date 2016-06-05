#' Funkcja rysuje mapę cnk z zaznaczonymi ścieżkami.
#' 
#' Rysuje mapę cnk z zaznaczonymi ścieżkami dojścia z wybranego eksponatu.
#' 
#' @param wybrany Numer id eksponatu, od którego zaczyna się scieżka.
#' @param sciezka Wektor id eksponatów znajdującyh się na ścieżkę.
#' @param eksponaty Numery id wszystkich eksponatów.
#' @param wspX Współrzędne x eksponatów.
#' @param wspY Współrzędne y eksponatów.
#' @param img Obrazek w postaci obiektu array wczytany funkcją readPNG z pakietu png.
#' @param srodowisko Środowisko, w którym przechowywane są zmienne globalne 
#' dla bieżącej sesji aplikacji.
#' @param usr Parametr usr zwracany przez funkcję par().
#' @return NULL
#' @import shape
#' @export
#' 

mapka2 <- function(wybrany, sciezka, eksponaty, wspX, wspY, img, srodowisko, usr) {
  
  rysuj.mape(img, srodowisko)
  
  nowyUklad <- zamien.uklad(wspX, wspY, 663, 651, usr)
  
  noweX <- nowyUklad[[1]]
  noweY <- nowyUklad[[2]]
  
  points(noweX[eksponaty], noweY[eksponaty], 
         pch = 19, cex = 0.8, col = "#777777")
  
  for (i in seq_along(sciezka)) {
    zaznacz.eksponat(sciezka[i], noweX, noweY, cex = 1.2)
  }
  
  x <- noweX[names(noweX) %in% sciezka]
  ns <- factor(names(x), sciezka, ordered = TRUE)
  nsc <- as.integer(ns)
  x <- x[order(nsc)]
  y <- noweY[names(noweY) %in% sciezka]
  y <- y[order(nsc)]
  
  arr.length <- 0.4
  
  roznX <- (x[-length(sciezka)] - x[-1])
  roznY <- (y[-length(sciezka)] - y[-1])
  
  Arrows(x[-length(sciezka)], 
         y[-length(sciezka)], 
         x[-1] +0.07 * (x[-length(sciezka)] - x[-1]), 
         y[-1] +0.07 * (y[-length(sciezka)] - y[-1]), 
         code = 2,
         arr.length = 0.3, 
         arr.width = arr.length/2, arr.adj = 0.5, arr.type = "curved",
         segment = TRUE)
}