run_stats <- function() {
  load("data/ship_ids.Rdata")
  return(
    shiny::tabPanel(
      tabName = "stats",
      title = "Statistics",
      fluidRow(
        br(),
        column(
            width = 4,
            align = "left",
            fluidRow(

              # Title
              column(
                width = 9,
                align = "left",
                h1(textOutput("vessel_name"))),

              # Flag
              column(
                width = 3,
                align = "right",
                htmlOutput("vessel_flag"))
            ),

            # MMSI selection dropdown
            selectInput(
              "vessel_mmsi",
              "Support Vessel MMSI number",
              choices = ship_mmsi,
              multiple = FALSE,
              selectize = TRUE,
              selected = 371717000
            ),

            # Description
            uiOutput("description"),

            # Download Button
            downloadButton("download_data", "Download")
            ),
        column(
          width = 8,
          align = "center",

          # Plot 1
          plotOutput("distplot"),
          hr(),

          # Plot 2
          plotOutput("timeplot"),
          hr(),

          # Plot 3
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
      )
    )
  )
}