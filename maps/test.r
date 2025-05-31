library(sf)
library(stringr)
library(dplyr)
library(ggplot2)
library(maps)


library(maps)
data(package = "maps")  # This will show you the available datasets (maps) in the package.

library(rnaturalearth)
data(package = "rnaturalearth")

library(rnaturalearthdata)
data(package = "rnaturalearthdata")

library(sf)
library(ggplot2)
library(ggthemes)
theme_set(theme_bw())

wales <- read_sf("Counties/Counties_and_Unitary_Authorities_(December_2016)_Boundaries.shp") |> 
  filter(str_detect(ctyua16cd, "^W"))

ggplot(wales) +
  geom_sf()



ceredigion_towns <- data.frame(town = c("Aberystwyth", "Aberaeron", "Aberteifi", "Llambed", "Tregaron", "Llandysul", "Pontarfynach"), lat = c(52.4143, 52.2426, 52.0860, 52.1150, 52.2140, 52.0402, 52.3770), long = c(-4.0819, -4.2603, -4.6600, -4.0794, -3.9488, -4.3087, -3.8497))
# coordinates from chatgpt so check they look OK

rivers <- read_sf(dsn = "nrw_wfd_river_waterbodies_c2_ij99/nrw_wfd_river_waterbodies_c2_ij99.shp") |> 
  filter(catchment == "Teifi and North Ceredigion") |> 
  rename(Status = overallsta)


ggplot(wales) +
  geom_sf(fill = "green", alpha = 0.1) +
  geom_sf(data = rivers, aes(colour = Status)) +
  scale_colour_manual(values = c("green", "orange", "red")) +
  coord_sf(ylim = c(51.95, 52.55), xlim = c(-5, -3.5)) +
  geom_point(data = ceredigion_towns, mapping = aes(long, lat)) +
  geom_text(ceredigion_towns, mapping = aes(long, lat, label = town), hjust = "left", nudge_x = 0.02, size = 3) +
  ggthemes::theme_map() +
  labs(title = "Overall status of Ceredigion's rivers",
       subtitle = "NRW March 2023 (Publication date)",
       caption = "https://datamap.gov.wales/layers/geonode:nrw_wfd_river_waterbodies_c2_ij99") +
  theme(legend.position = c(0, 0.5))