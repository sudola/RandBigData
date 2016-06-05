
test_that("Test argumentu baza", {
   data <- dane
   expect_error(czy.aktualizowac(dane = data, baza = c("/mojedokumenty.db","/mojplik.db")))
   expect_error(czy.aktualizowac(dane = data, baza = 42))
   expect_error(czy.aktualizowac(dane = data, baza = "jakis_przypadkowy/Ciag. znakow _i?42Liczb/1"))

})

test_that("Test argumentu dane", {
   
   baza <- file.path(getwd(),"BazaTestowaPakietuOpinieOBankach.db")
   expect_equal(czy.aktualizowac(dane = dane[1:2,], baza),expected =  list(
      co.akt  = list(dane=c(1,2), rozklady=c(1,2)),
      czy.akt = list(dane=TRUE, rozklady=TRUE)
   ))
   expect_error(czy.aktualizowac(dane = data.frame(id=character(0)),baza =  baza))
   expect_error(czy.aktualizowac(dane = "nieRamkaDanych",baza =  baza))
   expect_error(czy.aktualizowac(dane = data.frame(id=424),baza =  baza))
   expect_error(czy.aktualizowac(dane = data.frame(id=NA), baza = baza))
   expect_error(czy.aktualizowac(dane = data.frame(nieID = "jakisnumer"), baza = baza))
   
})
