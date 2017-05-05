## @knitr libraries
library(googlesheets); library(tidyverse); 
library(leaflet); library(RCurl); library(lubridate)


## @knitr load 
gLog <- read_csv("./data/gas_log_data.csv")

## @knitr desc

# check data frame
glimpse(gLog)



## @knitr plotTotalMiles

# Total miles driven as a function of time 
ggplot(gLog, aes(x = date, y = milesDrivenTotal, 
				 color = monthName, size = milesDrivenTank)) + 
	geom_point()

ggplot(gLog, aes(x = date, y = milesDrivenTank, color = pricePerGallon)) + 
	geom_point()


## @knitr plot
# plot it
leaflet(data = gLog, width = 910, height = 500) %>% 
  setView(lat = 40, lng = -74, zoom = 8) %>%
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, popup = ~as.character(location))

## @knitr plotMobile
# plot it
leaflet(data = gLog, width = 350, height = 450) %>% 
  setView(lat = 40, lng = -74, zoom = 8) %>%
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, popup = ~as.character(location))

## @knitr table
library(DT)
gLog %>% 
	datatable(callback = JS("return table;"))

