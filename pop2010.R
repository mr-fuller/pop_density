library(tidycensus)
library(tidyverse)
library(censusapi)
#census_api_key('b7da053b9e664586b9e559dba9e73780602f0aab')
key =Sys.getenv("CENSUS_API_KEY")
vintage = 2010
variable = "P0010001"
name = "sf1"
region = "block group:*"


luc2010pop <- getCensus(name = name,
                        vintage = vintage,
                        key = key,
                        vars=variable,
                        region= region,
                        regionin = "state:39+county:095")

woo2010pop <- getCensus(name = name,
                        vintage = vintage,
                        key = key,
                        vars=variable,
                        region= region,
                        regionin = "state:39+county:173")

mon2010pop <- getCensus(name = name,
                        vintage = vintage,
                        key = key,
                        vars=variable,
                        region= region,
                        regionin = "state:26+county:115")

tmacog2010pop <- rbind(luc2010pop,woo2010pop,mon2010pop)


tmacog2010features <- rbind_tigris(block_groups("OH",county = c("Lucas","Wood"),year = 2010,cb = TRUE),
                                   block_groups("MI",county = "Monroe", cb = TRUE,year = 2010))
#merge(tmacog1990features,tmacog1990pop)
tmacog2010pop$geoid = paste(tmacog2010pop$state,
                            tmacog2010pop$county,
                            tmacog2010pop$tract,
                            tmacog2010pop$block.group,
                            sep = "")
tmacog2010features@data$GEOID = paste(tmacog2010features@data$STATE,
                                      tmacog2010features@data$COUNTY,
                                      tmacog2010features@data$TRACT,
                                      tmacog2010features@data$BLKGROUP,
                                      sep = "")

tmacog_joined2010 <- geo_join(tmacog2010features,tmacog2010pop,"GEOID","geoid")
#plot(block_groups("OH",county = c("Lucas","Wood"),year = 1990,cb = TRUE))
tm_shape(tmacog_joined) +tm_fill("P0010001",style = "quantile", n = 5, palette = "Purples")+
  tm_layout(bg.color = "ivory",
            title = "TMACOG Region Population Density 2010\nby Census Block Group",
            title.position = c("center","top"), title.size = 1.1,
            legend.position = c(0.8,0), legend.text.size = 0.75,
            legend.width = 0.2)+
  tm_credits(("Data source: US Census Bureau"))