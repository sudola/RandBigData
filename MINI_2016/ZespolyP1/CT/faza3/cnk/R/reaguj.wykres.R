#' Funkcja rysuje zaktualizowany wykres prawdopodobieństw przejść.
#' 
#' Zmienia wybrany eksponat po kliknięciu na słupek eksponatu na wykresie słupkowym.
#'  
#' @param eksponaty Eksponaty bliskie do eksponatu, na który klikniemy.
#' @param klik Zdarzenie kliknięcia na wykres
#' @param session Parametr z funkcji shinyServer
#' @return NULL
#' @import shiny
#' @export
#' 

reaguj.wykres <- function(eksponaty, klik, session) {
  if (!is.null(klik)) {
    eks <- round(klik$x)
    eks <- names(eksponaty)[eks]
    updateSelectInput(session, "wybranyEksponat", selected = eks)
  }
}