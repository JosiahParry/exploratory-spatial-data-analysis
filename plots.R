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
  

