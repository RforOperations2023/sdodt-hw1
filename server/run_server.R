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
  # ranking_data <- reactive({
    
  #   #table_data(input, session, encounter, loitering)()
  # })

  generate_rankings2 <- reactive({
    all_meetings <- rbind(encounter, loitering) %>%

    # filter by date when the meeting occured
    mutate(start = as.Date(start)) %>%
    filter(between(
        start,
        as.Date(paste0(input$year_range[1], "-01-01")),
        as.Date(paste0(input$year_range[2], "-12-31"))
    )) %>%

    # filter by the distance from shore where the meeting occured
    filter(between(
        distance_from_shore_m,
        input$distance[1] * 1852,
        input$distance[2] * 1852
    ))

  # filter by the flags of the vessels
  if ("flags" %in% names(input) & !is.null(input$flags)) {
    all_meetings <- all_meetings %>%
      filter(vessel.flag %in% input$flags)
  }

  # generate table columns: name of vessel and flag of vessel
  reefer_info <- all_meetings %>%
    count(vessel.mmsi, vessel.name, vessel.flag, sort = TRUE) %>%
    group_by(vessel.mmsi) %>%
    summarise(Reefer.Name = vessel.name[1], Reefer.Flag = vessel.flag[1])

  # generate table columns: number of tracked and dark meetings,
  # and median distance from shore
  meeting_info <- all_meetings %>%
    mutate(encounter = ifelse(type == "encounter", 1, 0),
      loitering = ifelse(type == "loitering", 1, 0)) %>%
    group_by(vessel.mmsi) %>%
    summarise(
      n_encounter = sum(encounter),
      n_loitering = sum(loitering),
      avg_distance = median(distance_from_shore_m) / 1852) %>%
    mutate(total_meetings = n_encounter + n_loitering)

  # renaming and sorting the rows
  table_data <- reefer_info %>%
    left_join(meeting_info, by = "vessel.mmsi") %>%
    arrange(-total_meetings) %>%
    mutate(Reefer.Name = str_to_title(Reefer.Name)) %>%
    rename(
      "MMSI" = vessel.mmsi,
      "Vessel Name" = Reefer.Name,
      "Flag" = Reefer.Flag,
      "Number of tracked meetings" = n_encounter,
      "Number of dark meetings" = n_loitering,
      "Median distance from shore (nm)" = avg_distance,
      "Total number of meetings" = total_meetings
    )

  table_data
  })

  output$rankingstable <- DT::renderDataTable(
    DT::datatable(
      # data = generate_rankings(input, session, encounter, loitering)(),
      data = generate_rankings2(),
      options = list(pageLength = 10),
      rownames = FALSE)
  )

  # # expand table when "Show More" button is pressed
  # observeEvent(input$all_ranking, {
  #   output$rankingstable <- renderTable(
  #     expr = generate_rankings(
  #       input, session, encounter, loitering)(),
  #     digits = 0,
  #     na = ""
  #   )
  # })

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

  observeEvent(input$city_or_country, {
    mmsi_data <- vessel_data(input, session, encounter, loitering)()
    output$portplotcountry <- renderPlot({
      port_plot(input, mmsi_data)()
    })
  })
}