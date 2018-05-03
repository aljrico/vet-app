body <- dashboardBody(
	dashboardBody(
		tags$head(
			tags$link(rel = "stylesheet", type = "text/css", href = "font.css")
		)
	),

	tabItems(

	# Register Form -----------------------------------------------------------
		tabItem(tabName = "register",

						# Call
						shinyjs::useShinyjs(),
						shinyjs::inlineCSS(appCSS),

						div(id = "form",
								titlePanel("New Pet"),

								textInput(inputId = all_register_fields[[1]], label = labelMandatory(register_fields_names[[1]]), ""),
								textInput(inputId = all_register_fields[[2]], label = labelMandatory(register_fields_names[[2]]), ""),
								selectInput(inputId = all_register_fields[[3]], label = register_fields_names[[3]], colours),
								textInput(inputId = all_register_fields[[5]], label = labelMandatory(register_fields_names[[5]]), ""),
								textInput(inputId = all_register_fields[[6]], label = labelMandatory(register_fields_names[[6]]), ""),
								selectInput(inputId = all_register_fields[[7]], label = register_fields_names[[7]], pet_mood),
								checkboxInput(inputId = all_register_fields[[4]], label = labelMandatory(register_fields_names[[4]]), FALSE),
								actionButton("submit", "Submit", class = "btn-primary")
								),

								shinyjs::hidden(
									span(id = "submit_msg", "Submitting..."),
									div(id = "error",
											div(br(), tags$b("Error: "), span(id = "error_msg"))
									)
								),
								shinyjs::hidden(
									div(id = "thankyou_msg",
											h3("Thanks, your register was submitted successfully!"),
											actionButton("submit_another", "Submit another response", class = "btn-primary")
											)
																)
		),

# Home Page ---------------------------------------------------------------
		tabItem(tabName = "home",
						div(
							id = "appDesc",
							includeMarkdown(file.path("ui","appDesc.md"))
						)
		)
	)
)



