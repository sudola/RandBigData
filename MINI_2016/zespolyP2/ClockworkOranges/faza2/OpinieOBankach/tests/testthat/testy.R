library(testthat)
library(OpinieOBankach)


test_that("policz.since",{
    expect_error(policz.since())

    expect_error(policz.since(page_name=c("ING", "Alior Bank"), baza="baza.db"))

    expect_error(policz.since(page_name="ING"))

    expect_error(policz.since(page_name="Alior Bank S.A.", baza=1234))

    expect_error(policz.since(page_name="Alior Bank S.A.", baza=c("baza.db","baza2.db")))

    expect_true(class(policz.since(page_name="AliorBankSA",
                                   baza=file.path(getwd(),"baza.db")))
                == "Date")

})

test_that("popraw.ortografie",{
    expect_error(popraw.ortografie(dane, il.watkow=Inf, il.prob=1, przerwa=10))

    expect_error(popraw.ortografie(dane, il.watkow=8, il.prob=Inf, przerwa=9))

    expect_error(popraw.ortografie(dane, il.watkow=8, il.prob=1, przerwa=Inf))

    expect_error(popraw.ortografie(dane, il.watkow=2.3, il.prob=7, przerwa=3))

    expect_error(popraw.ortografie(dane, il.watkow=8, il.prob=4.1, przerwa=9))

    expect_error(popraw.ortografie(dane, il.watkow=8, il.prob=4, przerwa=0))

    expect_error(popraw.ortografie(dane, il.watkow=0, il.prob=3, przerwa=9))

    expect_error(popraw.ortografie(dane, il.watkow=8, il.prob=0, przerwa=1))

    expect_error(popraw.ortografie(matrix(dane), il.watkow=8, il.prob=0, przerwa=1))

    expect_error(popraw.ortografie(list(dane), il.watkow=8, il.prob=0, przerwa=1))

    expect_true(is.character(popraw.ortografie(dane, il.watkow=3, il.prob=3, przerwa=10)))

})

test_that("ramka",{
    expect_error(ramka())

    expect_error(ramka(roklad=policz.rozklad(dane,3,10,5), matrix(dane)))

    expect_output(is.data.frame(ramka(rozklad=policz.rozklad(dane, 3, 20,10),dane)))

    expect_output(is.data.frame(ramka(rozklad = post,dane = dane)))

})

test_that("read.page",{
    expect_error(read.page(page_name="AliorBankSA", how_many=Inf, token,
                           since=as.Date("2016-05-24"), il.watkow=3))

    expect_error(read.page(page_name="AliorBankSA", how_many=4, token,
                           since=as.Date("2016-05-24"), il.watkow=Inf))

    expect_error(read.page(page_name="AliorBankSA", how_many=7, token=1234,
                           since=as.Date("2016-05-24"), il.watkow=3))

    expect_error(read.page(page_name="AliorBankSA", how_many=Inf, token,
                           since="2016-05-24", il.watkow=3))

    expect_error(read.page(page_name="AliorBankSA", how_many=-2, token,
                           since=as.Date("2016-05-24"), il.watkow=3))

    expect_error(read.page(page_name="AliorBankSA", how_many=7, token,
                           since=as.Date("2016-05-24"), il.watkow=-3))

    expect_error(read.page(page_name="AliorBankSA", how_many=6, token,
                           since="2016-05-24", il.watkow=3))

    expect_error(read.page(page_name="AliorBankSA", how_many=Inf, token,
                           since=1236, il.watkow=3))

    expect_true(is.data.frame(read.page(page_name="AliorBankSA", how_many=6,
                                        token=fb_oauth, since=as.Date("2016-05-24"),
                                        il.watkow=3)))
})


