library(tidycensus)
library(tidyverse)
library(censusapi)
library(tigris)
library(tmap)
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


tm_shape(tmacog1990pop) +tm_fill("P0010001",style = "quantile", n = 5, palette = "Purples",title ="Population")+
  tm_layout(bg.color = "ivory",
            title = "TMACOG Region Population Density by Census Block Group",
            title.position = c("center","top"), title.size = 1.1,
            legend.position = c(0.85,0), legend.text.size = 0.75,
            legend.width = 0.2)+
  tm_scale_bar()+
  tm_credits(("Data source: US Census Bureau"))