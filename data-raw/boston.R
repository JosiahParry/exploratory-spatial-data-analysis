library(sf)
library(sfdep)
library(tidyverse)

acs <- select(uitk::acs_raw, 
              fips = ct_id_10, med_house_income, 
              by_pub_trans, bach) %>% 
  mutate(fips = as.character(fips),
         across(.cols = c(med_house_income, by_pub_trans, bach), 
                ~replace_na(.x, median(.x, na.rm = TRUE))))


acs_sf <- left_join(uitk::suffolk_county, acs, by = "fips")

sf::st_write(acs_sf,
             "data/boston.geojson",
             delete_dsn = TRUE)

