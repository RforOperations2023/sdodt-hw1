# This script creates the server function

source("server/pages/rankings.R")
source("server/pages/statistics.R")

server <- function(input, output, session) {

  # import data from disk once when application is started
  load("data/combined.Rdata")
  load("data/ship_ids.Rdata")

  # *Rankings Page*
  # generate the table for the ranking when application is loaded
  # and update reactively when input parameters change
  ranking_data <- reactive({
    table_data(input, session, encounter, loitering)()
  })

  output$rankingstable <- renderTable(
    expr = ranking_data(),
    digits = 0,
    na = ""
  )

  # expand table when "Show More" button is pressed
  observeEvent(input$all_ranking, {
    output$rankingstable <- renderTable(
      expr = generate_rankings(
        input, session, encounter, loitering)(),
      digits = 0,
      na = ""
    )
  })

  # *Statistics page*
  observeEvent(input$vessel_mmsi, {

    # filter data relevant to one particular vessel
    mmsi_data <- vessel_data(input, session, encounter, loitering)()

    # generate descriptive information of vessel
    description <- description_values(input, session, mmsi_data)()

    # render title of page
    output$vessel_name <- renderText(
      description$vessel_name
    )

    # render flag of vessel
    output$vessel_flag <- renderUI(
      shinyflags::flag(
        country = countrycode(description$vessel_flag, "iso3c", "iso2c")
      ))

    # generate descriptive text for particular vessel
    output$description <- renderUI({
      description_text(description)()
    })

    # plot 1: distance from shore during meeting
    output$distplot <- renderPlot({
      distance_plot(mmsi_data)()
    })

    # plot 2: meetings over time
    output$timeplot <- renderPlot({
      time_plot(mmsi_data)()
    })

    # plot 3: ports visited after meeting
    output$portplotcountry <- renderPlot({
      port_plot(input, mmsi_data)()
    })

    # download button for this vessel's data
    output$download_data <- downloadHandler(
      filename = function() {
        paste("data-", input$vessel_mmsi, ".csv", sep = "")
      },
      content = function(file) {
        write.csv(mmsi_data, file)
      }
    )
  })
}