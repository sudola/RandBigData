#' Rozkłady zdań w treści postów.
#'
#' Dla ramki danych zaweirającej kolumnę body listę rozkładów zdań w tej
#' ramce. Korzysta z serwsisu:
#' https://ec2-54-194-28-130.eu-west-1.compute.amazonaws.com/ams-ws-nlp/rest/nlp/single
#' W przypadku niepowodzenia próbuje wiele razy, każda próba jest odzielona przerwą.
#'
#' @param dane Ramka danych, zawierająca kolumnę napisów body
#' @param il.watkow Liczba wątków, na których będzie wykonywana funckja.
#' @param il.prob Liczba prób w przypadku niepowodzenia.
#' @param przerwa Przerwa pomiedzy probami.
#'
#' @return Zwraca rozklad zdań w postach w postaci listy list list.
#' Każdy element zewnętrznej listy odpowiada jednemu postowi. Każdy element listy
#' środkowej zawiera informacje dotyczące jednego słowa. Elementy wewnętrznej listy
#' zawierają poszczególne informacje o roli tego słowa w zdaniu.
#'
#' @import parallel httr
#' @export



policz.rozklad <- function(dane, il.watkow, il.prob, przerwa) {
    stopifnot(is.data.frame(dane), "body" %in% names(dane),
              is.character(dane$body),
              is.numeric(il.watkow), is.numeric(il.prob), is.numeric(przerwa),
              il.watkow %% 1 == 0, il.prob %% 1 == 0,
              length(il.watkow) == 1, length(il.prob) == 1, length(przerwa) == 1,
              il.watkow > 0, il.prob > 0, przerwa > 0)

    klaster <- makeCluster(il.watkow)


    for (j in 1:il.prob) {
        tryCatch({
            parSapplyLB(klaster, dane$body, function(napis){
                require(httr)

                set_config( config( ssl_verifypeer = 0L, ssl_verifyhost = 0L))
                URL <- "https://ec2-54-194-28-130.eu-west-1.compute.amazonaws.com/ams-ws-nlp/rest/nlp/single"
                nlp <- POST(URL,
                            body = list(message=list(body=napis), token="2$zgITnb02!lV"),
                            add_headers("Content-Type" = "application/json"), encode = "json")

                content(nlp, "parsed")

            }) -> rozklad

            break
        }, error = function(err) {
            cat(paste0("\n", j,". Proba rozkladu nie powiodla sie. Próbuję ponownie.\n"))
            if (j == il.prob) {

                stopCluster(klaster)
                stop(paste("Liczenie rozkladu nie powiodlo sie!"))
            }
            Sys.sleep(przerwa)
        })

    }

    suppressWarnings(stopCluster(klaster))


    usun <- which(sapply(1:length(rozklad), function(i)
        all(class(rozklad[[i]]) == "list")
    ) != TRUE)

    if (length(usun) > 0) {rozklad[-usun]} else {rozklad}
}



