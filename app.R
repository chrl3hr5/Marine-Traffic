# Loading libraries
library(shiny) # For creating R Shiny web app
library(shiny.semantic) # For advance UI options
library(tidyverse) # For data manipulation and analysis
library(geosphere) # For calculating distance between coordinates

# Sourcing external R scripts
source("load_data.R") # For loading data
source("vessel.R") # For executing shiny module to select vessel type and name
source("distance.R") # For calculating the distance traveled by a vessel

# User Interface (UI)
ui <- semanticPage(
  # Executing UI from "Vessel" module
  VesselUI("vessel", Data),
  # Executing UI from "Distance" module
  DistanceUI("distance")
)

# Server
server <- function(session, input, output) {
  # Calling server from "Vessel" module
  `Vessel Data` <- callModule(VesselServer, "vessel", Data)
  # Calling server from "Distance" module
  callModule(DistanceServer, "distance", Data, `Vessel Data`)
}

# Application
shinyApp(ui = ui, server = server)