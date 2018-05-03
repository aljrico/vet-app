
# Libraries ---------------------------------------------------------------
library(shiny)
library(shinyjs)
library(DT)




# CSS ---------------------------------------------------------------------

appCSS <- ".mandatory_star { color: red; }"

# Functions ---------------------------------------------------------------

# Adds an asterisk to the unfilled mandatory fields
labelMandatory <- function(label) {
	tagList(
		label,
		span("*", class = "mandatory_star")
	)
}

# Set timestamp
epochTime <- function() {
	as.integer(Sys.time())
}

# Human (readable) timestamp
humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")


# Save Data Function
saveData <- function(data) {
	fileName <- sprintf("%s_%s.csv",
											humanTime(),
											digest::digest(data))

	write.csv(x = data, file = file.path(responsesDir, fileName),
						row.names = FALSE, quote = TRUE)
}




# Parameters --------------------------------------------------------------
colours <- sort(c("Black","White","Red","Yellow","Brown","Grey","Blue","Green"))
pet_mood <- c("Good Guy", "Nervous", "Agressive")
pet_register_fields <- c("pet_name","pet_species","pet_colour","castrated","pet_mood")
owner_register_fields <- c("owner_name","owner_surname","owner_id","phone_number","gender")
all_register_fields <- c(pet_register_fields,owner_register_fields)
register_fields_names <- c("Pet's Name", "Species", "Hair Colour", "Castrated?", "Human's Name","Human's Surname", "Pet's Mood")
register_fields_names <- c("Pet's Name", "Species", "Hair Colour", "Castrated?", "Human's Name","Human's Surname", "Pet's Mood")

register_fieldsMandatory <- all_register_fields[c(1,2,4,5,6)]
responsesDir <- file.path("registers")


# Define UI for application that draws a histogram
ui <- fluidPage(

	#Call CSS
	shinyjs::useShinyjs(),
	shinyjs::inlineCSS(appCSS),

	titlePanel("New Register"),
	div(
		id = "form",

		textInput(inputId = all_register_fields[[1]], label = labelMandatory(register_fields_names[[1]]), ""),
		textInput(inputId = all_register_fields[[2]], label = labelMandatory(register_fields_names[[2]]), ""),
		selectInput(inputId = all_register_fields[[3]], label = register_fields_names[[3]], colours),
		textInput(inputId = all_register_fields[[5]], label = labelMandatory(register_fields_names[[5]]), ""),
		textInput(inputId = all_register_fields[[6]], label = labelMandatory(register_fields_names[[6]]), ""),
		selectInput(inputId = all_register_fields[[7]], label = register_fields_names[[7]], pet_mood),
		checkboxInput(inputId = all_register_fields[[4]], label = labelMandatory(register_fields_names[[4]]), FALSE),

		checkboxInput("used_shiny", "I've built a Shiny app in R before", FALSE),
		sliderInput("r_num_years", "Number of years using R", 0, 25, 2, ticks = FALSE),
		selectInput("os_type", "Operating system used most frequently",
								c("",  "Windows", "Mac", "Linux")),
		actionButton("submit", "Submit", class = "btn-primary")
	)
)


# Server ------------------------------------------------------------------
server <- function(input, output) {

# Mandatory Fields --------------------------------------------------------
	#Check if mandatory fields are filled to enable submit button
	observe({
		# check if all mandatory fields have a value
		mandatoryFilled <-
			vapply(register_fieldsMandatory,
						 function(x) {
						 	!is.null(input[[x]]) && input[[x]] != ""
						 },
						 logical(1))
		mandatoryFilled <- all(mandatoryFilled)

		# enable/disable the submit button
		shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
	})


# Submit Button -----------------------------------------------------------
	# action to take when submit button is pressed
	observeEvent(input$submit, {
		saveData(formData())
	})


# Format Data -------------------------------------------------------------
	formData <- reactive({
		data <- sapply(all_register_fields, function(x) input[[x]])
		data <- c(data, timestamp = epochTime())
		data <- t(data)
		data
	})
}

# Run the application
shinyApp(ui = ui, server = server)

