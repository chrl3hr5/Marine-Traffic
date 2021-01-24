# Vessel module's User Interface (UI)
VesselUI <- function(id, data) {
  fluidRow(
    box(
      color = "red",
      width = 12, title = "SELECT VESSEL TYPE", collapsible = F,
      # Dropdown menu for selecting vessel type
      dropdown_input(input_id = NS(id, "Type"), choices = unique(data$ship_type), value = unique(data$ship_type)[1], type = "selection fluid")
    ), br(),
    box(
      color = "yellow",
      width = 12, title = "SELECT VESSEL NAME", collapsible = F,
      # Dropdown menu for selecting vessel name
      dropdown_input(input_id = NS(id, "Name"), choices = NULL, type = "selection fluid")
    )
  )
}

# Vessel module's Server
VesselServer <- function(input, output, session, data) {
  observe({
    # Filtering vessel names on the basis of vessel type
    Temp <- as.vector(as.matrix(unique(data %>% filter(ship_type == input$Type) %>% select(SHIPNAME))))
    # Updating dropdown menu associated with vessel name
    update_dropdown_input(session, input_id = "Name", choices = Temp)
  })
  return(
    list(
      # Type of vessel selected
      Type = reactive({
        input$Type
      }),
      # Name of vessel selected
      Name = reactive({
        input$Name
      })
    )
  )
}