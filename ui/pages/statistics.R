run_stats <- function() {
  load("data/ship_ids.Rdata")
  return(
    tabItem(
      tabName = "stats",
      fluidRow(
        column(
            width = 4,
            align = "left",
            fluidRow(
              column(
                width = 9,
                align = "left",
                h1(textOutput("vessel_name"))),
              column(
                width = 3,
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
            uiOutput("description"),
            downloadButton("download_data", "Download")
            ),
        column(
          width = 8,
          align = "center",
          plotOutput("distPlot2"),
          hr(),
          plotOutput("timePlot"),
          hr(),
          selectInput(
            "city_or_country",
            "Plot by",
            choices = c("Country", "City"),
            multiple = FALSE,
            selectize = TRUE,
            selected = "Country"
          ),
          plotOutput("portplotcountry")
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