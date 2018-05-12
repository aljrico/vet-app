# Custom Functions --------------------------------------------------------

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


# Save Data Function
saveData <- function(data) {
	filename <- "all_files.csv"
	registers_filepath <- file.path(registers_directory, filename)
	write.table(x = data, file = registers_filepath,
						row.names = FALSE, quote = TRUE, append = TRUE, col.names = FALSE, sep = ",")
}
