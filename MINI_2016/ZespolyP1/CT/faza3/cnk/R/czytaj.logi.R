#' Funkcja wczytująca dane z logów.
#'
#' Wczytuje dane z logów znajdujących się w zadanych plikach do bazy SQLite-owej.
#'
#' @param pliki Scieżka do folderu z danymi, które mają zostać wczytane.
#' @param baza Ścieżka do bazy SQLite, do której będą zapisywane dane.
#' @return NULL
#' @import RSQLite
#'

czytaj.logi <- function(pliki, baza) {
    db <- dbConnect(SQLite(), dbname = baza)

    # jeśli nie ma tabeli interakcje, to stwórz
    if (!"interakcje" %in% dbListTables(db)) {
        dbSendQuery(db, "
            create table interakcje (poczatek text, eksponat text, gosc id)")
    } else warning("Tabela 'interakcje' istnieje w bazie. Skrypt dopisze wiersze do tej tabeli.",
                   immediate. = TRUE)

    for (i in seq_along(pliki)) {
        z.pliku <- dane.z.pliku(pliki[i])
        if (is.null(z.pliku)) next
        ze.sciezki <- dane.ze.sciezki(pliki[i])

        poczatek <- paste0(ze.sciezki[["rok"]], "-",
                           ze.sciezki[["miesiac"]], "-",
                           z.pliku$dzien, " ",
                           z.pliku$godzina)

        dane <- data.frame(poczatek = poczatek,
                           eksponat = ze.sciezki[["eksponat"]],
                           gosc = z.pliku$gosc)

        dbSendPreparedQuery(db,
                            "insert into interakcje values (?,?,?)",
                            dane)

        cat(paste0("\r", i, "/", length(pliki))) # postęp
    }
    dbDisconnect(db)
    invisible()
}