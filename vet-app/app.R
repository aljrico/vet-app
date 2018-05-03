
# Libraries ---------------------------------------------------------------
library(shiny)
library(shinyjs)
library(shinydashboard)
library(DT)


# Main Code ---------------------------------------------------------------
source("css/css.R")
source("definitions.R")
source("functions.R")
source("ui.R")
source("server.R")


# Run the Application -----------------------------------------------------
shinyApp(ui = ui, server = server)


