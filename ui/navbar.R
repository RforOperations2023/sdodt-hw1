run_navbar <- function() {
  return(
    gentelellaNavbar(
      navbarItems = notif(
        id = "menunotif",
        icon = icon("calendar"),
        status = "primary",
        expanded = FALSE,
        lapply(X = 1:5, FUN = function(i) {
          notifItem(
            title = "John Doe",
            date = "3 min ago",
            img = paste0("https://image.flaticon.com/icons/svg/163/16382", i,".svg"),
            "Film festivals used to be do-or-die moments
            for movie makers. They were where..."
          )
        })
      )
    )
  )
}