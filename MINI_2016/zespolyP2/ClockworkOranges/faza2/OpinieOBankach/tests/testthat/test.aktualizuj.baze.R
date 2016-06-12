
test_that("Test argumentu page_name", {
   baza <- file.path(getwd(),"BazaTestowaPakietuOpinieOBankach.db")
   expect_error( aktualizuj.baze(page_name=c("INGBankSlaski","AliorBank"), how_many = 1, il.watkow = 20, il.prob = 60, przerwa = 2,
                                   baza = baza ))
   
   expect_error( aktualizuj.baze(page_name=32, how_many = 1, il.watkow = 20, il.prob = 60, przerwa = 2,
                                 baza = baza ))
})




test_that("Test argumentu il.watkow", {
   baza <- file.path(getwd(),"BazaTestowaPakietuOpinieOBankach.db")
   
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 0, il.prob = 60, przerwa = 2,
                                baza = baza ))
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 1/2, il.prob = 60, przerwa = 2,
                                 baza = baza ))
   
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = c(1,2), il.prob = 60, przerwa = 2,
                                 baza = baza ))
   
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = "2", il.prob = 60, przerwa = 2,
                                 baza = baza ))

})


test_that("Test argumentu il.prob", {
   baza <- file.path(getwd(),"BazaTestowaPakietuOpinieOBankach.db")
   
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 20, il.prob = 0, przerwa = 2,
                                baza = baza ))
   
   expect_error( aktualizuj.baze(page_name=c("INGBankSlaski","AliorBank"), how_many = 1, il.watkow = 1/2, il.prob = 60, przerwa = 2,
                                 baza = baza ))
   
   expect_error( aktualizuj.baze(page_name=c("INGBankSlaski","AliorBank"), how_many = 1, il.watkow = c(1,2), il.prob = 60, przerwa = 2,
                                 baza = baza ))
   
   expect_error( aktualizuj.baze(page_name=c("INGBankSlaski","AliorBank"), how_many = 1, il.watkow = "2", il.prob = 60, przerwa = 2,
                                 baza = baza ))
   
})

test_that("Test argumentu przerwa", {
   baza <- file.path(getwd(),"BazaTestowaPakietuOpinieOBankach.db")
   
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 20, il.prob = 1, przerwa = 0,
                                 baza = baza ))
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 20, il.prob = 1, przerwa = "2",
                                 baza = baza ))
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 20, il.prob = 1, przerwa = c(1,2),
                                 baza = baza ))
})



test_that("Test argumentu how_many", {
   baza <- file.path(getwd(),"BazaTestowaPakietuOpinieOBankach.db")
   
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = "2", il.watkow = 20, il.prob = 1, przerwa = 1,
                                 baza = baza ))
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 2.3, il.watkow = 20, il.prob = 1, przerwa = 1,
                                 baza = baza ))
   
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = c(1,2), il.watkow = 20, il.prob = 1, przerwa = 1,
                                 baza = baza ))
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 0, il.watkow = 20, il.prob = 1, przerwa = 1,
                                 baza = baza ))
})




test_that("Test argumentu baza", {
   expect_error( aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 20, il.prob = 60, przerwa = 2,
                                baza = c("/mojedokumenty.db","/mojplik.db")) )
   expect_error(aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 20, il.prob = 60, przerwa = 2,
                                 baza = 42))
   expect_error(aktualizuj.baze(page_name="INGBankSlaski", how_many = 1, il.watkow = 20, il.prob = 60, przerwa = 2,
                                 baza = "jakis_przypadkowy/Ciag. znakow _i?42Liczb/1"))
})
