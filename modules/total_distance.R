# Distance module's User Interface (UI)
Total_DistanceUI <- function(id) {
  fluidRow(
    split_layout(
      # Adding value box for vessel's length
      value_box_output(outputId = NS(id, "Length")),
      # Adding value box for vessel's width
      value_box_output(outputId = NS(id, "Width")),
      # Adding value box for vessel's deadweight
      value_box_output(outputId = NS(id, "Deadweight")),
      # Adding value box for the total distance covered by the vessel
      value_box_output(outputId = NS(id, "Distance"))
    )
  )
}

# Distance module's Server
Total_DistanceServer <- function(input, output, session, data, info) {
  observe({
    # Filtering data on the basis of vessel type and name
    Temp <- data %>% filter(ship_type == info$Type() & SHIPNAME == info$Name())
    # Segregating data for performing calculations
    First <- Temp[-nrow(Temp), c("LAT", "LON")]
    Second <- Temp[-1, c("LAT", "LON")]
    # Calculating the separation between each pair of coordinates (in meters)
    Travel <- apply(as.data.frame(cbind(First, Second)), 1, function(x) {
      distGeo(c(x[1], x[2]), c(x[3], x[4]))
    })
    # Total length of the vessel (in meters)
    output$Length <- render_value_box({
      valueBox(
        size = "small", color = "blue", value = unique(Temp$LENGTH), subtitle = "Length (in meters)"
      )
    })
    # Total width of the vessel (in meters)
    output$Width <- render_value_box({
      valueBox(
        size = "small", color = "yellow", value = unique(Temp$WIDTH), subtitle = "Width (in meters)"
      )
    })
    # Total deadweight of the vessel (in tonnes)
    output$Deadweight <- render_value_box({
      valueBox(
        size = "small", color = "red", value = unique(Temp$DWT), subtitle = "Deadweight (in tonnes)"
      )
    })
    # Total distance traveled (in meters)
    output$Distance <- render_value_box({
      valueBox(
        size = "small", color = "green", value = round(sum(Travel)), subtitle = "Total distance traveled (in meters)"
      )
    })
  })
}