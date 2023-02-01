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

  load("data/combined.Rdata")
  load("data/ship_ids.Rdata")

  table_data <- reactive({
    req(input$year_range)
    rankingstable_data <- generate_rankings(
      input, session, encounter, loitering)
    data <- rankingstable_data() %>% head(10)
  })
  output$rankingstable <- renderTable(
    expr = table_data(),
    digits = 0,
    na = ""
  )



  observeEvent(input$all_ranking, {
    rankingstable_data <- generate_rankings(
      input, session, encounter, loitering)
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
    mmsi_data <- dist_plot(input, session, encounter, loitering)()
    description <- description_text(input, session, mmsi_data)()

    vessel_name <- description$vessel_name
    vessel_flag <- description$vessel_flag

    output$vessel_name <- renderText(vessel_name)
    output$vessel_flag <- renderUI(
      shinyflags::flag(
        country = countrycode(vessel_flag, "iso3c", "iso2c")
      )
    )

    output$distPlot2 <- renderPlot({
      ggplot(
        data = mmsi_data,
        aes(x = distance_from_shore, fill = Meeting_Type)
        ) +
        geom_histogram(
          binwidth = 25,
          boundary = 0,
          position = "stack"
        ) +
        geom_vline(
          aes(xintercept = 200),
          color = "black",
          linetype = "dashed",
          size = 1
        ) +
        xlim(0, max(800, max(mmsi_data$distance_from_shore))) +
        xlab("Distance from shore during meeting") +
        ylab("Frequency") +
        ggtitle("Distance from shore during meetings")
    })
    monthly_data <- mmsi_data %>%
      mutate(month = as.Date(cut(start, breaks = "month"))) %>%
      group_by(month) %>%
      summarise(monthly_activity = n_distinct(id)) %>%
      ungroup() %>%
      complete(
        month = seq(min(month), as.Date("2022-12-31"), by = "1 month"),
        fill = list(monthly_activity = 0)
      ) %>%
      mutate(rolling_sum = rollapplyr(
        monthly_activity, 12, sum, partial = TRUE) / 12)

    output$timePlot <- renderPlot({
      ggplot(data = monthly_data) +
        geom_bar(
          aes(month, monthly_activity),
          stat = "identity",
          na.rm = TRUE
        ) +
        geom_line(
          aes(month, rolling_sum),
          linetype = "dashed",
          color = "blue"
        ) +
        labs(
          title = "Trend of meetings",
          caption = "The dotted line shows 12-month rolling average.",
          x = "Month",
          y = "Meetings per month"
        )
    })

    output$portplotcountry <- renderPlot({
      if (input$city_or_country == "Country") {
        p <- ggplot(
          data = mmsi_data,
          aes(x = port_country, fill = Meeting_Type)
          ) +
          xlab("Country where vessel headed after meetings")
      } else {
        p <- ggplot(
          data = mmsi_data,
          aes(x = vessel.destination_port.name, fill = Meeting_Type)
          ) +
          xlab("Port where vessel headed after meetings")
      }
        p + geom_histogram(
          boundary = 0,
          position = "stack",
          stat = "count"
        ) +
        ylab("Sum of meetings before heading to the port") +
        ggtitle("Port Country") +
        theme(axis.text.x = element_text(angle = 90))
    })


    output$description <- renderUI({
      HTML(
        paste0("<br>",
        str_to_title(description$vessel_name),
        " is a reefer vessel flagged to ", description$vessel_country, 
        " and most frequently visits ports in ", description$vessel_port,
        ". <br><br>",
        "Its median distance from shore during ",
        "meetings with fishing vessels is ",
        round(description$vessel_dist, 0), " nautical miles.<br><br>"
        # "It spent ", round(description$vessel_loi_hours,0),
        # " hours in dark meetings. <br><br>",
        # "In its tracked meetings, ",
        # "it most frequently met fishing vessels flagged to ",
        # description$vessel_enc_flag,
        # " who go to port in ", description$vessel_enc_port, ".<br><br>"
      ))
    })

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

