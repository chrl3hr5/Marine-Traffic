# Vessel module's User Interface (UI)
VesselUI <- function(id, data) {
  tagList(
    # Dropdown menu for selecting vessel type
    dropdown_input(input_id = NS(id, "Type"), choices = unique(data$ship_type), value = unique(data$ship_type)[1], type = "selection fluid"),
    # Dropdown menu for selecting vessel name
    dropdown_input(input_id = NS(id, "Name"), choices = NULL, type = "selection fluid")
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