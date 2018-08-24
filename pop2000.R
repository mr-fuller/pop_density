library(tidycensus)
library(tidyverse)
library(censusapi)
library(tmap)
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



tm_shape(tmacog2000pop) +tm_fill(variable,style = "quantile", n = 5, palette = "Purples", title = "Population")+
  tm_layout(bg.color = "ivory",
            title = "TMACOG Region Population Density 2000\nby Census Block Group",
            title.position = c("center","top"), title.size = 1.1,
            legend.position = c(0.85,0), legend.text.size = 0.75,
            legend.width = 0.2)+
  tm_scale_bar()+
  tm_credits(("Data source: US Census Bureau"))