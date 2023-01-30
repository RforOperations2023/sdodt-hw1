dist_plot <- function(input, session) {
  reactive({
    mmsi_meetings <- all_meetings %>%
      filter(vessel.mmsi == input$vessel_mmsi) %>%
      mutate(distance_from_shore = distance_from_shore_m / 1852)
  })
}