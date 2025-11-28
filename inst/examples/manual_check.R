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
telco_churn[telco_churn == "" | telco_churn == " "] <- NA

head(telco_churn)