# source("ui/sidebar.R")
source("ui/main_panel.R")
# source("ui/navbar.R")
source("ui/footer.R")
source("ui/title_panel.R")
library(shiny)

run_ui <- function() {
  titlepanel <- run_title_panel()
  mainpanel <- run_main_panel()
  # sidebar <- run_sidebar()
  navbar <- run_navbar()
  footer <- run_footer()
  return(
    navbarPage(
      title = "Reefer Tracking Portal",
      theme = shinytheme("simplex"),
      fluid = TRUE,
      header = titlepanel,
      mainpanel,
      footer = footer
      )
    # gentelellaPageCustom(
    #   title = "Illegal Fishing",
    #   navbar = navbar,
    #   sidebar = sidebar,
    #   body = mainpanel,
    #   footer = footer
    # )
  )
}