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
      data <- head(rankingstable_data(),10)
  })
  output$rankingstable <- renderTable(
    expr = table_data(),
    digits = 0,
    na = ""
  )

  observeEvent(input$all_ranking, {
    rankingstable_data <- generate_rankings(input)
    output$rankingstable <- renderTable(
      expr = rankingstable_data(),
      digits = 0,
      na = ""
    )
  })



  output$distPlot2 <- renderPlot({
    hist(rnorm(input$obs))
  })
  }