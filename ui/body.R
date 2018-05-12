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
								column(6,
											 titlePanel("Pet"),

											 textInput(inputId = "pet_name", label = labelMandatory(list_fields[["pet_name"]]), ""),
											 selectInput(inputId = "pet_species", label = labelMandatory(list_fields[["pet_species"]]), species_list),
											 selectInput(inputId = "pet_colour", label = list_fields[["pet_colour"]], colours),
											 selectInput(inputId = "pet_mood", label = list_fields[["pet_mood"]], pet_mood),
											 radioButtons(inputId = "castrated", label = labelMandatory(list_fields[["castrated"]]), c("Yes","No"), selected = character(0)),
											 radioButtons(inputId = "gender", label = labelMandatory(list_fields[["gender"]]), c("Female","Male"), selected = character(0))



											 ),
								column(6,
											 titlePanel("Owner"),

											 textInput(inputId = "owner_name", label = labelMandatory(list_fields[["owner_name"]]), ""),
											 textInput(inputId = "owner_surname", label = labelMandatory(list_fields[["owner_surname"]]), ""),
											 textInput(inputId = "owner_id", label = labelMandatory(list_fields[["owner_id"]]), ""),
											 textInput(inputId = "phone_number", label = labelMandatory(list_fields[["phone_number"]]), "")


								),
								column(6, offset = 1,
											 actionButton("submit", "Submit", class = "btn-primary", style="float:right", width = "100px")
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

# Register Search ---------------------------------------------------------

	tabItem(tabName = "register_search",
					div(
						id = "appDesc",
						uiOutput("search_files")
					)
	),



# Home Page ---------------------------------------------------------------
		tabItem(tabName = "home",
						div(
							id = "appDesc"
						)
		)
	)
)



