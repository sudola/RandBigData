

test_that("Zwracana wartość", {
    post <- get.post("366165933177_10153736157358178", fb_oauth, 1)
    expect_true(is.list(post))
    expect_true(is.list(post[[1]]))
    expect_true(length(post[[1]]) == 3)
    expect_true(all(c("post", "likes", "comments") %in% names(post[[1]])))
    expect_true(all(sapply(post[[1]], is.data.frame)))
})

test_that("Poprawność argumentów", {
    expect_error(get.post(1247218, fb_oauth, 1))
    expect_error(get.post("366165933177_10153736157358178", fb_oauth, 0))
    expect_error(get.post("366165933177_10153736157358178"))
    expect_error(get.post("366165933177_10153736157358178", "fb_oauth", 1))
})
