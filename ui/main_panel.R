source("ui/pages/rankings.R")
source("ui/pages/statistics.R")


run_main_panel <- function() {
  # return(mainPanel(renderTable(outputId = "rankingstable")))

  rankings_tab <- run_rankings()
  stats_tab <- run_stats()
  return(
    gentelellaBody(
      tabItems(
        rankings_tab,
        stats_tab
      )
    )
  )
}