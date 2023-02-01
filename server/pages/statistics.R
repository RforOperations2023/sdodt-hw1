dist_plot <- function(input, session, encounter, loitering) {
  reactive({
    mmsi_meetings <- rbind(encounter, loitering) %>%
      filter(vessel.mmsi == input$vessel_mmsi) %>%
      mutate(
        distance_from_shore = distance_from_shore_m / 1852,
        start = as.Date(start),
        Meeting_Type = ifelse(type == "encounter", "tracked", "dark"))
  })
}