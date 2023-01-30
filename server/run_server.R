# server <- function(input, output) {
#   output$scatterplot <- renderPlot({
#     ggplot(data = movies, aes_string(x = input$x, y = input$y,
#                                      color = input$z, alpha = input$alpha)) +
#       geom_point()
#   })
# }
source("server/pages/rankings.R")

server <- function(input, output, session) {

  table_data <- reactive({
      req(input$year_range)
      rankingstable_data <- generate_rankings(input)
      data <- rankingstable_data() %>% head(10)
  })
  output$rankingstable <- renderTable(
    expr = table_data(),
    digits = 0,
    na = ""
  )


  observeEvent(input$all_ranking, {
    rankingstable_data <- generate_rankings(input)
    updateSelectInput(
      session = session,
      inputId = "flags",
      label = "Support Vessel Flags",
      choices = rankingstable_data()$Flag)
    output$rankingstable <- renderTable(
      expr = rankingstable_data(),
      digits = 0,
      na = ""
    )
  })

  # observe({
  #   rankingstable_data <- generate_rankings(input)
  #         updateSelectInput(session, "flags",
  #                           label = "Support Vessel Flags",
  #                           choices = sort(unique(rankingstable_data()$Flag)),
  #                           selected = input$flags)
  #     })


  output$distPlot2 <- renderPlot({
    hist(rnorm(input$obs))
  })
  }