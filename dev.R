# https://dataverse.harvard.edu/file.xhtml?fileId=4435100&version=4.0
x <- read_csv("/Users/josiahparry/Downloads/311 Cases 2020_2024 Unrestricted.csv")

glimpse(x)

x_sf <- x |> 
  filter(!is.na(X), !is.na(Y)) |> 
  st_as_sf(coords = c("X", "Y"), crs = 4326)

st_geometry(x_sf) |> 
  plot()


blk_311 <- x_sf |> 
  as_tibble() |> 
  mutate(GEOID = as.character(BG_ID_10)) |> 
  group_by(GEOID) |> 
  summarise(across(PUBLIC:PROBLEM, sum))


#blks_sf <- tigris::blocks("MA", "Suffolk")
#cbg_sf <- tigris::block_groups("MA", "Suffolk", cb = TRUE)
ct_sf <- tigris::tracts("MA", "Suffolk", cb = TRUE)

ct_sf


df <- cbg_sf |> 
  select(GEOID) |> 
  left_join(blk_311, by = "GEOID") 

cbg_attr <- read_csv("/Users/josiahparry/Downloads/ACS_1519_BLKGRP.csv")

full_df <- cbg_attr |> 
  janitor::clean_names() |> 
  mutate(bg_id_10 = as.character(bg_id_10)) |> 
  right_join(df, by = c("bg_id_10" = "GEOID"))
  
full_df |> 
  #as_tibble() |> 
  # can use spatial lag impute
  mutate(nb = st_contiguity(geometry),
         wt = st_weights(nb),
         # lag impute
         x = coalesce(TRASH, st_lag(TRASH, nb, wt)))
         local_moran_bv())
