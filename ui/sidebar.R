sidebar <- dashboardSidebar(
	shinyjs::hidden(
		div(id = "sidebar_menu",
				sidebarMenu(
					id = "sidebarmenu",
					menuItem("Log In", tabName = "home",  icon = icon("home"), selected = T),
					menuItem("Register Form", tabName = "register",  icon = icon("drivers-license")),
					menuItem("IDs", tabName = "register_search",  icon = icon("th-list"))
				)
				)
	)
)
