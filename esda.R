library(sf)
library(sfdep)
library(tidyverse)

boston <- read_sf("data/boston.geojson")

boston |> 
  ggplot(aes(fill = bach)) + 
  geom_sf(color = "black", lwd = 0.2) +
  labs(title = "Educational Attainment in Boston")

bos_nb <- boston |> 
  mutate(nb = st_contiguity(geometry),
         wt = st_weights(nb),
         n_nbs = st_cardinalties(nb))

bos_nb |> 
  ggplot(aes(n_nbs)) +
  geom_bar()

bos_nb |> 
  ggplot(aes(bach)) +
  geom_histogram(bins = 15)

bos_nb |> 
  mutate(bach_lag = st_lag(bach, nb, wt)) |> 
  ggplot(aes(bach, bach_lag)) +
  geom_point() +
  geom_vline(aes(xintercept = mean(bach)), lty = 2) +
  geom_hline(aes(yintercept = mean(bach_lag)), lty = 2)


bos_nb |> 
  as_tibble() |> 
  summarise(moran = list(global_moran_perm(bach, nb, wt))) |> 
  pull(moran)

# There is fair amount of spatial autocorrelation
# can we identify local clusters?
bos_nb |> 
  transmute(lisa = local_moran(bach, nb, wt)) |> 
  unnest(lisa) |> 
  ggplot(aes(fill = mean)) +
  geom_sf(color = "black", lwd = 0.2)

# this shows all plot regardless if they're "significant"
bos_nb |> 
  transmute(lisa = local_moran(bach, nb, wt)) |> 
  unnest(lisa) |> 
  mutate(cluster = ifelse(p_ii <= 0.1, 
                          as.character(mean),
                          NA_character_)) |> 
  ggplot(aes(fill = cluster)) +
  geom_sf(color = "black", lwd = 0.2)
