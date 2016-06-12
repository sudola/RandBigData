
test_that("Zwracana wartość", {
    ramka <- merge.comments(post[[1]], "AliorBankSA")
    expect_true(is.data.frame(ramka))
    expect_true(all(c("id", "from_id", "from_name", "body", "likes_count",
                      "comments_count", "shares_count", "date", "time", "weekday",
                      "parent_id", "page_name") %in% colnames(ramka)))
})


test_that("Poprawność argumentów", {
    expect_error(merge.comments())
    expect_error(merge.comments(post[[1]], c("AliorBankSA", "ING")))
    expect_error(merge.comments(post[[1]]))
    expect_error(merge.comments(list(), "AliorBankSA"))
    expect_error(merge.comments("AliorBankSA", post))

    # nie jest ważna kolejność w liście
    expect_error(merge.comments(post[[1]][c(2,3,1)], "AliorBankSA"), NA)
    expect_identical(merge.comments(post[[1]][c(2,3,1)], "AliorBankSA"),
                     merge.comments(post[[1]], "AliorBankSA"))
})
