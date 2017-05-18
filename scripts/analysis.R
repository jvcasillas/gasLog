## @knitr libraries
library(googlesheets); library(tidyverse); library(DT)
library(leaflet); library(RCurl); library(lubridate)


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



## @knitr plotMaps
# plot it
leaflet(data = gLog, width = 910, height = 500) %>% 
  setView(lat = 36, lng = -88, zoom = 4) %>%
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, popup = ~as.character(location))


## @knitr table
gLog %>% 
	datatable(callback = JS("return table;"))

