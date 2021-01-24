# Loading libraries
library(data.table) # For reading data
library(feather) # For reading and storing data
library(shiny) # For creating R Shiny web app
library(shiny.semantic) # For advance UI options
library(semantic.dashboard) # For dashboard UI options
library(tidyverse) # For data manipulation and analysis
library(geosphere) # For calculating distance between coordinates (in meters)
library(leaflet) # For creating maps
library(maptools) # For shape files

# Sourcing external R scripts
source("external/load_data.R") # For loading data
source("external/load_polygons.R") # For loading world polygons
source("modules/vessel.R") # For selecting vessel type and name
source("modules/total_distance.R") # For calculating the distance traveled by a vessel (in meters)
source("modules/longest_distance.R") # For calculating the longest distance traveled by a vessel between consecutive observations (in meters)
source("modules/map.R") # For creating a map to display vessel positions

# Adding grid layout for the app
layout <- grid_template(default = list(
  areas = rbind(
    c("top"),
    c("top_left", "top_right"),
    c("top_left", "bottom_right")
  ),
  rows_height = c("10%", "60%", "10%"),
  cols_width = c("70%", "30%")
))

# User Interface (UI)
ui <- semanticPage(
  box(
    grid(layout,
      # Executing UI from "Total Distance" module
      top = Total_DistanceUI("distance"),
      # Executing UI from "Map" module
      top_left = MapUI("map"),
      # Executing UI from "Longest Distance" module
      top_right = VesselUI("vessel", Data),
      # Executing UI from "Vessel" module
      bottom_right = Longest_DistanceUI("distance")
    )
  )
)

# Server
server <- function(session, input, output) {
  # Calling server from "Vessel" module
  `Vessel Data` <- callModule(VesselServer, "vessel", Data)
  # Calling server from "Total Distance" module
  callModule(Total_DistanceServer, "distance", Data, `Vessel Data`)
  # Calling server from "Longest Distance" module
  callModule(Longest_DistanceServer, "distance", Data, `Vessel Data`)
  # Calling server from "Map" module
  callModule(MapServer, "map", Data, `Vessel Data`, wrld_simpl)
}

# Application
shinyApp(ui = ui, server = server)