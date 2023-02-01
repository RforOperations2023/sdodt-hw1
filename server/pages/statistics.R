dist_plot <- function(input, session, encounter, loitering) {
  reactive({
    mmsi_meetings <- rbind(encounter, loitering) %>%
      filter(vessel.mmsi == input$vessel_mmsi) %>%
      mutate(
        distance_from_shore = distance_from_shore_m / 1852,
        start = as.Date(start),
        Meeting_Type = ifelse(
          type == "encounter",
          "tracked",
          "dark"),
        port_country = countrycode(
          vessel.destination_port.country,
          "iso3c",
          "country.name")
        )
  })
}


get_most_frequent_value <- function(df, column_name) {
  return (df %>%
    count(!!as.name(column_name)) %>%
    slice(which.max(n)) %>%
    pull(!!as.name(column_name)))
}

description_text <- function(input, session, mmsi_meetings) {
  reactive({
    desc <- list()
    desc$vessel_name <- get_most_frequent_value(
      mmsi_meetings, "vessel.name")
    desc$vessel_flag <- get_most_frequent_value(
      mmsi_meetings, "vessel.flag")
    desc$vessel_country <- countrycode(
      desc$vessel_flag, "iso3c", "country.name")
    desc$vessel_port <- countrycode(
      get_most_frequent_value(
        mmsi_meetings, "vessel.destination_port.country"),
      "iso3c", "country.name")
    desc$vessel_dist <- mmsi_meetings$distance_from_shore %>%
      median()
    desc$vessel_enc_flag <- get_most_frequent_value(
      mmsi_meetings, "encounter.encountered_vessel.flag")
    desc$vessel_enc_port <- get_most_frequent_value(
      mmsi_meetings, "encounter.encountered_vessel.origin_port.country")
    desc$vessel_loi_hours <- mmsi_meetings$loitering.loitering_hours %>%
      sum()
    desc
  })
}

