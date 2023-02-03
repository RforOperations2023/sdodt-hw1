# This script renames the .csv downloads to be .Rdata files.
# Rdata files are read in quicker by the dashboard

# Data downloaded from Global Fishing Watch
# https://globalfishingwatch.org/data-download/datasets/carriers:v20220124
encounter <- read.csv("data/encounter.csv")
loitering <- read.csv("data/loitering.csv")
port <- read.csv("data/port.csv")

save(encounter, file = "data/encounter.Rdata")
save(loitering, file = "data/loitering.Rdata")
save(port, file = "data/port.Rdata")
save(list = c("encounter", "loitering"), file = "data/combined.Rdata")


choices <- sort(unique(rbind(encounter, loitering)$vessel.flag))
saveRDS(choices, file = "data/flags.RDS")

ship_mmsi <- rbind(encounter, loitering) %>%
  group_by(vessel.mmsi) %>%
  summarise(number_of_meetings = n_distinct(id)) %>%
  filter(number_of_meetings > 100) %>%
  pull(vessel.mmsi)
save(list = c("ship_mmsi"), file = "data/ship_ids.Rdata")

subtitle = paste0(
  "Illegal fishing is a major ecological and humanitarian problem. ",
  "This portal aims to provide details on some of the largest offenders",
  ", so-called 'reefers'. <br><br>",
  "Reefers are large cargo vessels that meet fishing boats around the ",
  "ocean, collect their fish, and give them fuel. ",
  "This allows fishing vessels to stay undetected while fishing in areas ",
  "where they are not allowed to fish. <br><br>",
  "Reefers help conceal where the fish is coming from and allow illegally ",
  "caught fish to enter the supply chain.<br><br>",
  "Meetings (regardless of whether they are tracked or dark) have been ",
  "designated as illagal under UN conventions.<br><br>",
  "The data for this portal comes from Global Fishing Watch.")
saveRDS(HTML(subtitle),
  file = "data/subtitle.RDS"
)