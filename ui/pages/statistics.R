

run_stats <- function() {
  return(
    tabItem(
      tabName = "stats",
      fluidRow(
        column(
          width = 4,
          align = "center",
          sliderInput(
            "obs",
            "Number of observations:",
            min = 0,
            max = 1000,
            value = 800
          )
        ),
        column(
          width = 8,
          align = "center",
          plotOutput("distPlot2")
        )
      )
    )
  )
}