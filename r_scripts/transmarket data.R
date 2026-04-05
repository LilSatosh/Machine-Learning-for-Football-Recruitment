
devtools::install_github("JaseZiv/worldfootballR")

library(worldfootballR)

countries <- c("England", "Spain", "Germany", "Italy", "France")
market_value_dataset <- data.frame()

for(country in countries) {

#fetch player transfer market value for leagues in "countries"
  league_data <- tm_player_market_values(country_name = country, start_year = 2024)
  market_value_dataset <- rbind(market_value_dataset, league_data)

#i added a time delay to avoid being labeled as a bot    
  Sys.sleep(5) 
}

View(market_value_dataset)

#save as csv
write.csv(market_value_dataset, "market_value_dataset.csv", row.names = FALSE)

