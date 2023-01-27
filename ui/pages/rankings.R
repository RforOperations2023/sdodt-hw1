run_rankings <- function() {
  return(
    tabItem(
      tabName = "ranking",
      fluidRow(
        column(
          width = 4,
          align = "center",
          sliderInput(
            "obs",
            "Number of observations:",
            min = 0,
            max = 1000,
            value = 500
          )
        )),
      hr(),
      fluidRow(
        column(
          width = 12,
          align = "center",
          tableOutput(outputId = "rankingstable")
          # DT::dataTableOutput(outputId = "rankingstable")
        )
      )
    )
  )
}