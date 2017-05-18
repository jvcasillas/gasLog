## @knitr libraries
library(googlesheets); library(tidyverse); library(DT)
library(leaflet); library(RCurl); library(lubridate)
library(ggmap)

## @knitr load 
gLog <- read_csv("./data/gas_log_data.csv")

## @knitr desc

# check data frame
glimpse(gLog)



## @knitr plotTotalMiles

# Total miles driven as a function of time 
gLog %>%
  na.omit() %>%
  ggplot(., aes(x = date, y = milesDrivenTotal, 
				color = monthName, size = milesDrivenTank)) + 
	geom_point() + 
	theme_bw()

ggplot(gLog, aes(x = date, y = milesDrivenTank, color = pricePerGallon)) + 
	geom_point() + 
	theme_bw()



## @knitr plotMapUS1

leaflet(data = gLog, width = 910, height = 500) %>% 
  setView(lat = 36, lng = -88, zoom = 4) %>%
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, popup = ~as.character(location))

## @knitr plotMapUS2

usa_center <- as.numeric(geocode("United States"))
USAMap <- get_googlemap(center = usa_center, scale = 1, zoom = 4)

ggmap(USAMap, extent = "panel") + 
  stat_density2d(data = gLog, 
    aes(x = Longitude, y = Latitude, fill=..level.., alpha=..level..),
                              geom = "polygon", size = 0.01, bins = 10) + 
  scale_fill_gradient(low = "red", high = "green") +
  scale_alpha(range = c(0, 0.3), guide = FALSE) + 
  coord_fixed(0.95) + 
  theme_minimal()

## @knitr plotMapNJ1

jersey_center <- as.numeric(geocode("Highland Park, New Jersey"))
NJMap <- get_googlemap(center = jersey_center, scale = 1, zoom = 8)

ggmap(NJMap, extent = "panel") + 
  geom_point(aes(x = Longitude, y = Latitude), data = gLog, 
             col = "blue", alpha = 0.4, 
             size = gLog$pricePerGallon) + 
  scale_size_continuous(range = range(gLog$pricePerGallon)) +
  coord_fixed(1.1) + 
  theme_minimal()





## @knitr table
#gLog %>% 
#	datatable(callback = JS("return table;"))

gLog %>% 
	select(., date, location, milesDrivenTank:totalPrice) %>%
	knitr::kable(.)



## @knitr myMPG

gLog %>%
  na.omit() %>% 
  select(., date, milesDrivenTank, gallonsPurchased) %>%
  mutate(., mpg = milesDrivenTank / gallonsPurchased) %>%
  ggplot(., aes(x = date, y = mpg)) + 
    geom_path()

