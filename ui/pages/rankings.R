run_rankings <- function() {
  flag_choices <- readRDS("data/flags.RDS")
  return(
    tabItem(
      tabName = "ranking",
      fluidRow(
        column(
          width = 4,
          align = "center",
          sliderInput(
            "year_range",
            "Years",
            min = 2012,
            max = 2022,
            value = c(2012, 2022),
            sep = "",
            round = TRUE,
            ticks = FALSE
          )),
          column(
            width = 4,
            align = "center",
            selectInput(
              "flags",
              "Support Vessel Flags",
              choices = flag_choices,
              multiple = TRUE,
              selectize = TRUE
            )
          ),
          column(
          width = 4,
          align = "center",
          sliderInput(
            "distance",
            "Distance from shore (nm)",
            min = 0,
            max = 1400,
            value = c(200, 250),
            # sep = "",
            round = FALSE,
            animate = TRUE
          ))),
      hr(),
      fluidRow(
        column(
          width = 12,
          align = "center",
          tableOutput(outputId = "rankingstable")
        )
      ),
      fluidRow(
        column(
          width = 12,
          align = "center",
          actionButton("all_ranking", "Show all")
        )
      )
    )
  )
}