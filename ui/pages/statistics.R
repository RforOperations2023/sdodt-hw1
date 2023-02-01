run_stats <- function() {
  load("data/ship_ids.Rdata")
  return(
    tabItem(
      tabName = "stats",
      fluidRow(
        # column(
        #     width = 4,
        #     align = "center",
        #     selectInput(
        #       "vessel_name",
        #       "Support Vessel Flags",
        #       choices = ship_names,
        #       multiple = FALSE,
        #       selectize = TRUE
        #     )),
        column(
            width = 4,
            align = "center",
            fluidRow(
              column(
                width = 10,
                align = "left",
                h1(textOutput("vessel_name"))),
              column(
                width = 2,
                align = "right",
                htmlOutput("vessel_flag"))
            ),
            selectInput(
              "vessel_mmsi",
              "Support Vessel MMSI number",
              choices = ship_mmsi,
              multiple = FALSE,
              selectize = TRUE,
              selected = 371717000
            ),
            ),
        column(
          width = 8,
          align = "center",
          plotOutput("distPlot2"),
          plotOutput("timePlot"),
          plotOutput("portplot")
        )
      # ),
      # fluidRow(
      #   column(
      #     width = 8,
      #     align = "center",
      #     plotOutput("timePlot"))
      )
    )
  )
}