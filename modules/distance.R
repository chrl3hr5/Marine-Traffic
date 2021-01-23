# Distance module's User Interface (UI)
DistanceUI <- function(id) {
  tagList(
    textOutput(outputId = NS(id, "TextOutput"))
  )
}

# Distance module's Server
DistanceServer <- function(input, output, session, data, info) {
  observe({
    # Filtering data on the basis of vessel type and name
    Temp <- data %>% filter(ship_type == info$Type() & SHIPNAME == info$Name())
    # Segregating data for performing calculations
    First <- Temp[-nrow(Temp), c("LAT", "LON")]
    Second <- Temp[-1, c("LAT", "LON")]
    # Calculating the separation between each pair of coordinates
    Travel <- apply(as.data.frame(cbind(First, Second)), 1, function(x) {
      distCosine(c(x[1], x[2]), c(x[3], x[4]))
    })
    # Total distance traveled
    output$TextOutput <- renderText({
      sum(Travel)
    })
  })
}