TypeUI <- function(data) {
  dropdown_input(input_id = "Type", choices = unique(data$ship_type), value = unique(data$ship_type)[1], type = "selection fluid")
}