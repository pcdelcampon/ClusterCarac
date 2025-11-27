![](inst/images/ClusterCarac_IA001.png)

## What it does!

**ClusterCarac** is an R package designed to describe and characterize groups resulting from classification or clustering analyses, as well as groups defined by observational attributes. It identifies the qualitative variables that most strongly represent each cluster and shows the categories from qualitative variables that best explain the distinctive profile of each group.

## Where you can use ClusterCarac!

**ClusterCarac** can be used in any situation where you want to better understand the groups that appear in your data. Whether those groups come from a clustering method or are simply categories you already have (like age groups, customer segments, regions, or types of users), the package helps you **describe what makes each group unique**.

**Note:** ClusterCarac currently works with qualitative variables. Support for quantitative variables and additional features is coming soon.

You can use it in:

-   **Market and customer segmentation**, to understand what characteristics define each segment.

-   **Social and demographic studies**, to explore how different groups in a population differ from one another.

-   **Public health or education projects**, to identify the key traits of the communities or groups you are studying.

-   **User or product analytics**, to see what features stand out in each category of users or items.

-   **Any project with data**, where you have groups and want a simple way to describe them clearly.

In short, ClusterCarac helps you **summarize and interpret groups** so you can communicate insights more easily, even if you are not a technical expert.

## How to install!

Install directly from GitHub (simplest current option):

``` r
install.packages("remotes")  # if you don't have it
remotes::install_github("pcdelcampon/ClusterCarac")
```

## Quick start

```r
library(ClusterCarac)

set.seed(123)
dtf <- data.frame(
  color = sample(c("rojo", "azul"), 20, replace = TRUE),
  size  = sample(c("S", "M"), 20, replace = TRUE)
)
classc <- sample(c("c1", "c2"), 20, replace = TRUE)

res <- cluster_carac_quali(dtf, classc, alpha = 0.05)
head(res)
```

Documentation: once installed, see `?cluster_carac_quali` for parameters and output details.

## Motivation

This package is inspired by a previous project called [FactoClass](https://cran.r-project.org/web/packages/FactoClass/index.html), developed at the **Universidad Nacional de Colombia** in collaboration with Professor [Campo Elías Pardo](https://www.linkedin.com/in/campo-el%C3%ADas-pardo-5ab19435/) and other contributors. Users of that package often had recurring questions about the characterization functions applied to the clusters produced by the original tool. These questions highlighted the need for clearer and more dedicated methods to describe the groups or segments obtained from clustering or classification procedures.

For this reason, I decided to create this new set of tools, focusing specifically on the characterization of classifications or segments, while continuing the methodological direction initiated with FactoClass.

## Author

Pedro Cesar Del Campo Neira · pcdelcampon@gmail.com · [Personal site](https://pcdelcampon.github.io/mywebquarto/)
