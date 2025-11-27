test_that("cluster_carac_quali returns tibble with expected cols", {
  set.seed(123)
  dtf <- data.frame(
    color = sample(c("rojo", "azul"), 20, replace = TRUE),
    size  = sample(c("S", "M"), 20, replace = TRUE)
  )
  classc <- sample(c("c1", "c2"), 20, replace = TRUE)

  res <- cluster_carac_quali(dtf, classc, alpha = 0.05)

  expect_s3_class(res, "tbl_df")
  expect_true(all(c(
    "class", "variable", "category",
    "statistic", "p_value",
    "clas_cat", "cat_clas", "global",
    "nj", "nk", "njk", "n"
  ) %in% names(res)))
})

test_that("cluster_carac_quali respects weights when provided", {
  dtf <- data.frame(
    color = c("rojo", "azul", "rojo", "azul"),
    size  = c("S", "M", "S", "M")
  )
  classc <- factor(c("c1", "c1", "c2", "c2"))
  wt <- c(1, 10, 1, 10)

  res_unw <- cluster_carac_quali(dtf, classc, alpha = 1, extra_info = TRUE)
  res_wt  <- cluster_carac_quali(dtf, classc, alpha = 1, extra_info = TRUE, wt = wt)

  # Pick a specific combination to compare
  unw_row <- res_unw[res_unw$variable == "color" & res_unw$category == "azul" & res_unw$class == "c1", , drop = FALSE]
  wt_row  <- res_wt[res_wt$variable == "color" & res_wt$category == "azul" & res_wt$class == "c1", , drop = FALSE]

  expect_equal(unw_row$njk, 1)
  expect_equal(wt_row$njk, 10)
})

test_that("cluster_carac_quali extra_info drops internal counts", {
  dtf <- data.frame(
    color = c("rojo", "azul"),
    size  = c("S", "M")
  )
  classc <- factor(c("c1", "c1"))

  res <- cluster_carac_quali(dtf, classc, alpha = 1, extra_info = FALSE)

  expect_false(any(c("nk", "njk", "n") %in% names(res)))
  expect_true("Weight" %in% names(res))
})

test_that("cluster_carac_quali handles NA filtering flags", {
  dtf <- data.frame(
    color = c("rojo", NA, "azul"),
    size  = c("S", "M", NA)
  )
  classc <- factor(c("c1", NA, "c2"))

  res_drop <- cluster_carac_quali(dtf, classc, alpha = 1, na_class = FALSE, na_categ = FALSE)
  expect_false(any(is.na(res_drop$category)))
  expect_false(any(is.na(res_drop$class)))

  res_keep <- cluster_carac_quali(dtf, classc, alpha = 1, na_class = TRUE, na_categ = TRUE)
  expect_true(any(is.na(res_keep$category)))
  expect_true(any(is.na(res_keep$class)))
})
