library(tidycensus)
library(tidyverse)
library(censusapi)
library(tigris)
library(tmap)
library(sf)
library(lwgeom)
library(gdal)
#census_api_key('b7da053b9e664586b9e559dba9e73780602f0aab')
key =Sys.getenv("CENSUS_API_KEY")
vintage = 2010
variable = "P001001"
name = "sf1"
region = "block group"
dsn <- "C:/Users/fullerm/Documents/TIMS/tims_gdb_datasets_20170314-1110/Road Inventory.gdb/Output.gdb"
roads <-  readOGR(dsn,"Road_Inventory")
luc_woo_roads <- roads[(roads$COUNTY_CD == "LUC" | roads$COUNTY_CD =="WOO") & roads$FUNCTION_CLASS < 4, ]



luc2010pop <- get_decennial(geography = region,
                            variables = variable,
                            year = vintage,
                            state = "39",
                            county = "095",
                            key = key,
                            geometry = TRUE)

woo2010pop <- get_decennial(geography = region,
                            variables = variable,
                            year = vintage,
                            state = "39",
                            county = "173",
                            key = key,
                            geometry = TRUE)

mon2010pop <- get_decennial(geography = region,
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
tmacog2010pop <- tmacog2010pop %>%
  mutate(sq_mi = (st_area(geometry)/2589988)) %>%
  mutate(pop_density = round(as.double(P0010001/sq_mi)))

tm_shape(tmacog2010pop, projection = 3734, unit = "mi") +
  tm_polygons("pop_density", 
              breaks = c(-Inf,500,1000,5000,10000,Inf), 
              palette = "Purples",
              title ="Persons per \nSquare Mile")+
  tm_shape(luc_woo_roads, projection =  3734)+
  tm_lines(col = 'black')+
  tm_layout(bg.color = "ivory",
            title = "2010 Population Density by Census Block Group 
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