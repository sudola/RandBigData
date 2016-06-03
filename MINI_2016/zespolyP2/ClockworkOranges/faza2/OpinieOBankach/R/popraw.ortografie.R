#' Poprawianie ortografii
#'
#' Poprawiana jest ortografia w danych. Funkcja używa wielu wątków.
#'
#' @param dane Zbiór danych dla którego chcemy poprawić ortografię.
#' @param il.watkow Liczba wątków, na których będzie uruchomiona funkcja.
#' @param il.prob Liczba prób połączenia z serwerem.
#' @param przerwa Czas w [s] który po nieudanej próbie połączenia z serwerem odczekamy zanim nawiążemy kolejne połączenia.
#'
#' @return Zwracany jest wektor napisów zapisany w kodowaniu utf-8. Jeśli próba połączenia się
#' z serwerem nie powiedzie się zwracany jest stosowny napis.
#'
#' @import stringi parallel httr
#' @export
#' 


popraw.ortografie <- function(dane, il.watkow, il.prob, przerwa){
  
  stopifnot(is.data.frame(dane), is.numeric(il.watkow), length(il.watkow)==1,is.finite(il.watkow),
            il.watkow>0, il.watkow%%1==0,
            is.numeric(il.prob), length(il.prob)==1,is.finite(il.prob), il.prob>0, il.prob%%1==0,
            is.numeric(przerwa), length(przerwa)==1,is.finite(przerwa), przerwa>0)
  
  require(stringi)
  require(parallel)
  require(httr)
  
  
  klaster <- makeCluster(il.watkow)

  
  for (j in 1:il.prob) {
    tryCatch({
      
        parSapply(klaster, dane$body, function(napis) {
          
          set_config( config( ssl_verifypeer = 0L, ssl_verifyhost = 0L))
          
          URL <- "https://ec2-54-194-28-130.eu-west-1.compute.amazonaws.com/ams-ws-nlp/rest/spell/single"
          
          
          korekta <- httr::POST(URL, 
                                body = list(message=list(body=napis), token="2$zgITnb02!lV"),
                                add_headers("Content-Type" = "application/json"), encode = "json")
          
          korekta <- content(korekta, "parsed")
          korekta$output
          
        }) -> body
      
    
    break
    }, error = function(err) {
      cat(paste0("\n", j,". Próba poprawy ortografii nie powiodła się. 
                 Próbuję ponownie.\n"))
      if (j == il.prob) {
        stopCluster(klaster)
        stop(paste("Poprawa ortografii nie powiodła się!"))
      }
      Sys.sleep(przerwa)
    })

    
  }

  stopCluster(klaster)
  invisible()
  

   body <- as.character(body)


  
  if (Sys.info()[['sysname']] == "Windows" & stri_enc_get() == "windows-1250"){

     suppressWarnings(body <- stri_encode(body, from = "utf-8"))
  }
 

  body
  
}

