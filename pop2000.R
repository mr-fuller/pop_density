library(tidycensus)
library(tidyverse)
library(censusapi)
#census_api_key('b7da053b9e664586b9e559dba9e73780602f0aab')
key =Sys.getenv("CENSUS_API_KEY")
vintage = 2000
variable = "P001001"
name = "sf1"
region = "block group:*"


luc2000pop <- getCensus(name = name,
                        vintage = vintage,
                        key = key,
                        vars=variable,
                        region= region,
                        regionin = "state:39+county:095")

woo2000pop <- getCensus(name = name,
                        vintage = vintage,
                        key = key,
                        vars=variable,
                        region= region,
                        regionin = "state:39+county:173")

mon2000pop <- getCensus(name = name,
                        vintage = vintage,
                        key = key,
                        vars=variable,
                        region= region,
                        regionin = "state:26+county:115")

tmacog2000pop <- rbind(luc2000pop,woo2000pop,mon2000pop)


tmacog2000features <- rbind_tigris(block_groups("OH",county = c("Lucas","Wood"),year = 2000,cb = TRUE),
                                   block_groups("MI",county = "Monroe", cb = TRUE,year = 2000))
#merge(tmacog1990features,tmacog1990pop)
tmacog2000pop$geoid = paste(tmacog2000pop$state,
                            tmacog2000pop$county,
                            tmacog2000pop$tract,
                            tmacog2000pop$block.group,
                            sep = "")
tmacog2000features@data$GEOID = paste(tmacog2000features@data$STATE,
                                      tmacog2000features@data$COUNTY,
                                      tmacog2000features@data$TRACT,
                                      tmacog2000features@data$BLKGROUP,
                                      sep = "")

tmacog_joined2000 <- geo_join(tmacog2000features,tmacog2000pop,"GEOID","geoid")
#plot(block_groups("OH",county = c("Lucas","Wood"),year = 1990,cb = TRUE))
tm_shape(tmacog_joined2000) +tm_fill(variable,style = "quantile", n = 5, palette = "Purples")+
  tm_layout(bg.color = "ivory",
            title = "TMACOG Region Population Density 2000\nby Census Block Group",
            title.position = c("center","top"), title.size = 1.1,
            legend.position = c(0.85,0), legend.text.size = 0.75,
            legend.width = 0.2)+
  tm_credits(("Data source: US Census Bureau"))