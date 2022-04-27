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



bos_neighborhoods <- read_sf("https://gist.githubusercontent.com/gtallen1187/69a431091c43db10096142883c4acb5f/raw/f7fd65b45ff120497cc0acfe1a4bd9aeed42a9f1/boston_neighborhoods.geojson")

write_sf(bos_neighborhoods,"data/neighborhoods.geojson")
