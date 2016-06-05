#' Funkcja rysuje wykres prawdopodobieństw przejścia dla danego eksponatu cnk.
#' 
#' Rysuje wykres słupkowy prawdopodobieństw przejścia z danego eksponatu do 
#' innych eksponatów cnk.
#' 
#' @param eksponaty Eksponaty bliskie do "wybranyEksponat".
#' @param wybranyEksponat Eksponat, dla którego chcemy zonaczyć wykres 
#' prawdopodobieństw przejścia do innych eksponatów cnk.
#' @return NULL
#' @import ggplot2
#' @export 
#' 

wykres <- function(eksponaty, wybranyEksponat) {
  tab <- data.frame(eksponaty, names(eksponaty))
  colnames(tab) <- c("pstwo", "nazwa")
  ggplot(tab, aes(factor(nazwa, levels = nazwa), pstwo)) +
    geom_bar(stat = "identity") +
    xlab("eksponat") + 
    ylab("prawdopodobienstwo") +
    ggtitle(paste("Prawdopodobieństwa przejścia dla eksponatu", 
                  wybranyEksponat))
}