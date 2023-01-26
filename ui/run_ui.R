source("ui/sidebar.R")
source("ui/main_panel.R")
source("ui/navbar.R")
source("ui/footer.R")
library(shiny)

run_ui <- function() {
  mainpanel <- run_main_panel()
  sidebar <- run_sidebar()
  navbar <- run_navbar()
  footer <- run_footer()
  return(
    gentelellaPageCustom(
      title = "Illegal Fishing",
      navbar = navbar,
      sidebar = sidebar,
      body = mainpanel,
      footer = footer
    )
  )
}