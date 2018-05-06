
#Reading Table from a file
vals <- reactiveValues()
vals$Data <- setnames(data.table(
	read_register()[,c("pet_name")],
	read_register()[,c("pet_species")],
	read_register()[,c("owner_surname")],
	read_register()[,c("owner_name")]
),c("Pet's Name","Species","Owner Surname","Owner Name")
)

# Showing table
output$search_files <- renderUI({
	fluidPage(
		box(width=12,
				h3(strong("Actions on datatable with buttons"),align="center"),
				hr(),
				column(6,offset = 6,
							 ##Grouped button
							 HTML('') ),
				##Rendering the datatable
				column(12,dataTableOutput("table_registers")))
	)
})
##The code may seem weird but we will modify it later
output$table_registers <- renderDataTable({ DT=vals$Data; datatable(DT, selection = "single")})
