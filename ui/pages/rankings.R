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
        ),
        column(
          width = 8,
          align = "center",
          tableOutput(outputId = "rankingstable")
          # DT::dataTableOutput(outputId = "rankingstable")
        )
      )
    )
  )
}