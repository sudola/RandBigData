#' Funkcja zaznacza eksponaty na mapce cnk.
#' 
#' Zaznacza na mapie cnk punkt, w którym znajduje się eksponat cnk.
#' 
#' @param eks Nazwa eksponatu.
#' @param wspX Współrzędne x eksponatów cnk na mapie cnk.
#' @param wspY Współrzędne y eksponatów cnk na mapie cnk.
#' @return NULL
#' 

zaznacz.eksponat <- function(eks, wspX, wspY, cex,  ...) {
  points(wspX[eks], wspY[eks],  pch = 19, cex = cex, ...)
  text(wspX[eks], wspY[eks]+0.03, labels = eks, ...)
}