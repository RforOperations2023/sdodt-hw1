run_rankings <- function() {

  # importing selection options for the dropdown
  flag_choices <- readRDS("data/flags.RDS")

  return(
    shiny::tabPanel(
      tabName = "Ranking",
      title = "Ranking",
      br(),
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
          DT::dataTableOutput(outputId = "rankingstable")
        )
      )

      # # "Show all" button
      # fluidRow(
      #   column(
      #     width = 12,
      #     align = "center",
      #     actionButton("all_ranking", "Show all")
      #   )
      # )
    )
  )
}