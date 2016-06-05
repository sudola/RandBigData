#' Sprawdzanie aktualizacji
#'
#' Sprawdza czy trzeba aktualizować tabelę `dane` lub tabelę `rozklady` i zwraca 
#' numery rekordów z nowych danych, których nie ma jeszcze w tych tabelach (oddzielnie dla każdej tabeli).
#'
#' @param dane Ramka danych z kolumną tekstową `id`.
#' @param baza Ścieżka do bazy danych lub katalogu gdzie ma zostać utworzona baza.
#' 
#' @return Lista złożona z 2 list:  
#' \itemize{
#' \item co.akt - 2 elementowa lista zawierająca wektor liczbowy `dane` z numerami wierszy z nowych danych
#' niezawartych w tabeli `dane` oraz wektor liczbowy `roklady` z numerami wierszy z nowych danych niezawartych w 
#' tabeli `rozklady`,
#' \item czy.akt - 2 elementowa lista zawierajaca 2 wartosci logiczne: `dane` i `rozklady` informujące
#' czy dana tabela powinna zostać zaktualizowana.
#' }
#'
#' @import RSQLite
#' @export

czy.aktualizowac <- function(dane, baza){
  
   stopifnot(is.character(baza), length(baza)==1)
   stopifnot(file.path(baza) == baza)
   stopifnot(is.data.frame(dane), "id" %in% colnames(dane))
   stopifnot(is.character(dane$id), all(!is.na(dane$id)), nrow(dane) > 0)
   

  czy.akt.dane     <- TRUE
  czy.akt.rozklady <- TRUE
  
  id.nowe.dane     <- id.nowe.rozklady <- dane$id
  
  
  db <- dbConnect(SQLite(), dbname = baza)


  # jesli aktualizowac tabele dane, to ktore wiersze
  
  if ("dane" %in% dbListTables(db)){
    
    id.stare <- dbGetQuery(db, "select id from dane")$id
    id.nowe.dane  <- setdiff(dane$id, id.stare)
    id.nowe.dane  <- which(dane$id %in% id.nowe.dane)
    
    czy.akt.dane <- ifelse(length(id.nowe.dane) > 0, TRUE, FALSE)
    
  } else {id.nowe.dane <- 1:nrow(dane)}
  
  
  # jesli aktualizowac tabele rozklady, to ktore wiersze
  
  if ("rozklady" %in% dbListTables(db)){
    
    id.stare <- dbGetQuery(db, "select id from rozklady")$id
    id.nowe.rozklady <- setdiff(dane$id, id.stare)
    id.nowe.rozklady  <-  which(dane$id %in% id.nowe.rozklady)
    
    czy.akt.rozklady <- ifelse(length(id.nowe.rozklady) > 0, TRUE, FALSE)
    
  } else {id.nowe.rozklady <- 1:nrow(dane) }
  
  
  suppressWarnings(dbDisconnect(db))
  
 
  list(
         co.akt  = list(dane=id.nowe.dane, rozklady=id.nowe.rozklady),
         czy.akt = list(dane=czy.akt.dane, rozklady=czy.akt.rozklady)
       )
  
  
}



