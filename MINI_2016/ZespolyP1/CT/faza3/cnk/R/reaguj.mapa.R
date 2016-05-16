#' Funkcja rysująca aktualną mapę po kliknięciu na wybrany eksponat.
#' 
#' Po kliknięciu w wybrany eksponat rysuje zaktualizowaną mapę przejść
#' do kolejnych eksponatów cnk.
#'  
#' @param eksponaty Eksponaty spośród których wybieramy następny.
#' @param klik_mapa Zdarzenie kliknięcia na mapę.
#' @param wspX Współrzędne x eksponatów cnk.
#' @param wspY Współrzędne y eksponatów cnk.
#' @param srodowisko Środowisko, w którym przechowywane są zmienne globalne 
#' dla bieżącej sesji aplikacji.
#' @param session Parametr z funkcji shinyServer
#' @param usr Parametr usr zwracany przez funkcję par().
#' @return NULL
#' @import shiny
#' @export
#' 

reaguj.mapa <- function(eksponaty, klik_mapa, wspX, wspY, srodowisko, session, usr) {
  
  nowyUklad <- zamien.uklad(wspX, wspY, 663, 651, usr)
  noweX <- nowyUklad[[1]]
  noweY <- nowyUklad[[2]]
  
  df <- data.frame(x = noweX[eksponaty], y = noweY[eksponaty])
  
  if (!is.null(klik_mapa)) {
    eks <- which.min(apply(df, 1, function(row) { 
      (row[1] - klik_mapa$x)^2 + (row[2] - klik_mapa$y)^2
    }))
    eks <- eksponaty[eks]
    
    updateSelectInput(session, "wybranyEksponat", selected = eks)
  }
}