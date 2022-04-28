library(sf)
library(sfdep)
library(tidyverse)

# read in data as sf object
boston <- read_sf("data/boston.geojson")

# Looks fairly normally distributed
# no obvious outliers
boston |> 
  ggplot(aes(bach)) +
  geom_histogram(bins = 15)

# How is education distributed across census tracts? 
# appears to be higher concentrations of education in some places
# East Boston and Roxbury looks like concentrations of low edu attainment
boston |> 
  ggplot(aes(fill = bach)) + 
  geom_sf(color = "black", lwd = 0.2) +
  labs(title = "Educational Attainment in Boston")

# Is there any spatial autocorrelation?
# create neighbors and weights
bos_nb <- boston |> 
  mutate(nb = st_contiguity(geometry),
         wt = st_weights(nb))

# Calculate global moran
# ~ .6 Moran's I
# That's a lot of spatial autocorrelation! 
bos_nb |> 
  summarise(i = list(global_moran_perm(bach, nb, wt, nsim = 499))) |> 
  pull(i)

# What does the moran plot look like?
# some big outliers in the 4th and 2nd quadrant
bos_nb |> 
  mutate(bach_lag = st_lag(bach, nb, wt)) |> 
  ggplot(aes(bach, bach_lag)) +
  geom_point() +
  geom_vline(aes(xintercept = mean(bach)), lty = 2) +
  geom_hline(aes(yintercept = mean(bach_lag)), lty = 2) +
  geom_smooth(method = "lm")

# There is fair amount of spatial autocorrelation
# can we identify local clusters?
bos_nb |> 
  mutate(lisa = local_moran(bach, nb, wt)) |> 
  unnest(lisa) |> 
  ggplot(aes(fill = mean)) +
  geom_sf(color = "black", lwd = 0.2)

# this shows all plot regardless if they're "significant"
lisa_clusts <- bos_nb |> 
  transmute(lisa = local_moran(bach, nb, wt)) |> 
  unnest(lisa) |> 
  mutate(cluster = ifelse(p_ii <= 0.1, 
                          as.character(mean),
                          NA_character_)) |> 
  ggplot() +
  geom_sf(
    aes(fill = cluster),
    color = "grey40", lwd = 0.2) +
  scale_fill_discrete(na.value = NA) +
  theme_void()

lisa_clusts

# What neighborhoods are these in?
# read in boston neighborhoods
bos_neighborhoods <- read_sf("data/neighborhoods.geojson")

gg <- lisa_clusts +
  geom_sf(data = bos_neighborhoods,
          fill = NA,
          color = "black") +
  # add text label 
  geom_sf_text(data = bos_neighborhoods, aes(label = name), size = 3,
               check_overlap = TRUE)

# visualize with plotly to make it easier to explore and read names
plotly::ggplotly(gg)

# it looks like the historically minority/ lower income areas have significant L-L clusters
bos_nb |> 
  mutate(edu_inc_lc = local_c_perm(list(med_house_income, bach),
                                   nb, wt, scale = TRUE)) |> 
  unnest(edu_inc_lc) |> 
  mutate(cluster = ifelse(p_folded_sim <= 0.01, as.character(cluster), NA)) |> 
  ggplot(aes(fill = cluster)) +
  geom_sf()


