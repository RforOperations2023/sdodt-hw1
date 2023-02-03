table_data <- function(input, session, encounter, loitering) {
  reactive({
    req(input$year_range)
    rankingstable_data <- generate_rankings(
      input, session, encounter, loitering)
    data <- rankingstable_data() %>%
      head(10)
  })
}

generate_rankings <- function(input, session, encounter, loitering) {
  reactive({
  
  # join tracked and dark meetings
  all_meetings <- rbind(encounter, loitering) %>%

    # filter by date when the meeting occured
    mutate(start = as.Date(start)) %>%
    filter(between(
        start,
        as.Date(paste0(input$year_range[1], "-01-01")),
        as.Date(paste0(input$year_range[2], "-12-31"))
    )) %>%

    # filter by the distance from shore where the meeting occured
    filter(between(
        distance_from_shore_m,
        input$distance[1] * 1852,
        input$distance[2] * 1852
    ))

  # filter by the flags of the vessels
  if ("flags" %in% names(input) & !is.null(input$flags)) {
    all_meetings <- all_meetings %>%
      filter(vessel.flag %in% input$flags)
  }

  # generate table columns: name of vessel and flag of vessel
  reefer_info <- all_meetings %>%
    count(vessel.mmsi, vessel.name, vessel.flag, sort = TRUE) %>%
    group_by(vessel.mmsi) %>%
    summarise(Reefer.Name = vessel.name[1], Reefer.Flag = vessel.flag[1])

  # generate table columns: number of tracked and dark meetings,
  # and median distance from shore
  meeting_info <- all_meetings %>%
    mutate(encounter = ifelse(type == "encounter", 1, 0),
      loitering = ifelse(type == "loitering", 1, 0)) %>%
    group_by(vessel.mmsi) %>%
    summarise(
      n_encounter = sum(encounter),
      n_loitering = sum(loitering),
      avg_distance = median(distance_from_shore_m) / 1852) %>%
    mutate(total_meetings = n_encounter + n_loitering)

  # renaming and sorting the rows
  table_data <- reefer_info %>%
    left_join(meeting_info, by = "vessel.mmsi") %>%
    arrange(-total_meetings) %>%
    mutate(Reefer.Name = str_to_title(Reefer.Name)) %>%
    rename(
      "MMSI" = vessel.mmsi,
      "Vessel Name" = Reefer.Name,
      "Flag" = Reefer.Flag,
      "Number of tracked meetings" = n_encounter,
      "Number of dark meetings" = n_loitering,
      "Median distance from shore (nm)" = avg_distance,
      "Total number of meetings" = total_meetings
    )

  table_data
})}