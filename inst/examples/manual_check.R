#install.packages("remotes")  # if you don't have it
remotes::install_github("pcdelcampon/ClusterCarac")

library(ClusterCarac)

?cluster_carac_quali

titanic_df     <- as.data.frame(Titanic)
titanic_dtf    <- titanic_df |> dplyr::select(Class, Sex, Age)
titanic_classc <- titanic_df$Survived
titanic_wt     <- titanic_df$Freq

cluster_carac_quali(titanic_dtf, titanic_classc, wt = titanic_wt, alpha = 0.05)

# Load bundled dataset via data()
data("telco_churn", package = "ClusterCarac")
?telco_churn

# Treat blank strings as NA for convenience in manual checks
#telco_churn[telco_churn == "" | telco_churn == " "] <- NA

telco_churn

# 1) Cargar y limpiar vacíos
df0 <- read.csv(
  "inst/extdata/telco_churn.csv",
  stringsAsFactors = FALSE,
  na.strings = c("", " ", "nan", "NaN")
)

df <- df0[-1] quita la primera columna índice

df <- df %>% relocate(TechSupport, .before = StreamingTV)

# 4) Guardar
telco_churn <- df
save(telco_churn, file = "data/telco_churn.rda", compress = "bzip2")


