#' Wczytywanie danych z Facebooka
#'
#' Funkcja read.page() wczytuje posty wraz z komentarzami ze strony page_name
#' i zwraca ramkę danych.
#'
#' @param page_name Nazwa strony.
#' @param how_many Ile postów ze strony mamy pobrać.
#' @param token Token lub plik z pakietu (plik fb_oauth), który trzeba wczytać.
#' @param since Data od której chcemy pobierać informacje.
#' @param il.watkow Na ilu wątkach mają się pobierać dane.
#'
#' @return Zwracana jest ramka danych składająca się z napisów.
#'
#' @import Rfacebook pbapply httr
#'
#'
#' @export


read.page <- function(page_name, how_many, token, since, il.watkow){

    stopifnot(is.character(page_name), length(page_name)==1, is.numeric(how_many),
              length(how_many)==1, is.finite(how_many), how_many>0,
              length(il.watkow)==1, is.numeric(il.watkow), is.finite(il.watkow),
              il.watkow>0)

  require(Rfacebook)
  require(pbapply)
  require(httr)

    set_config( config( ssl_verifypeer = 0L, ssl_verifyhost = 0L))

    page     <- getPage(page_name, token, n = how_many, feed = TRUE, since = since)
    posts_id <- page$id


    # wyciagamy posty z komentarzami
    raw_data <- get.post(posts_id, token, il.watkow)


    # tworzy liste data.frame'ow z danymi dla wszystkich postow
    data_inDF <- pblapply(raw_data, function(i) merge.comments(i, page_name = page_name))


    # laczy je w jeden data.frame:
    merged_data <- do.call(rbind, data_inDF)
    merged_data <- as.data.frame(merged_data)

}


