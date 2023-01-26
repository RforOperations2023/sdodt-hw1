source("ui/pages/rankings.R")

run_main_panel <- function() {
  rankings_tab <- run_rankings()
  stats_tab <- run_stats()

  gentelellaBody(
    tabItems(
      rankings_tab,
      stats_tab
    )
  )
}