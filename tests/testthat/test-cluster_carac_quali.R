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
    "test_value", "p_value",
    "clas_cat", "cat_clas", "global",
    "nj", "nk", "njk"
  ) %in% names(res)))
})
