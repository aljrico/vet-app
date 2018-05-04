sidebar <- dashboardSidebar(
	sidebarMenu(
		id = "sidebarmenu",
		menuItem("About this App", tabName = "home",  icon = icon("home"), selected = T),
		menuItem("Register Form", tabName = "register",  icon = icon("drivers-license")),
		menuItem("List", tabName = "register_search",  icon = icon("drivers-license"))
	)
)
