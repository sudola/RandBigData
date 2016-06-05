#' Aktualizacja tabeli `rozklady`
#'
#' Aktualizuje tabelę `rozklady` w podanej bazie danych.
#'
#' @param ramka Ramka danych w formie zwracanej przez funkcję ramka().
#' @param baza Ścieżka do bazy danych lub katalogu gdzie ma zostać utworzona baza.
#' 
#' @import RSQLite
#' @export


aktualizuj.rozklady <- function(baza, ramka){

   stopifnot(is.character(baza), length(baza)==1)
   stopifnot(file.path(baza) == baza)
   
   stopifnot(is.data.frame(ramka), setequal(colnames(ramka),
      c("id", "date", "time", "weekday", "baza", "oryginal", "tag", 
        "rozklad", "page_name")), nrow(ramka) > 0)

  
  db <- dbConnect(SQLite(), dbname = baza)


  if (!"rozklady" %in% dbListTables(db)) {
    
    dbSendQuery(db, "create table rozklady (
                id smallint,
                date date,
                time nvarchar, 
                weekday tinyint,
                baza nvarchar,
                oryginal nvarchar, 
                tag nvarchar, 
                rozklad nvarchar,
                page_name nvarchar
    )")
  }


  
    
   dbSendPreparedQuery(db, "insert into rozklady values (?,?,?,?,?,?,?,?,?)",
                        ramka)
    

  
  
  
  suppressWarnings(dbDisconnect(db))
  
  
  invisible()
  
  
}

