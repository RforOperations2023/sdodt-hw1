# server <- function(input, output) {
#   output$scatterplot <- renderPlot({
#     ggplot(data = movies, aes_string(x = input$x, y = input$y,
#                                      color = input$z, alpha = input$alpha)) +
#       geom_point()
#   })
# }
source("server/pages/rankings.R")

server <- function(input, output, session) {
  output$rankingstable <- renderTable(
      expr = generate_rankings()[1:10, 1:2]
      # data = ,
      # options = list(pageLength = 10),
      # rownames = FALSE
    )

  # output$distPlot <- renderPlot({
  # 	hist(rnorm(input$obs))
  # })

  output$distPlot2 <- renderPlot({
    hist(rnorm(input$obs))
  })
  }