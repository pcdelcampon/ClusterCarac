#' Characterize categorical variables by class
#'
#' Computes enrichment metrics (V-test, p-value) for each category of each
#' variable across classes, optionally using weights and filtering NAs.
#'
#' @param dtf A data.frame/tibble of categorical predictors (columns).
#' @param classc A vector of class labels, length `nrow(dtf)`.
#' @param alpha Significance level in (0,1) used to derive the V-test cutoff.
#' @param neg Reserved (currently unused).
#' @param wt Optional numeric vector of weights, length `nrow(dtf)`.
#' @param na_class Logical; if FALSE, rows with NA in `classc` are dropped.
#' @param na_categ Logical; if FALSE, rows with NA in any predictor are dropped.
#' @param extra_info Logical; if FALSE, drops internal counts and renames `nj` to
#'   `weight` in the output.
#'
#' @return A tibble with columns:
#'   `class`, `variable`, `category`, `statistic` (V-test), `p_value`,
#'   `clas_cat`, `cat_clas`, `global`, `n`, `nj`, `nk`, `njk`. When
#'   `extra_info = FALSE`, returns without `nk`, `njk`, `n` and with `weight`.
#' @references Lebart, L. and Morineau, A. and Piron, M. (1995) Statisitique exploratoire multidimensionnelle, Paris. Pardo, C.E. et al. (2015). FactoClass: Categorical data analysis for clustering and classification. CRAN Package.
#' @export
#' @importFrom dplyr count group_by mutate ungroup transmute arrange filter rename select
#' @importFrom tidyr pivot_longer
#' @importFrom tidyselect everything
#' @importFrom stats phyper qnorm
cluster_carac_quali <- 
  function( dtf , classc , alpha = 0.05 , neg = TRUE , wt = NULL, na_class = FALSE , na_categ = FALSE, extra_info = TRUE  ){  
    
    # input validation with explicit messages
    if (!is.data.frame(dtf)) {
      stop("`dtf` must be a data.frame or tibble.")
    }
    if (!is.numeric(alpha) || length(alpha) != 1 || alpha <= 0 || alpha >= 1) {
      stop("`alpha` must be a single numeric value in (0, 1).")
    }
    if (nrow(dtf) != length(classc)) {
      stop("`dtf` rows (", nrow(dtf), ") must match length of `classc` (", length(classc), ").")
    }
    if (!is.null(wt)) {
      if (!is.numeric(wt)) stop("`wt` must be numeric if provided.")
      if (length(wt) != nrow(dtf)) {
        stop("`wt` length (", length(wt), ") must match nrow(dtf) (", nrow(dtf), ").")
      }
      if (any(wt < 0, na.rm = TRUE)) stop("`wt` cannot contain negative values.")
    }
    wt_vec <- if (is.null(wt)) rep(1, nrow(dtf)) else wt

    v_lim <- stats::qnorm(1 - alpha/2)
    n_vars <- ncol(dtf)

    long <- tidyr::pivot_longer(
      dtf,
      cols = tidyselect::everything(),
      names_to = "variable",
      values_to = "category"
    ) %>%
      dplyr::mutate(
        classc = rep(classc, each = n_vars),
        wt = rep(wt_vec, each = n_vars)
      )

    if (!na_categ) {
      long <- dplyr::filter(long, !is.na(category))
    }
    if (!na_class) {
      long <- dplyr::filter(long, !is.na(classc))
    }

    dq <- long %>%
      dplyr::count(variable, category, classc, wt = wt, name = "njk", .drop = FALSE) %>%
      dplyr::group_by(variable, classc) %>%
      dplyr::mutate(nk = sum(njk)) %>%
      dplyr::group_by(variable, category) %>%
      dplyr::mutate(nj = sum(njk)) %>%
      dplyr::group_by(variable) %>%
      dplyr::mutate(
        n = sum(njk),
        clas_mod = njk / nj,
        mod_clas = njk / nk,
        Global = nj / n,
        p_value = dplyr::if_else(
          mod_clas >= Global,
          stats::phyper(njk - 1, nj, n - nj, nk, lower.tail = FALSE),
          stats::phyper(njk, nj, n - nj, nk)
        ),
        statistic = dplyr::if_else(
          mod_clas >= Global,
          stats::qnorm(p_value / 2, lower.tail = FALSE),
          stats::qnorm(p_value / 2)
        )
      ) %>%
      dplyr::ungroup()


    dqr <-  dq %>%
      dplyr::transmute(
        class = classc, variable, category,
        statistic, p_value,
        clas_cat = clas_mod, cat_clas = mod_clas, global = Global,
        n, nj, nk, njk
      ) %>%
      dplyr::arrange(class, dplyr::desc(statistic)) %>%
      dplyr::filter(abs(statistic) >= v_lim)

    if( !extra_info ){
      dqr <- dqr |>
        dplyr::rename(weight = nj) |>
        dplyr::select(-nk,-njk,-n)
    }
    
    return(dqr)
    
}
  
