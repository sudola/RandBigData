
test_that("Test argumentu baza", {
   ramka <- ramka(rozklad = post,dane = dane)
   expect_error(aktualizuj.rozklady(baza = c("/mojedokumenty.db","/mojplik.db"),ramka = ramka))
   expect_error(aktualizuj.rozklady(baza = 42,ramka = ramka ))
   expect_error(aktualizuj.rozklady(baza = "jakis_przypadkowy/Ciag. znakow _i?42Liczb/1",ramka = ramka))
   
})

test_that("Test argumentu ramka", {
   baza <- file.path(getwd(),"BazaTestowaPakietuOpinieOBankach.db")
   expect_error(aktualizuj.rozklady(baza=baza, ramka= "dc"))
   expect_error(aktualizuj.rozklady(baza = baza, ramka = data.frame(
      id = character(0),
      date = character(0),
      time =character(0),
      weekday= numeric(0),
      baza =character(0),
      oryginal= character(0),
      tag =character(0), 
      rozklad =character(0),
      page_name =character(0)
   )))
   expect_error(aktualizuj.rozklady(baza = baza, ramka = data.frame(
      przypadkowaKolumna = "character(0)"
   )))
   
})
