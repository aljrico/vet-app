# Define UI for application

source("ui/sidebar.R")
source("ui/header.R")
source("ui/body.R")
ui <- dashboardPage(
	skin = "blue",
	header,
	sidebar,
	body
)


