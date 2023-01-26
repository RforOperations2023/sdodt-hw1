
generate_rankings <- function() {
  load("data/encounter.Rdata")
  load("data/loitering.Rdata")

  all_meetings <- rbind(
    encounter,
    loitering)
  all_meetings <- all_meetings %>%
    group_by(vessel.mmsi) %>%
    summarise(total_meetings = n_distinct(id))

  return(
    all_meetings
  )
}