library(tidycensus)
library(tidyverse)
library(censusapi)
library(tigris)
library(tmap)
#census_api_key('b7da053b9e664586b9e559dba9e73780602f0aab')
key =Sys.getenv("CENSUS_API_KEY")
vintage = 2010
variable = "P0010001"
name = "sf1"
region = "block group:*"


luc2010pop <- get_decennial(geography = "block group",
                            variables = variable,
                            year = vintage,
                            state = "39",
                            county = "095",
                            key = key,
                            geometry = TRUE)

woo2010pop <- get_decennial(geography = "block group",
                            variables = variable,
                            year = vintage,
                            state = "39",
                            county = "173",
                            key = key,
                            geometry = TRUE)

mon2010pop <- get_decennial(geography = "block group",
                            variables = variable,
                            year = vintage,
                            state = "26",
                            county = "115",
                            key = key,
                            geometry = TRUE)
mon2010pop <- mon2010pop %>% 
  filter(grepl("26115833", GEOID, fixed = TRUE)) %>%
  spread(variable, value)
luc2010pop <- luc2010pop %>%
  spread(variable,value)
woo2010pop <- woo2010pop %>%
  spread(variable,value)

tmacog2010pop <- rbind(luc2010pop,woo2010pop,mon2010pop)


tmacog2010features <- rbind_tigris(block_groups("OH",county = c("Lucas","Wood"),year = 2010,cb = TRUE),
                                   mon2010features
                                   )

tm_shape(tmacog2010pop) +tm_fill("P0010001",style = "quantile", n = 5, palette = "Purples",title = "Population")+
  tm_layout(bg.color = "ivory",
            title = "TMACOG Region Population Density 2010\nby Census Block Group",
            title.position = c("center","top"), title.size = 1.1,
            legend.position = c(0.8,0), legend.text.size = 0.75,
            legend.width = 0.2)+
  tm_scale_bar()+
  tm_credits(("Data source: US Census Bureau"))