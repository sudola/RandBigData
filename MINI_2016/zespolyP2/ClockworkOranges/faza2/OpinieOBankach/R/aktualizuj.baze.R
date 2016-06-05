#' Aktualizacja całej bazy danych
#'
#' Aktualizuje całą bazę danych o posty z facebooka od daty, która jako
#' ostatnia widnieje w bazie dla danego banku. Funkcja działa na wielu wątkach.
#'
#' @param page_name Nazwa strony z facebooka, z której będą pobierane posty.
#' @param how_many Liczba postów do pobrania (domyślnie 100).
#' @param baza Ścieżka do bazy danych lub katalogu gdzie ma zostać utworzona baza.
#' @param il.watkow Liczba wątków użytych do przetwarzania danych.
#' @param il.prob Liczba prób ściągnięcia danych z facebooka, poprawienia ortografii w
#' postach lub dokonania rozkładu. Zdarza się, że nie uda się tego zrobić za pierwszym
#' razem. Domyślna wartość to 59 powtórzeń.
#' @param przerwa Liczba sekund przerwy między kolejnymi próbami aktualizacji bazy.
#'
#' @import stringi
#' @export

aktualizuj.baze <- function(page_name, how_many = 100, baza, il.watkow = 20,
                            il.prob = 60, przerwa = 2){

   stopifnot(is.character(page_name), length(page_name)==1)

   stopifnot(is.character(baza), length(baza)==1)
   stopifnot(file.path(baza) == baza)

   stopifnot( is.numeric(il.watkow), il.watkow %% 1 == 0,
              length(il.watkow) == 1, il.watkow > 0)

   stopifnot(is.numeric(il.prob), il.prob %% 1 == 0, length(il.prob) == 1,
             il.prob > 0)

   stopifnot(is.numeric(przerwa), przerwa > 0, length(przerwa) == 1 )

   stopifnot(is.numeric(how_many), how_many %% 1 == 0, length(how_many) == 1,
             how_many > 0)





  since <- policz.since(page_name = page_name, baza = baza)

  # czasami proba pobrania danych z fejsa przy duzej ilosci ustawionych postow sie
  # nie udaje od razu, wiec probujemy wiecej razy

  for (j in 1:il.prob) {
    tryCatch({

  dane <- read.page(page_name = page_name, how_many = how_many, token = fb_oauth, since = since, il.watkow = il.watkow)

  break

    }, error=function(err){

      cat(paste0("\n", j,". Próba pobrania danych z Facebooka nie powiodla sie.
                 Próbuję ponownie.\n"))


      if(j == il.prob)
        stop(paste("Nie udalo sie pobrac danych!"))


    Sys.sleep(przerwa)

      })}





  # usuwanie pustych postow
  puste <- which(sapply(dane$body, function(x) is.na(x) | x == ""))


  if(length(puste) > 0)
    dane  <- dane[-puste, ]





  #---------------SPRAWDZENIE CZY TRZEBA AKTUALIZOWAC BAZE---------------------


  aktualizacja     <- czy.aktualizowac(dane, "baza.db")

  czy.akt.dane     <- aktualizacja$czy.akt$dane       # czy trzeba aktualizowac tabele dane
  czy.akt.rozklady <- aktualizacja$czy.akt$rozklady   # czy trzeba aktualizowac tabele rozklady
  id.nowe.dane     <- aktualizacja$co.akt$dane        # ktorych wierszy z danych nie ma w tabeli dane
  id.nowe.rozklady <- aktualizacja$co.akt$rozklady    # ktorych wierszy z danych nie ma w tabeli rozklady

  wiersze   <- unique(c(id.nowe.dane, id.nowe.rozklady))
  dane      <- dane[wiersze, ]


  aktualizacja <- czy.aktualizowac(dane, "baza.db")
  id.nowe.dane     <- aktualizacja$co.akt$dane
  id.nowe.rozklady <- aktualizacja$co.akt$rozklady



  if(!czy.akt.dane & czy.akt.rozklady)
    cat("\nTabela dane jest aktualna! Aktualizuje tabele rozklady.")


  if(!czy.akt.rozklady & czy.akt.dane)
    cat("\nTabela rozklady jest aktualna! Aktualizuje tabele dane.")





  if(!czy.akt.rozklady & !czy.akt.dane){

     return("Nie ma co aktualizowac! Obie tabele aktualne!")

  }


  #----------------------------------------------------------------------------


  # na windowsie trzeba czasem poprawic kodowanie

  if (Sys.info()[['sysname']] == "Windows" &
       stri_enc_get() == "windows-1250" &
      all(!stri_enc_detect(dane$body[1])[[1]]$Encoding %in% c("ISO-8859-1", "UTF-8"))){

        suppressWarnings(dane$body <- stri_encode(as.character(dane$body),
                                                  from = "utf-8"))

  }


  suppressWarnings(dane$from_name <- stri_encode(as.character(dane$from_name), from = "utf-8"))




  #--------------------------POPRAWA ORTOFRAFII--------------------------------



  if(czy.akt.dane & length(id.nowe.dane) > 0 |
     czy.akt.rozklady & length(id.nowe.rozklady) > 0){



        cat("\n", "Rozpoczynam poprawe ortografii")


        # do poprawy ortografii ida tylko te wiersze, ktorych nie bylo
        # w tabeli dane lub w tabeli rozklady


          dane$body <- popraw.ortografie(dane, il.watkow, il.prob, przerwa)



        cat("\n", "Koniec poprawy ortografii")


  }





  #------------------------------ROZKLAD----------------------------------------




  if(czy.akt.rozklady & length(id.nowe.rozklady) > 0){



        cat("\n", "Rozpoczynam liczenie rozkladu")


          rozklad <- policz.rozklad(dane[id.nowe.rozklady, ], il.watkow, il.prob, przerwa)


        cat("\n", "Rozklad policzony")




        #------------------TWORZENIE RAMKI DO DRUGIEJ TABELI-------------------


        cat("\n", "Tworzenie ramki do tabeli rozklady")


          ramka <- ramka(rozklad, dane[id.nowe.rozklady, ])


        cat("\n", "Ramka utworzona")



        # usuwam rozklad, bo moze zajmowac duzo miejsca w pamieci
        rm(rozklad)



  }






  #--------------------------AKTUALIZACJA BAZY---------------------------------



  #-------------------------PIERWSZA TABELA BAZY-------------------------------


      if(czy.akt.dane & length(id.nowe.dane) > 0){

            cat("\n", "Rozpoczynam aktualizacje tabeli dane")


            aktualizuj.dane(baza, dane[id.nowe.dane, ])


            cat("\n", "Tabela dane zaktualizowana")

      }





  #---------------------------DRUGA TABELA BAZY--------------------------------


  if(czy.akt.rozklady & length(ramka) > 0){

          cat("\n", "Rozpoczynam aktualizacje tabeli rozklady")


            aktualizuj.rozklady(baza, ramka)


          rm(ramka)


          cat("\n", "Tabela rozklady zaktualizowana")

  } else {cat("\n", "Tabela rozklady aktualna! Patrz ramka!")}



}



