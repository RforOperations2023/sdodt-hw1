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

encounter_small <- encounter[1:100, ]
loitering_small <- loitering[1:100, ]
save(encounter_small, file = "data/encounter_small.Rdata")
save(loitering_small, file = "data/loitering_small.Rdata")
