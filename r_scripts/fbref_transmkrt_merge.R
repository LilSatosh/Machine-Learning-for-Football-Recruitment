#merging both stats dataset from fbref and market value
#dataset from Transfermarkt 

library(worldfootballR)
library(dplyr)

stats_dataset <- read.csv("combined_stats_dataset_1.csv")
mv_dataset <- read.csv("mv_data_with_year.csv")

print(stats_dataset)
View(stats_dataset)

print(mv_dataset)
View(mv_dataset)

#------------------------------------------------
#create a composite key of player name and birth to match both stats and market
#value datasets

mv_dataset_1 <- mv_dataset %>%
  mutate(comp_key = paste0(player_name, "_", birth_year)) %>%
  distinct(comp_key, .keep_all = TRUE)

stats_dataset_1 <- stats_dataset %>%
  mutate(comp_key = paste0(Player, "_", Birth_Year))

merged_dataset_1 <- stats_dataset_1 %>%
  left_join(mv_dataset_1 %>% select(comp_key, player_market_value_euro, current_club, comp_name, player_url), 
            by = "comp_key")

View(merged_dataset_1)

#check number of NaNs
colSums(is.na(merged_dataset_1))


#----------------------------------------------------
#still using the birth year + player name composite key
#convert player names to same format (all uppercase using: "toupper"), and using
#"to='ASCII//TRANSLIT'" to remove special characters in player names 

mv_dataset_2 <- mv_dataset %>%
  mutate(name_key = toupper(iconv(player_name, to='ASCII//TRANSLIT')),
  comp_key_1 = paste0(name_key, "_", birth_year)) %>%
  distinct(comp_key_1, .keep_all = TRUE)


#same character conversion for stats dataset
stats_dataset_2 <- stats_dataset %>%
  mutate(name_key_1 = toupper(iconv(Player, to='ASCII//TRANSLIT')),
  comp_key_1 = paste0(name_key_1, "_", Birth_Year))


#merge

merged_dataset_2 <- stats_dataset_2 %>%
  left_join(mv_dataset_2 %>% 
  select(comp_key_1, player_market_value_euro, current_club, comp_name, player_url), 
  by = "comp_key_1")


View(merged_dataset_2)

#check number of NaNs
colSums(is.na(merged_dataset_2))

#----------------------------------------------------

#group remaining NaNs

still_na <- merged_dataset_2 %>%
  filter(is.na(player_market_value_euro)) %>%
  select(Player, Birth_Year) 

View(still_na)
#use the 'stringdist' library for a fuzzy match on this
library(fuzzyjoin)

fuzzy_match <- still_na %>%
  stringdist_left_join(mv_dataset_2, 
  by = c("Player" = "player_name"), 
  method = "jw", 
  max_dist = 0.15) %>%
  #ensure the Birth Year still matches
  filter(Birth_Year == birth_year) %>%
  select(Player, player_market_value_euro, current_club, comp_name, player_url)

View(fuzzy_match)


#add these back to main merge dataset
merged_dataset_3 <- merged_dataset_2 %>%
  rows_patch(fuzzy_match, by = "Player")

#handling missing values in market value column


View(merged_dataset_3)




#check number of na
colSums(is.na(merged_dataset_3))




check_missed <- merged_dataset_3 %>%
  filter(is.na(player_market_value_euro)) %>%
  select(Player, Birth_Year, current_club) %>%
  head(50)

View(check_missed)

#save as csv

write.csv(merged_dataset_3, "main_combined_dataset.csv", row.names = FALSE) 
library(readr)
write_excel_csv(merged_dataset_3, "project_dataset.csv")


#------------------------

