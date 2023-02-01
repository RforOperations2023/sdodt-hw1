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
    rankingstable_data <- generate_rankings(input, session, encounter, loitering)
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
    mmsi_data <- dist_plot(input, session, encounter, loitering)()

    vessel_name <- mmsi_data %>%
      count(vessel.name) %>%
      slice(which.max(n)) %>%
      pull(vessel.name)

    vessel_flag <- mmsi_data %>%
      count(vessel.flag) %>%
      slice(which.max(n)) %>%
      pull(vessel.flag)

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

    output$portplot <- renderPlot({
      ggplot(
        data = mmsi_data,
        aes(x = vessel.destination_port.country, fill = Meeting_Type)
        ) +
        geom_histogram(
          # binwidth = 25,
          boundary = 0,
          position = "stack",
          stat = "count"
        ) +
        # xlim(0, max(800, max(mmsi_data$distance_from_shore))) +
        # xlab("Distance from shore during meeting") +
        # ylab("Frequency") +
        ggtitle("Port Country")
    })
  })

  }