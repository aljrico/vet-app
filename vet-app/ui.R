
library(shiny)
library(shinyjs)
library(shinydashboard)
library(DT)

source("css.R")
source("definitions.R")
source("functions.R")
source("read_registers.R")

source("ui/sidebar.R")
source("ui/header.R")
source("ui/body.R")


# Define UI for application
ui <- dashboardPage(
	skin = "black",
	header,
	sidebar,
	body
)


