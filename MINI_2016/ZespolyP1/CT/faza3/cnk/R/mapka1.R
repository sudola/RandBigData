#' Funkcja rysuje mapę cnk
#' 
#' Rysuje mapę cnk. Wybrany eksponat zaznacz kolorem niebieskim, bliskie eksponaty
#' kolorem czarnym, a pozostałe kolorem szarym.
#' 
#' @param wybrany Numer id wybranego eksponatu.
#' @param bliskie Numery id punktów bliskich do wybranego.
#' @param eksponaty Numery id wszystkich ekponatów.
#' @param wspX Współrzędne x wszystkich eksponatów.
#' @param wspY Współrzędne y wszystkich eksponatów.
#' @param img Obrazek w postaci obiektu array wczytany funkcją readPNG z pakietu png.
#' @param srodowisko Środowisko, w którym przechowywane są zmienne globalne 
#' dla bieżącej sesji aplikacji.
#' @param usr Parametr usr zwracany przez funkcję par().
#' @return NULL
#' @export
#' 

mapka1 <- function(wybrany, bliskie, eksponaty, wspX, wspY, img, srodowisko, usr) {
  rysuj.mape(img, srodowisko)
  
  nowyUklad <- zamien.uklad(wspX, wspY, 663, 651, usr)
  noweX <- nowyUklad[[1]]
  noweY <- nowyUklad[[2]]
  
  points(noweX[eksponaty], noweY[eksponaty], 
         pch = 19, cex = 0.8, col = "#777777")
  
  for (b in seq_along(bliskie)) {
    if (rev(bliskie)[b] != wybrany)
      zaznacz.eksponat(rev(bliskie)[b], noweX, noweY, 
                       cex = 3*b/length(bliskie))
  }
  
  zaznacz.eksponat(wybrany, noweX, noweY, cex = 3, col = "blue")
}