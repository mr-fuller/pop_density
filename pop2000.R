library(tidycensus)
library(tidyverse)
library(censusapi)
library(tmap)
library(sf)
library(lwgeom)
#census_api_key('b7da053b9e664586b9e559dba9e73780602f0aab')
key =Sys.getenv("CENSUS_API_KEY")
vintage = 2000
variable = "P001001"
name = "sf1"
region = "block group"


luc2000pop <- get_decennial(geography = region,
                            variables = variable,
                            year = vintage,
                            state = "39",
                            county = "095",
                            key = key,
                            geometry = TRUE)

woo2000pop <- get_decennial(geography = region,
                            variables = variable,
                            year = vintage,
                            state = "39",
                            county = "173",
                            key = key,
                            geometry = TRUE)

mon2000pop <- get_decennial(geography = region,
                            variables = variable,
                            year = vintage,
                            state = "26",
                            county = "115",
                            key = key,
                            geometry = TRUE)
mon2000pop <- mon2000pop %>% 
  filter(grepl("26115833", GEOID, fixed = TRUE)) %>%
  spread(variable, value)
luc2000pop <- luc2000pop %>%
  spread(variable,value)
woo2000pop <- woo2000pop %>%
  spread(variable,value)

tmacog2000pop <- rbind(luc2000pop,woo2000pop,mon2000pop)

tmacog2000pop <- tmacog2000pop %>%
  mutate(sq_mi = (st_area(geometry)/2589988)) %>%
  mutate(pop_density = round(as.double(P001001/sq_mi)))


tm_shape(tmacog2000pop, projection = 3734, unit = "mi") +
  tm_polygon(variable,
    breaks = c(-Inf,500,1000,5000,10000,Inf),
    palette = "Purples", 
    title = "Persons per Square Mile")+
  
  tm_layout(bg.color = "ivory",
            title = "2000 Population Density by Census Block Group 
            Lucas, Monroe, and Wood Counties",
            title.position = c("center","top"), title.size = 1.1,
            legend.position = c("right","center"), legend.text.size = 0.75,
            legend.width = 0.25,
            inner.margins = c(0.1,0.1,0.1,0.1)
            )+
  tm_scale_bar(width = 0.2)+
  tm_compass(type = "4star", position = c("right","top"))+
  tm_credits(text = "Data source: US Census Bureau \nDate: 10/04/2018", 
             align = "right")