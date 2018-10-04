library(tidycensus)
library(tidyverse)
library(censusapi)
library(tigris)
library(tmap)
library(sf)
library(lwgeom)
census_api_key('b7da053b9e664586b9e559dba9e73780602f0aab')
key =Sys.getenv("CENSUS_API_KEY")
vintage = 1990
variable = "P0010001"
name = "sf1"
region = "tract"
# note the census api has an issue with block groups for the time being for the 1990 vintage



luc1990pop <- get_decennial(geography = region,
                            variables = variable,
                            year = vintage,
                            state = "39",
                            county = "095",
                            key = key,
                            geometry = TRUE)

woo1990pop <- get_decennial(geography = region,
                            variables = variable,
                            year = vintage,
                            state = "39",
                            county = "173",
                            key = key,
                            geometry = TRUE)

mon1990pop <- get_decennial(geography = region,
                            variables = variable,
                            year = vintage,
                            state = "26",
                            county = "115",
                            key = key,
                            geometry = TRUE)
mon1990pop <- mon1990pop %>% 
  filter(grepl("26115833", GEOID, fixed = TRUE)) %>%
  spread(variable, value)
luc1990pop <- luc1990pop %>%
  spread(variable,value)
woo1990pop <- woo1990pop %>%
  spread(variable,value)

tmacog1990pop <- rbind(luc1990pop,woo1990pop,mon1990pop) 

tmacog1990pop <- tmacog1990pop %>%
  mutate(sq_mi = (st_area(geometry)/2589988)) %>%
  mutate(pop_density = round(as.double(P0010001/sq_mi)))
 

tm_shape(tmacog1990pop, projection = 3734, unit = "mi") +
  tm_polygons("pop_density", 
              breaks = c(-Inf,500,1000,5000,10000,Inf), 
              palette = "Purples",
              title ="Persons per \nSquare Mile")+
  tm_layout(bg.color = "ivory",
            title = "1990 Population Density by Census Block Group 
            Lucas, Monroe, and Wood Counties",
            title.position = c("center","top"), title.size = 1.1,
            legend.position = c("right","center"), legend.text.size = 0.75,
            legend.width = 0.25,
            inner.margins = c(0.1,0.1,0.1,0.1)
            )+
  tm_scale_bar(width = .2)+
  tm_compass(type = "4star", position = c("right","top"))+
  tm_credits(text = "Data source: US Census Bureau \nDate: 10/04/2018", 
              align = "right")
