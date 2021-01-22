VesselUI <- function(id, data) {
  tagList(
    dropdown_input(input_id = NS(id, "Type"), choices = unique(data$ship_type), value = unique(data$ship_type)[1], type = "selection fluid"),
    dropdown_input(input_id = NS(id, "Name"), choices = NULL, type = "selection fluid")
  )
}

VesselServer <- function(input, output, session, data) {
  observe({
    Temp <- as.vector(as.matrix(unique(data %>% filter(ship_type == input$Type) %>% select(SHIPNAME))))
    update_dropdown_input(session, input_id = "Name", choices = Temp)
  })
}