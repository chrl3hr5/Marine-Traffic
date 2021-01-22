TypeUI <- function(id, data) {
  dropdown_input(input_id = NS(id, "Type"), choices = unique(data$ship_type), value = unique(data$ship_type)[1], type = "selection fluid")
}

TypeServer <- function(input, output, session, data) {
  Value <- reactiveValues()
  observe({
    Value$Type <- input$Type
  })
  return(Value)
}