# clean working directory
rm(list = ls(all = TRUE))

# Set working directory
setwd("~/code/r/gasLog/")

## @knitr libraries
library(googlesheets); library(tidyverse); 
library(leaflet); library(RCurl); library(lubridate)


## @knitr getData

# scrape travel log data
# Access google sheets
(my_sheets <- gs_ls())
glimpse(my_sheets)

# Identify sheet
gLogIdent    <- gs_title("gasLog (Responses)")
gLogOldIdent <- gs_title("gas_log_data_old")

# Read sheet into DF
gLog <- gLogIdent %>%
  gs_read(ws = "Form Responses 1")

gLogOld <- gLogOldIdent %>%
  gs_read(ws = "gas_log_data_old.csv")


# general tidying
my_months <- c("1" = "jan", 
               "2" = "feb", 
			   "3" = "march", 
			   "4" = "april", 
			   "5" = "may", 
			   "6" = "june", 
			   "7" = "july", 
			   "8" = "aug", 
			   "9" = "sept", 
			   "10" = "oct", 
			   "11" = "nov", 
			   "12" = "dec")

gLog <- gLog %>% 
          mutate(., 
                 date = mdy(gLog$date), 
                 time = hms(gLog$time), 
                 monthNum = as.numeric(substr(date, start = 6, stop = 7)), 
                 monthName = my_months[monthNum], 
                 year = as.numeric(substr(date, start = 1, stop = 4)))

gLogOld <- gLogOld %>%
            mutate(., 
                   date = mdy(gLogOld$date), 
                   monthNum = as.numeric(substr(date, start = 6, stop = 7)), 
                   monthName = my_months[monthNum], 
                   year = as.numeric(substr(date, start = 1, stop = 4)))

glimpse(gLog)
glimpse(gLogOld)

gLogFinal <- rbind(gLogOld, gLog)

# write table
write.table(gLogFinal, "./data/gas_log_data.csv", row.names = F, quote = T, sep = ",")
