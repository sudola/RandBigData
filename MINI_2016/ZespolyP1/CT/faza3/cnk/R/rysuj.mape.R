#' Funkcja rysuje mapę cnk.
#'
#' Rysuje mapę cnk (bez zaznaczonych eksponatów).
#' 
#' @param img Obrazek w postaci obiektu array wczytany funkcją readPNG z pakietu png.
#' @param srodowisko Środowisko, w którym przechowywane są zmienne globalne 
#' dla bieżącej sesji aplikacji.
#' @import png
#' @return NULL
#'

rysuj.mape <- function(img, srodowisko) {
  par(mar = c(0,0,0,0))
  plot(x=1:2, y=1:2, type='n', asp = 1)
  usr <- par()$usr
  assign("usr", usr, envir = srodowisko)
  rasterImage(img, usr[1], usr[3], usr[2], usr[4])
}