#' Sprawdzanie daty ostatniego postu
#'
#' Funkcja ma za zadanie dla danej strony sprawdzić w bazie date ostatniego postu.
#'
#' @param page_name Nazwa strony.
#' @param baza Ścieżka do bazy.
#'
#' @return Zwracany jest wektor jednoelementowy zawierający datę, jeśli taka istnieje.
#'
#' @import Rfacebook 
#' @export


policz.since <- function(page_name, baza){
  
  stopifnot(is.character(page_name), length(page_name)==1,is.character(baza),
            length(baza)==1, file.path(baza)==baza)
  
  
require(RSQLite)  
  
  since.dane <- NULL
  since.rozklady <- NULL
  
  query.dane <- paste("SELECT date FROM dane where page_name = '", 
                      page_name, "' limit 1", sep = "")
  query.rozklady <- paste("SELECT date FROM rozklady where page_name = '", 
                          page_name, "' limit 1", sep = "")
  

  
  db <- dbConnect(SQLite(), dbname = baza)
  
      if ("dane" %in% dbListTables(db)){
        
        if (page_name %in% dbGetQuery(db, "select distinct(page_name) from dane")$page_name)
           since.dane <- dbGetQuery(db, query.dane)$date
      }
  
  
  if ("rozklady" %in% dbListTables(db)){
    
    
    if (page_name %in%   
        dbGetQuery(db, "select distinct(page_name) from rozklady")$page_name)
      
      since.rozklady <- dbGetQuery(db, query.rozklady)$date
    
    
    
  }
  
  dbDisconnect(db)
  
  
  if (is.null(since.dane) | is.null(since.rozklady)) return(NULL)
  
  
  min(as.Date(since.dane), as.Date(since.rozklady))
  

}
  
  
  
  