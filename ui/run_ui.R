source("ui/main_panel.R")
source("ui/footer.R")
source("ui/title_panel.R")

run_ui <- function() {
  titlepanel <- run_title_panel()
  mainpanel <- run_main_panel()
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
  )
}