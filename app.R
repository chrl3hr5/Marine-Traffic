# Loading libraries
library(shiny) # For creating R Shiny web app
library(shiny.semantic) # For advance UI options
library(tidyverse) # For data manipulation and analysis
library(geosphere) # For calculating distance between coordindates

# Sourcing external R scripts
source("load_data.R") # For loading data
source("vessel.R") # For executing shiny module to select vessel type and name
source("distance.R") # For calculating the distance traveled by a vessel (in m)

# User Interface (UI)
ui <- semanticPage(
  # Executing UI from vessel module
  VesselUI("vessel", Data),
  # Executing UI from distance module
  DistanceUI("distance")
)

# Server
server <- function(session, input, output) {
  # Calling server from vessel module
  `Vessel Data` <- callModule(VesselServer, "vessel", Data)
  # Calculating the distance traveled by the selected vessel
  callModule(DistanceServer, "distance", Data, `Vessel Data`)
}

# Application
shinyApp(ui = ui, server = server)