#' Funkcja dodaje nazwę eksponatu na mapę cnk.
#' 
#' Nanosi id oraz nazwę eksponatu na mapkę cnk.
#' 
#' @param id Numer id eksponatu cnk.
#' @param pelna_nazwa Pełna nazwa eksponatu cnk o identyfikatorze id.
#' @return NULL
#' @export
#' 

dodaj_info <- function(id, pelna_nazwa){
    polygon(c(0.8, 1.2 ,1.2 ,0.8), c(1.05 ,1.05 ,1.15 ,1.15), col="gray95", border = FALSE)
    text(0.95, 1.12, id, cex = 1.2)
    text(0.98, 1.08, pelna_nazwa, cex = 1.2)
}