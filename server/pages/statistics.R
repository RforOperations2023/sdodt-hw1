vessel_data <- function(input, session, encounter, loitering) {
  reactive({
    mmsi_meetings <- rbind(encounter, loitering) %>%
      filter(vessel.mmsi == input$vessel_mmsi) %>%
      mutate(
        distance_from_shore = distance_from_shore_m / 1852,
        start = as.Date(start),
        Meeting_Type = ifelse(
          type == "encounter",
          "tracked",
          "dark"),
        port_country = countrycode(
          vessel.destination_port.country,
          "iso3c",
          "country.name"))
  })
}


get_most_frequent_value <- function(df, column_name) {
  ## helper function to return most frequent value from a column
  return(df %>%
    count(!!as.name(column_name)) %>%
    slice(which.max(n)) %>%
    pull(!!as.name(column_name)))
}

description_values <- function(input, session, mmsi_meetings) {
  reactive({
    desc <- list()
    desc$vessel_name <- get_most_frequent_value(
      mmsi_meetings, "vessel.name")
    desc$vessel_flag <- get_most_frequent_value(
      mmsi_meetings, "vessel.flag")
    desc$vessel_country <- countrycode(
      desc$vessel_flag, "iso3c", "country.name")
    desc$vessel_port <- countrycode(
      get_most_frequent_value(
        mmsi_meetings, "vessel.destination_port.country"),
      "iso3c", "country.name")
    desc$vessel_dist <- mmsi_meetings$distance_from_shore %>%
      median()
    desc$vessel_enc_flag <- get_most_frequent_value(
      mmsi_meetings, "encounter.encountered_vessel.flag")
    desc$vessel_enc_port <- get_most_frequent_value(
      mmsi_meetings, "encounter.encountered_vessel.origin_port.country")
    desc$vessel_loi_hours <- mmsi_meetings$loitering.loitering_hours %>%
      sum()
    desc
  })
}

distance_plot <- function(mmsi_data) {
  reactive({
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
      labs(caption = "The area that lies within 200nm of the shore
        underlies the respective country's jurisdiction.") +
      ggtitle("Distance from shore during meetings")
  })
}


time_plot <- function(mmsi_data) {
  reactive({
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
}


port_plot <- function(input, mmsi_data) {
  reactive({
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
}

description_text <- function(description) {
  reactive({
    HTML(
        paste0("<br>",
        str_to_title(description$vessel_name),
        " is a reefer vessel flagged to ", description$vessel_country, 
        " and most frequently visits ports in ", description$vessel_port,
        ". <br><br>",
        "Its median distance from shore during ",
        "meetings with fishing vessels is ",
        round(description$vessel_dist, 0), " nautical miles.<br><br>"
      ))
  })
}