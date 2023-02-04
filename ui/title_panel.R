run_title_panel <- function() {
  subtitle_text <- readRDS("data/subtitle.RDS")
  
  return(
    fluidRow(
        br(),
        column(width = 1),
        # Title and subtile
        column(
          width = 8,
          align = "left",
          p(subtitle_text),  # imported from RDS to load quicker
          br()
        ),
        column(width = 3)
      )
  )
}