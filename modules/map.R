# Map module's User Interface (UI)
MapUI <- function(id) {
  fluidRow(
    box(
      width = 12, ribbon = T, collapsible = F, title_side = "top left",
      title = "MAP", leafletOutput(outputId = NS(id, "Map"))
    )
  )
}

# Map module's Server
MapServer <- function(input, output, session, data, info, polygons) {
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
    # Finding coordinates associated with the the longest distance traveled between consecutive observations
    Index <- which(Travel == max(Travel))[length(which(Travel == max(Travel)))]
    Start_LAT <- Temp$LAT[Index]
    Start_LON <- Temp$LON[Index]
    End_LAT <- Temp$LAT[Index + 1]
    End_LON <- Temp$LON[Index + 1]
    # Creating icon for map
    icons <- awesomeIcons(
      icon = "ios-close",
      iconColor = "black",
      library = "ion"
    )
    # Rendering map
    output$Map <- renderLeaflet({
      leaflet(polygons, options = leafletOptions(minZoom = 2)) %>%
        addTiles() %>%
        # Marker for start location
        addAwesomeMarkers(~Start_LON, ~Start_LAT, icon = icons, label = "Start") %>%
        # Marker for end location
        addAwesomeMarkers(~End_LON, ~End_LAT, icon = icons, label = "End") %>%
        # Adding bounds for better visibility of desired location
        setMaxBounds(lng1 = Start_LON + 20, lat1 = Start_LAT + 20, lng2 = End_LON - 20, lat2 = End_LAT - 20) %>%
        addProviderTiles("CartoDB.VoyagerLabelsUnder")
    })
  })
}