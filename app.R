# Loading libraries
library(data.table) # For reading data
library(feather) # For reading and storing data
library(shiny) # For creating R Shiny web app
library(shiny.semantic) # For advance UI options
library(tidyverse) # For data manipulation and analysis
library(geosphere) # For calculating distance between coordinates (in meters)
library(leaflet) # For creating maps
library(maptools) # For shape files

# Sourcing external R scripts
source("external/load_data.R") # For loading data
source("external/load_polygons.R") # For loading world polygons
source("modules/vessel.R") # For selecting vessel type and name
source("modules/distance.R") # For calculating the distance traveled by a vessel (in meters)
source("modules/map.R") # For creating a map to display vessel positions

# User Interface (UI)
ui <- semanticPage(
  # Executing UI from "Vessel" module
  VesselUI("vessel", Data),
  # Executing UI from "Distance" module
  DistanceUI("distance"),
  # Executing UI from "Map" module
  MapUI("map")
)

# Server
server <- function(session, input, output) {
  # Calling server from "Vessel" module
  `Vessel Data` <- callModule(VesselServer, "vessel", Data)
  # Calling server from "Distance" module
  callModule(DistanceServer, "distance", Data, `Vessel Data`)
  # Calling server from "Map" module
  callModule(MapServer, "map", Data, `Vessel Data`, wrld_simpl)
}

# Application
shinyApp(ui = ui, server = server)