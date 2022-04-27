#' # Plots for Slides
#' 
library(sf)
library(spdep)
library(sfdep)
library(tidyverse)


# Chess board -------------------------------------------------------------
chess_board <- expand.grid(x = 1:8, y = 1:8) %>% 
mutate(z = ifelse((x + y) %% 2 == 0, TRUE, FALSE))

board <- chess_board %>% 
  ggplot(aes(x, y, fill = z)) + 
  geom_tile() +
  scale_fill_manual(values = c("white", "grey20")) +
  theme_void() +
  coord_fixed() +
  theme(legend.position = "none") +
  theme_void()

board


chess_sf <- chess_board %>% 
  st_as_sf(coords = c("x", "y")) %>% 
  st_make_grid(n = 8) %>% 
  st_sf() %>% 
  mutate(color = pull(chess_board, z))

boardsf <- ggplot(chess_sf, aes(fill = color)) + 
  geom_sf() + 
  scale_fill_manual(values = c("white", "grey20")) +
  theme_void() +
  theme(legend.position = "none")

# contiguities ------------------------------------------------------------


# Create chess board neighbors
chess_nb_q <- poly2nb(chess_sf)
chess_nb_r <- poly2nb(chess_sf, queen = FALSE)

neighbors_tidy <- nb2lines(chess_nb_q, coords = st_geometry(chess_sf), as_sf = TRUE)
neighbors_tidy_r <- nb2lines(chess_nb_r, coords = st_geometry(chess_sf), as_sf = TRUE)

queen_gg <- ggplot() +
  geom_sf(data = chess_sf, aes(fill = color)) + 
  geom_sf(data = neighbors_tidy, color = "#ffce40") +
  scale_fill_manual(values = c("white", "grey20")) +
#  labs(title = "Queen Contiguities") +
  theme_void() +
  theme(legend.position = "none")


rook_gg <- ggplot() +
  geom_sf(data = chess_sf, aes(fill = color)) + 
  geom_sf(data = neighbors_tidy_r, color = "#ffce40") +
  scale_fill_manual(values = c("white", "grey20")) +
#  labs(title = "Rook Contiguities") +
  theme_void() +
  theme(legend.position = "none")

rook_gg

# Contiguity of the Queen's Gambit ----------------------------------------

# 1. d4

# queen contiguity
board +
  geom_point(data = slice(chess_board, chess_nb_q[[28]]),
             color= "#ffce40",
              size = 5) +
  geom_point(data = slice(chess_board, 28), 
             color = "white",
             size = 5) +
  # labs(title = "Queen's Gambit: Queen contiguity") +
  theme(legend.position = "none")
  

# queen contiguity
board +
  geom_point(data = slice(chess_board, chess_nb_r[[28]]), 
             color= "#ffce40",
             size = 5) +
  geom_point(data = slice(chess_board, 28),
             color = "white",
             size = 5) +
  #labs(title = "Queen's Gambit: Rook contiguity")
  theme(legend.position = "none")
  

# Spatial Lag -------------------------------------------------------------


chess_nb <- chess_sf |> 
  mutate(x = 1:64, 
         nb = st_contiguity(geometry),
         wt = st_weights(nb),
         x_lag = st_lag(x, nb, wt))

chess_nb |> 
  ggplot(aes(fill = x)) + 
  geom_sf(color = "black", lwd = 0.2) +
  theme_void() +
  geom_sf_text(aes(label = x), color = "white") +
  scale_fill_continuous(limits = c(0, 64))


chess_nb |> 
  ggplot(aes(fill = x_lag)) + 
  geom_sf(color = "black", lwd = 0.2) +
  theme_void() +
  geom_sf_text(aes(label = round(x_lag, 1)), color = "white") +
  scale_fill_continuous(limits = c(0, 64))

# spatial lag in guerry
guerry_nb |> 
  ggplot(aes(fill = crime_pers)) + 
  geom_sf(color = "black", lwd = 0.2) +
  theme_void() +
  scale_fill_continuous(limits = c(range(guerry$crime_pers)))

guerry_nb |> 
  mutate(crime_lag = st_lag(crime_pers, nb, wt)) |> 
  ggplot(aes(fill = crime_lag)) + 
  geom_sf(color = "black", lwd = 0.2) +
  theme_void() + 
  scale_fill_continuous(limits = c(range(guerry$crime_pers)))


  

# Moran Plot --------------------------------------------------------------

  
crime_lag <- guerry_nb |> 
  mutate(crime_lag = st_lag(crime_pers, nb, wt)) 

# basic plot
crime_lag |> 
  ggplot(aes(crime_pers, crime_lag)) +
  geom_point() +
  geom_vline(aes(xintercept = mean(crime_pers)), lty = 2) +
  geom_hline(aes(yintercept = mean(crime_lag)), lty = 2) +
  theme_light()

# categorize the plot
# helper function
categorize_lisa <- function(x, x_lag, scale = TRUE) {
  
  cats <- character(length(x))
  
  if (scale) {
    x <- scale(x)
    x_lag <- scale(x_lag)
    
    cats[x > 0 & x_lag > 0] <- "HH"
    cats[x > 0 & x_lag < 0] <- "HL"
    cats[x < 0 & x_lag < 0] <- "LL"
    cats[x < 0 & x_lag > 0] <- "LH"
    
  }
  
  cats[x > mean(x) & x_lag > mean(x_lag)] <- "HH"
  cats[x > mean(x) & x_lag < mean(x_lag)] <- "HL"
  cats[x < mean(x) & x_lag < mean(x_lag)] <- "LL"
  cats[x < mean(x) & x_lag > mean(x_lag)] <- "LH"
  cats[cats == ""] <- NA
  cats
}

 
# Moran plot with cluster categories
crime_lag |> 
  mutate(categories = categorize_lisa(crime_pers, crime_lag)) |> 
  ggplot(aes(crime_pers, crime_lag, color = categories)) +
  geom_point() +
  geom_vline(aes(xintercept = mean(crime_pers)), lty = 2) +
  geom_hline(aes(yintercept = mean(crime_lag)), lty = 2) +
  theme_light()

# moran plot with autocorrelation slope
crime_lag |> 
  mutate(categories = categorize_lisa(crime_pers, crime_lag)) |> 
  ggplot(aes(crime_pers, crime_lag, color = categories)) +
  geom_point() +
  geom_vline(aes(xintercept = mean(crime_pers)), lty = 2) +
  geom_hline(aes(yintercept = mean(crime_lag)), lty = 2) +
  geom_smooth(method = "lm", color = "grey40") +
  theme_light()

# Inference ---------------------------------------------------------------



  