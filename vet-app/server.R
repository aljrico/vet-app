

# Server

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
	# Save Data
	observeEvent(input$submit, {
		saveData(formData())
	})

	# Confirm submit data en restore empty values
	observeEvent(input$submit, {
		shinyjs::disable("submit")
		shinyjs::show("submit_msg")
		shinyjs::hide("error")

		tryCatch({
			saveData(formData())
			shinyjs::reset("form")
			shinyjs::hide("form")
			shinyjs::show("thankyou_msg")
		},
		error = function(err) {
			shinyjs::html("error_msg", err$message)
			shinyjs::show(id = "error", anim = TRUE, animType = "fade")
		},
		finally = {
			shinyjs::enable("submit")
			shinyjs::hide("submit_msg")
		})
	})


	observeEvent(input$submit_another, {
		shinyjs::show("form")
		shinyjs::hide("thankyou_msg")
	})


	# Format Data -------------------------------------------------------------
	formData <- reactive({
		data <- sapply(all_register_fields, function(x) input[[x]])
		data <- c(data, timestamp = epochTime())
		data <- t(data)
		data
	})
}
