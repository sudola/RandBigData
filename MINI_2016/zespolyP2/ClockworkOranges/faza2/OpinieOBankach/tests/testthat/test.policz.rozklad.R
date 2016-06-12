test_that("Zwracana wartość", {
    rozklad <- policz.rozklad(dane[1:10, ], 1, 60, 3)

    expect_true(is.list(rozklad))
    expect_true(is.list(rozklad[[1]]))
    expect_true(is.list(rozklad[[1]][[1]]))
    expect_true(length(rozklad) == 10)
    expect_true("base" %in% names(rozklad[[1]][[1]]))

})

test_that("Poprawność parametrów", {
    expect_error(policz.rozklad(dane, 0.5, 60, 3))
    expect_error(policz.rozklad(dane, 1, 60.1, 3))
    expect_error(policz.rozklad(dane, 1, 60, -1))
    expect_error(policz.rozklad(dane[,-4], 1, 60, 3)) # ramka bez kolumny body
    expect_error(policz.rozklad(dane, 1, 60))

    # body nie jest typu character
    expect_error(policz.rozklad(cbind(dane[,-4], body = rep(0, nrow(dane))), 1, 60, 3))
})
