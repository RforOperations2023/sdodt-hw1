run_rankings <- function() {
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
          )
        )),
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