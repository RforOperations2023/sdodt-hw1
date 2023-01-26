# server <- function(input, output) {
#   output$scatterplot <- renderPlot({
#     ggplot(data = movies, aes_string(x = input$x, y = input$y,
#                                      color = input$z, alpha = input$alpha)) +
#       geom_point()
#   })
# }

server <- function(input, output, session) {
	output$distPlot <- renderPlot({
		hist(rnorm(input$obs))
	})

	output$distPlot2 <- renderPlot({
		hist(rnorm(input$obs))
	})
	}