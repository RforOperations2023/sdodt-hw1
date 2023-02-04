source("ui/pages/rankings.R")
source("ui/pages/statistics.R")


run_main_panel <- function() {
  rankings_tab <- run_rankings()
  stats_tab <- run_stats()
  return(
    tabsetPanel(
      rankings_tab,
      stats_tab
    )
  )
}