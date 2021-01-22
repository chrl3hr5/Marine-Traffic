# Loading libraries
library(shiny) # For creating R Shiny web app
library(shiny.semantic) # For advance UI options
library(tidyverse) # For data manipulation and analysis

# Sourcing external R scripts
source("data.R") # For loading data
source("vessel.R") # For selecting vessel type and name

# User Interface (UI)
ui <- semanticPage(
  VesselUI("vessel", Data)
)

# Server
server <- function(session, input, output) {
  callModule(VesselServer, "vessel", Data)
}

# Application
shinyApp(ui = ui, server = server)