run_rankings <- function() {

  # importing selection options for the dropdown
  flag_choices <- readRDS("data/flags.RDS")
  subtitle_text <- readRDS("data/subtitle.RDS")

  return(
    tabItem(
      tabName = "ranking",
      fluidRow(

        # Title and subtile
        column(
          width = 6,
          align = "left",
          h1("Reefer Tracking Portal"),
          p(subtitle_text)  # imported from RDS to load quicker
        ),
        column(width = 6)
      ),
      hr(),
      fluidRow(

        # Year range slider
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

        # Flag filter
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

        # Distance slider
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

      # Table
      fluidRow(
        column(
          width = 12,
          align = "center",
          tableOutput(outputId = "rankingstable")
        )
      ),

      # "Show all" button
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