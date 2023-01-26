run_sidebar <- function() {
  return(
    gentelellaSidebar(
        site_title = shiny::HTML(paste(shiny::icon("ship"),
                                       "Sebastian Dodt")),
        url = NULL,
        fixed = FALSE,
        footer = NULL,
        # uiOutput("profile"),
        sidebarDate(),
        sidebarMenu(
          sidebarItem(
            "Ranking",
            tabName = "ranking",
            icon = tags$i(class = "fa-solid fa-table"),
            badgeName = "new",
            badgeStatus = "danger"
          ),
          sidebarItem(
            "Statistics",
            tabName = "stats", 
            icon = tags$i(class = "fa-sharp fa-solid fa-chart-simple")
          )
        )
      )
  )
}

