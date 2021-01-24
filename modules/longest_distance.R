# Distance module's User Interface (UI)
Longest_DistanceUI <- function(id) {
  fluidRow(
    box(
      color = "green",
      width = 12, ribbon = T, title = "NOTE",
      title_side = "top right", collapsible = F,
      textOutput(outputId = NS(id, "Observation"))
    )
  )
}

# Distance module's Server
Longest_DistanceServer <- function(input, output, session, data, info) {
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
    # Finding longest distance traveled between consecutive observations
    Index <- which(Travel == max(Travel))[length(which(Travel == max(Travel)))]
    # Finding the observations associated with longest distance
    output$Observation <- renderText({
      paste0(
        "The map shows the selected vessel's initial 
             and final positions for those two consecutive 
             observations which have the most separation of ",
        round(Travel[Index]), " (meters) and was traveled between ",
        Temp$DATETIME[Index], " and ", Temp$DATETIME[Index + 1],
        " by the vessel."
      )
    })
  })
}