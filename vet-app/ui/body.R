body <- dashboardBody(
		tags$head(
			tags$link(rel = "stylesheet", type = "text/css", href = "font.css")
		),

	tabItems(

	# Register Form -----------------------------------------------------------
		tabItem(tabName = "register",
						# Call
						shinyjs::useShinyjs(),
						shinyjs::inlineCSS(appCSS),

						div(id = "form",

							fluidRow(
								column(4,
											 titlePanel("New Pet"),

											 textInput(inputId = "pet_name", label = labelMandatory(list_fields[["pet_name"]]), ""),
											 textInput(inputId = "pet_species", label = labelMandatory(list_fields[["pet_species"]]), ""),
											 selectInput(inputId = "pet_colour", label = list_fields[["pet_colour"]], colours),
											 selectInput(inputId = "pet_mood", label = list_fields[["pet_mood"]], pet_mood),
											 checkboxInput(inputId = "castrated", label = list_fields[["castrated"]], FALSE),

											 actionButton("submit", "Submit", class = "btn-primary")

											 )

							)

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



