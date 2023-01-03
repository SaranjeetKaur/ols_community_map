library(countrycode)
library(tidygeocoder)

# Load OLS data
urlfile <- 'https://raw.githubusercontent.com/open-life-science/ols-program-paper/main/data/people.csv'
data_ols <- read.csv(urlfile)
#View(data_ols)
#str(data_ols)
data_ols$iso3c <- rep(NA, nrow(data_ols))
#View(data_ols)
data_ols$iso3c <- countryname(data_ols$country, destination = 'iso3c')
data_ols$OLS_1 <- rep(NA, nrow(data_ols))
data_ols$OLS_1 <- ifelse(data_ols$ols.1 == "", "", "OLS_1")
data_ols$OLS_2 <- rep(NA, nrow(data_ols))
data_ols$OLS_2 <- ifelse(data_ols$ols.2 == "", "", "OLS_2")
data_ols$OLS_3 <- rep(NA, nrow(data_ols))
data_ols$OLS_3 <- ifelse(data_ols$ols.3 == "", "", "OLS_3")
data_ols$OLS_4 <- rep(NA, nrow(data_ols))
data_ols$OLS_4 <- ifelse(data_ols$ols.4 == "", "", "OLS_4")
data_ols$OLS_5 <- rep(NA, nrow(data_ols))
data_ols$OLS_5 <- ifelse(data_ols$ols.5 == "", "", "OLS_5")
data_ols$OLS_6 <- rep(NA, nrow(data_ols))
data_ols$OLS_6 <- ifelse(data_ols$ols.6 == "", "", "OLS_6")

data_ols$ols_cohort <- rep(NA, nrow(data_ols))
data_ols$ols_cohort <- paste(data_ols$OLS_1,
                             data_ols$OLS_2,
                             data_ols$OLS_3,
                             data_ols$OLS_4,
                             data_ols$OLS_5,
                             data_ols$OLS_6,
                             sep=";")

data_ols_separate <- separate_rows(data_ols, 20, sep = ';')
data_ols_separate <- data_ols_separate[!(data_ols_separate$ols_cohort == ""), ]
colnames(data_ols_separate)
to_use_data_ols <- data_ols_separate[, c("X", "city", "country", "iso3c", "ols_cohort")]

df <- to_use_data_ols %>%
  geocode(city = city, method = 'osm', lat = latitude , long = longitude)

write.csv(df, "data/olscommunity.csv", row.names=FALSE)
