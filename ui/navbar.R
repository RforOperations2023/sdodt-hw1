run_navbar <- function() {
  return(
    gentelellaNavbar(
      # navbarItems = notif(
      #   id = "menunotif",
      #   icon = icon("calendar"),
      #   status = "primary",
      #   expanded = FALSE,
      #   notifItem(
      #     title = "Sebastian Dodt",
      #     date = "1 Feb",
      #     "Published Version 1.0"
      #   )#,
        # notifItem(
        #   title = "Sebastian Dodt",
        #   date = "2 Feb",
        #   "Published Version 1.1"
        # )
        # lapply(X = 1:5, FUN = function(i) {
        #   notifItem(
        #     title = "John Doe",
        #     date = "3 min ago",
        #     img = paste0("https://image.flaticon.com/icons/svg/163/16382", i,".svg"),
        #     "Film festivals used to be do-or-die moments
        #     for movie makers. They were where..."
        #   )
        # })
      # )
    )
  )
}