

# Server

server <- function(input, output, session) {

# Login Check -------------------------------------------------------------

	# Define Variable
	Logged = FALSE
	my_username <- "test"
	my_password <- "test"
	USER <- reactiveValues(Logged = Logged)

	# Check username and password
	observe({
		if (USER$Logged == FALSE) {
			if (!is.null(input$login_button)) {
				if (input$login_button > 0) {
					Username <- isolate(input$userName)
					Password <- isolate(input$passwd)
					Id.username <- which(my_username == Username)
					Id.password <- which(my_password == Password)
					if (length(Id.username) > 0 & length(Id.password) > 0) {
						if (Id.username == Id.password) {
							USER$Logged <- TRUE
						}
					}
				}
			}
		}
	})

	# React to 'username' and 'password'
	observeEvent(input$login_button, {
		if(USER$Logged) {
			shinyjs::show(id = "login_success")
			shinyjs::hide(id = "login_failure")
			shinyjs::show(id = "sidebar_menu")
		}
		if(!USER$Logged & !is.null(input$login_button)) shinyjs::show(id = "login_failure")
	})

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
	# Format Data
	formData <- reactive({
		data <- sapply(all_register_fields, function(x) input[[x]])
		data <- c(data, timestamp = epochTime())
		data <- t(data)
		data
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

	# Show Registers Table ----------------------------------------------------
	source("source_files/registers_search_table.R", local = TRUE)


# Automatic Data Refresh --------------------------------------------------
	sourceData <- reactive({
		invalidateLater(1000000,session)

		read_register()
	})

}

