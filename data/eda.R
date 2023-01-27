load("data/encounter.Rdata")
load("data/loitering.Rdata")
all_meetings <- rbind(encounter, loitering)
reefer_info <- all_meetings %>%
  count(vessel.mmsi, vessel.name, vessel.flag, sort = TRUE) %>%
  group_by(vessel.mmsi) %>%
  summarise(Reefer.Name = vessel.name[1], Reefer.Flag = vessel.flag[1])

meeting_info <- all_meetings %>%
  mutate(encounter = ifelse(type == "encounter", 1, 0),
    loitering = ifelse(type == "loitering", 1, 0)) %>%
  group_by(vessel.mmsi) %>%
  summarise(
    n_encounter = sum(encounter),
    n_loitering = sum(loitering),
    avg_distance = mean(distance_from_shore_m) / 1852) %>%
  mutate(
    total_meetings = n_encounter + n_loitering
  )

table_data <- reefer_info %>%
  left_join(meeting_info, by = "vessel.mmsi") %>%
  arrange(-total_meetings)
