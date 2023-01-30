# server <- function(input, output) {
#   output$scatterplot <- renderPlot({
#     ggplot(data = movies, aes_string(x = input$x, y = input$y,
#                                      color = input$z, alpha = input$alpha)) +
#       geom_point()
#   })
# }
source("server/pages/rankings.R")
source("server/pages/statistics.R")

server <- function(input, output, session) {

  table_data <- reactive({
    req(input$year_range)
    rankingstable_data <- generate_rankings(input, session)
    data <- rankingstable_data() %>% head(10)

    ## this is not working
    updateSelectInput(
      session = session,
      "vessel.mmsi",
      label = "Support Vessel MMSI number",
      choices = ship_mmsi,
      selected = 416778000) #(data %>% pull(MMSI))[1])
    data
  })
  output$rankingstable <- renderTable(
    expr = table_data(),
    digits = 0,
    na = ""
  )



  observeEvent(input$all_ranking, {
    rankingstable_data <- generate_rankings(input, session)
    updateSelectInput(
      session = session,
      "vessel.mmsi",
      label = "Support Vessel MMSI number",
      choices = ship_mmsi,
      selected = 416778000) 
    output$rankingstable <- renderTable(
      expr = rankingstable_data(),
      digits = 0,
      na = ""
    )
  })

  observeEvent(input$vessel_mmsi, {
    hist_data <- dist_plot(input, session)()
    output$distPlot2 <- renderPlot({
      ggplot(
        data = hist_data,
        aes_string(x = "distance_from_shore")
        ) +
        geom_histogram(
          binwidth = 25,
          boundary = 0
        ) +
        geom_vline(
          aes(xintercept = 200),
          color = "black",
          linetype = "dashed",
          size = 1
        ) +
        xlim(0, max(800, max(hist_data$distance_from_shore))) +
        xlab("Distance from shore during meeting") +
        ylab("Frequency") +
        ggtitle("Distance from shore during meetings")
    })
  })

  }