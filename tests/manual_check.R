# Manual check for cluster_carac_quali

source("R/cluster_carac_quali.R")

# Simple balanced dataset
set.seed(123)
dtf1 <- data.frame(
  color = sample(c("rojo","azul"), 10, replace = TRUE),
  size  = sample(c("S","M"), 10, replace = TRUE)
)
classc1 <- factor(sample(c("c1","c2"), 10, replace = TRUE))

res1 <- cluster_carac_quali(dtf1, classc1, alpha = 0.05, extra_info = TRUE)
cat("\n== Example 1: balanced synthetic data ==\n")
print(head(res1, 10))

# Weighted example
 dtf2 <- data.frame(
  color = c("rojo","azul","rojo","azul"),
  size  = c("S","M","S","M")
)
classc2 <- factor(c("c1","c1","c2","c2"))
wt2 <- c(1, 10, 1, 10)
res2 <- cluster_carac_quali(dtf2, classc2, alpha = 1, extra_info = TRUE, wt = wt2)
cat("\n== Example 2: weighted ==\n")
print(res2)

# NA handling example
 dtf3 <- data.frame(
  color = c("rojo", NA, "azul"),
  size  = c("S", "M", NA)
)
classc3 <- factor(c("c1", NA, "c2"))
res3_drop <- cluster_carac_quali(dtf3, classc3, alpha = 1, na_class = FALSE, na_categ = FALSE)
res3_keep <- cluster_carac_quali(dtf3, classc3, alpha = 1, na_class = TRUE, na_categ = TRUE)
cat("\n== Example 3: NA handling (drop) ==\n")
print(res3_drop)
cat("\n== Example 3: NA handling (keep) ==\n")
print(res3_keep)


cat("\n== Example last: compare with FactoClass exampe data \n")
cat("== they must show the same outcomes ==\n")
# FactoClass example
library(FactoClass)
data(DogBreeds)
DB.act <- DogBreeds[-7]  # active variables
DB.function <- subset(DogBreeds,select=7)   

## it must be the same!
cat("\n*** FactoClass \n")
do.call( rbind , as.list(cluster.carac(DB.act,DB.function,"ca",2.0)) ) %>% 
  mutate( all_vars = rownames(.)) %>%
  separate( all_vars , into = c("class", "variable", "category") )
cat("\n*** ClusterCarac \n")
cluster_carac_quali( DogBreeds |> select(-FUNC) , DogBreeds$FUNC , 0.05 , extra_info = FALSE )


install.packages("remotes")  # if you don't have it
remotes::install_github("pcdelcampon/ClusterCarac")

library(ClusterCarac)

titanic_df     <- as.data.frame(Titanic)
titanic_dtf    <- titanic_df |> dplyr::select(Class, Sex, Age)
titanic_classc <- titanic_df$Survived
titanic_wt     <- titanic_df$Freq

cluster_carac_quali(titanic_dtf, titanic_classc, wt = titanic_wt, alpha = 0.05)