library(sf)
library(sfdep)
library(tidyverse)

# Slide Examples ----------------------------------------------------------
# spatial lag
xi <- 100
xj <- c(5, 40, 100, 35)
wj <- 1 / length(xj)
sum(xj * wj)

# Moran's I
library(sfdep)
x <- guerry_nb$crime_pers
nb <- guerry_nb$nb
wt <- guerry_nb$wt
global_moran(x, nb, wt)[["I"]]

x_lag <- st_lag(x, nb, wt)

lm(x_lag ~ x)


# Inference
observed_i <- global_moran(x, nb, wt)[["I"]]

listw <- sfdep:::recreate_listw(nb, wt)

sims_99 <- replicate(99, 
          spdep::moran(x, sfdep:::permute_listw(listw),
                       length(x), length(x))[["I"]])

sims_999 <- replicate(999, 
                     spdep::moran(x, sfdep:::permute_listw(listw),
                                  length(x), length(x))[["I"]])

sims_9999 <- replicate(9999, 
                      spdep::moran(x, sfdep:::permute_listw(listw),
                                   length(x), length(x))[["I"]])

g_99 <- data.frame(reference_dist = sims_99) |> 
  ggplot(aes(reference_dist)) +
  geom_histogram(bins = 20) +
  geom_vline(xintercept = observed_i, lty = 2) + 
  theme_light() +
  labs(caption = "99 simulations") +
  xlim(c(-.25, .45))

g_999 <- data.frame(reference_dist = sims_999) |> 
  ggplot(aes(reference_dist)) +
  geom_histogram(bins = 20) +
  geom_vline(xintercept = observed_i, lty = 2) + 
  theme_light() +
  labs(caption = "999 simulations") +
  xlim(c(-.25, .45))

g_9999 <- data.frame(reference_dist = sims_9999) |> 
  ggplot(aes(reference_dist)) +
  geom_histogram(bins = 20) +
  geom_vline(xintercept = observed_i, lty = 2) +
  theme_light() +
  labs(caption = "9999 simulations")+
  xlim(c(-.25, .45))


patchwork::wrap_plots(g_99, g_999, g_9999,
                      ncol = 1)

# Making neighbors --------------------------------------------------------

sf::st_geometry(guerry) |> 
  st_contiguity()

guerry |> 
  transmute(nb = st_contiguity(geometry)) |> 
  as_tibble()
