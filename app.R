# Loading libraries
library(shiny) # For creating R Shiny web app
library(shiny.semantic) # For advance UI options
library(tidyverse) # For data manipulation and analysis

# Sourcing external R scripts
source("Data.R") # For loading data
source("Type.R") # For selecting vessel type
source("Name.R") # For selecting vessel name

# User Interface (UI)
ui <- semanticPage(
  TypeUI("type", Data),
  NameUI(Data)
)

# Server
server <- function(session, input, output) {
  Value <- reactiveValues(Type = NULL)
  Temp <- callModule(TypeServer, "type", Data)
  observe({
    Value$Type <- Temp$Type
    Temp <- as.vector(as.matrix(unique(Data %>% filter(ship_type == Value$Type) %>% select(SHIPNAME))))
    update_dropdown_input(session, input_id = "Name", choices = Temp)
  })
}

# Application
shinyApp(ui = ui, server = server)