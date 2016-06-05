

test_that("Test argumentu baza", {
   data <- dane
   expect_error(aktualizuj.dane(dane = data, baza = c("/mojedokumenty.db","/mojplik.db")))
   expect_error(aktualizuj.dane(dane = data, baza = 42))
   expect_error(aktualizuj.dane(dane = data, baza = "jakis_przypadkowy/Ciag. znakow _i?42Liczb/1"))
   
})

test_that("Test argumentu dane", {
   
   baza <- file.path(getwd(),"BazaTestowaPakietuOpinieOBankach.db")
   expect_error(aktualizuj.dane(dane = data.frame(
      id = character(0),
      from_id = character(0),
      from_name = character(0),
      body = character(0),
      likes_count = numeric(0),
      comments_count= numeric(0),
      shares_count = numeric(0),
      date = character(0),
      time = character(0),
      weekday = numeric(0),
      parent_id = character(0),
      page_name = character(0)
   ),baza =  baza))
   expect_error(aktualizuj.dane(dane = "nieRamkaDanych",baza =  baza))
   expect_error(aktualizuj.dane(dane = data.frame(nieID = "jakisnumer"), baza = baza))
   
})
