# Referencia: https://ggplot2tutor.com/streetmaps/streetmaps/ 
library(tidyverse)
library(osmdata)


# Conseguir coordenadas para ggplot
city <- "provincia de santiago"
country <- "chile"

mapping <- paste(city,country, sep = " ")

getbb(mapping)
coords <- getbb(mapping)

# Extraer lugares del mapa
streets <- getbb(mapping) %>%
  opq() %>%
  add_osm_feature(key = "highway", value = c("motorway", "primary", "secondary", "tertiary")) %>%
  osmdata_sf()

small_streets <- getbb(mapping) %>%
  opq() %>%
  add_osm_feature(key = "highway", value = c("residential", "living_street", "unclassified", "service", "footway")) %>%
  osmdata_sf()

river <- getbb(mapping) %>%
  opq() %>%
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()

ggplot() +
  # Calles
  geom_sf(data = streets$osm_lines, inherit.aes = FALSE, color = "#000000", size = .4, alpha = .8) +
  # Pequeñas calles
  geom_sf(data = small_streets$osm_lines, inherit.aes = FALSE, color = "#000000", size = .2, alpha = .8) +
  # Ríos
  geom_sf(data = river$osm_lines, inherit.aes = FALSE, color = "#000000", size = 1, alpha = 1) +
  # Límites del mapa en coordenadas
  coord_sf(xlim = c(coords[1], coords[3]), ylim = c(coords[2], coords[4]), expand = FALSE) +
  
  theme_void() + 
  # Añadir color de fondo
  theme(plot.background = element_rect(fill = "#ffffff"))

# Exportación de mapa
ggsave(paste0(city,".png"), height = 27.9, width = 43.1, dpi = 300, units = "cm")
