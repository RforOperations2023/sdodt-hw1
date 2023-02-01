options(shiny.jquery.version=1) ## to get the tabs on the left side working. See https://github.com/MarkEdmondson1234/gentelellaShiny/issues/14
library(shiny)
library(gentelellaShiny) ## to install, run `devtools::install_github("MarkEdmondson1234/gentelellaShiny")`
library(shinyflags) ## to install, run `devtools::install_github("tutuchan/shinyflags")`
library(ggplot2)
library(DT)
library(shinyWidgets)
library(dplyr)
library(stringr)
library(tidyquant)
library(zoo)
library(tidyr)
library(countrycode)

# Loading the UI
source("ui/run_ui.R")
ui <- run_ui()

# Load server function
source("server/run_server.R")

# Run application
shinyApp(
  ui = ui,
  server = server
)