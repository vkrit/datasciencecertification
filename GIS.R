library(tidyverse)
library(leaflet)
library(stringr)
library(sf)
library(here)
library(widgetframe)

options(digits = 3)
set.seed(1234)
theme_set(theme_minimal())

m <- leaflet() %>%addTiles() %>% addMarkers(lng = 100.5293, lat = 13.7290,
             popup = "Sakulthai Tower")
m %>% frameWidget()

bangkok_shape <- here("./GIS/BMA_ADMIN_SUB_DISTRICT.shp") %>% st_read()

bangkok_shape


ggplot(data = bangkok_shape) + geom_sf()

leaflet(data = bangkok_shape) %>%
  addPolygons(color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE)) %>%
  frameWidget()

plot(st_geometry(bangkok_shape))

plot(st_geometry(bangkok_shape),
     col = sf.colors(12, categorical = TRUE), 
     border = 'grey',  axes = TRUE)

plot(bangkok_shape["AREA_BMA"], breaks = c(0,10,20,30,40,50,100))

ggplot() + 
  geom_sf(data = bangkok_shape, aes(fill = AREA_BMA)) 

cbind(select(bangkok_shape, "SUBDISTRIC", "DISTRICT_I"), 
      sample(20000:100000, nrow(bangkok_shape), replace=TRUE))
      
library(mapview)
mapview(bangkok_shape["AREA_BMA"], col.regions = sf.colors(10))

bangkok_shape_wgs84 <- st_transform(bangkok_shape, "+init=epsg:4326")

leaflet(data = bangkok_shape_wgs84) %>%
  addTiles() %>%
  addPolygons(label = ~SUBDISTR_1,
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE)) %>%
  frameWidget()

bins <- c(0, 100000, 1000000, 10000000, 100000000, 1000000000 Inf)
pal <- colorBin("RdYlBu", domain = bangkok_shape_wgs84$Shape_Area, 
                bins = bins)

bangkok_shape_wgs84 %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~SUBDISTR_1,
              fillColor = ~pal(Shape_Area),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE)) %>%
  frameWidget()


bangkok_shape_wgs84 %>%
  mutate(popup = str_c("<strong>", SUBDISTR_1, "</strong>",
                       "<br/>",
                       "Area : ", Shape_Area) %>%
           map(htmltools::HTML)) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~popup,
              fillColor = ~pal(Shape_Area),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE),
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) %>%
  addLegend(pal = pal,
            values = ~Shape_Area,
            opacity = 0.7,
            title = NULL,
            position = "bottomright") %>%
  frameWidget()
