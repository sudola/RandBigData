#' Aktualizacja tabeli `dane`
#'
#' Aktualizuje tabelę `dane` w podanej bazie danych.
#'
#' @param dane Ramka danych w formie zgodnej ze zwracaną przez funkcję read.page().
#' @param baza Ścieżka do bazy danych lub katalogu gdzie ma zostać utworzona baza.
#' 
#' @import RSQLite
#' @export

aktualizuj.dane <- function(baza, dane){
  
   
   stopifnot(is.character(baza), length(baza)==1)
   stopifnot(file.path(baza) == baza)
   
   stopifnot(is.data.frame(dane), setequal(colnames(dane),
      c("id","from_id","from_name","body","likes_count","comments_count",
        "shares_count","date","time","weekday","parent_id", "page_name")))
   stopifnot( nrow(dane) > 0)
   
   
   
   
  db <- dbConnect(SQLite(), dbname = baza)
  
  
  if (!"dane" %in% dbListTables(db)) {
    
    dbSendQuery(db, "CREATE TABLE dane (
                                          id nvarchar NOT NULL,
                                          from_id nvarchar,
                                          from_name nvarchar,
                                          body ntext,
                                          likes_count tinyint,
                                          comments_count tinyint,
                                          shares_count tinyint,
                                          date date,
                                          time time,
                                          weekday tinyint,
                                          parent_id nvarchar,
                                          page_name nvarchar

                                      )")
  }
  
    
  dbSendPreparedQuery(db, "INSERT INTO dane VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
                        dane)
    

  suppressWarnings(dbDisconnect(db))
  invisible()
  
  
}



