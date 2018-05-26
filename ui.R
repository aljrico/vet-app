
library(shiny)
library(shinyjs)
library(shinydashboard)
library(DT)
library(googlesheets)
library(googledrive)

source("css.R")
source("definitions.R")
source("functions.R")
source("read_registers.R")

source("ui/sidebar.R")
source("ui/header.R")
source("ui/body.R")
source("ui/ui_login.R")



# Go first to the Log In page



# Define UI for application
ui_in <- function(){
	dashboardPage(
		skin = "black",
		header,
		sidebar,
		body
	)
}

