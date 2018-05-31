library(tidycensus)
library(tidyverse)
library(censusapi)
library(tigris)
library(tmap)
census_api_key('b7da053b9e664586b9e559dba9e73780602f0aab')
key =Sys.getenv("CENSUS_API_KEY")



luc1990pop <- getCensus(name = "sf3",
                        vintage = 1990,
                        key = key,
                        vars="P0010001",
                        region= "block group:*",
                        regionin = "state:39+county:095")

woo1990pop <- getCensus(name = "sf3",
                        vintage = 1990,
                        key = key,
                        vars="P0010001",
                        region= "block group:*",
                        regionin = "state:39+county:173")

mon1990pop <- getCensus(name = "sf3",
                        vintage = 1990,
                        key = key,
                        vars="P0010001",
                        region= "block group:*",
                        regionin = "state:26+county:115")
mon1990pop$tract = paste(as.integer(mon1990pop$tract),"00",sep ="")

tmacog1990pop <- rbind(luc1990pop,woo1990pop,mon1990pop)
tmacog1990pop$tract = as.integer(tmacog1990pop$tract)
tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 1] = paste("000",
                                                             tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 1],
                                                             "00",sep = "")
tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 2] = paste("00",
                                                             tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 2],
                                                             "00",sep = "")

tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 3] = paste("0",
                                                             tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 3],
                                                             "00",sep = "")

tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 4] = paste("00",
                                                             tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 4],
                                                             sep = "")

tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 5] = paste("0",
                                                             tmacog1990pop$tract[nchar(tmacog1990pop$tract) == 5],
                                                             sep = "")




tmacog1990features <- rbind_tigris(block_groups("OH",county = c("Lucas","Wood"),year = 1990,cb = TRUE),
                            block_groups("MI",county = "Monroe", cb = TRUE,year = 1990))
#merge(tmacog1990features,tmacog1990pop)
tmacog1990pop$geoid = paste(tmacog1990pop$state,
                            tmacog1990pop$county,
                            tmacog1990pop$tract,
                            tmacog1990pop$block.group,
                            sep = "")

tmacog_joined <- geo_join(tmacog1990features,tmacog1990pop,"GEOID","geoid")
#plot(block_groups("OH",county = c("Lucas","Wood"),year = 1990,cb = TRUE))
tm_shape(tmacog_joined) +tm_fill("P0010001",style = "quantile", n = 5, palette = "Purples")+
  tm_layout(bg.color = "ivory",
            title = "TMACOG Region Population Density by Census Block Group",
            title.position = c("center","top"), title.size = 1.1,
            legend.position = c(0.85,0), legend.text.size = 0.75,
            legend.width = 0.2)+
  tm_credits(("Data source: US Census Bureau"))