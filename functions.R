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

# Human (readable) timestamp
humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")


# Save Data Function
saveData <- function(data) {
	crypt <- sprintf("%s_%s.csv",
											humanTime(),
											digest::digest(data))


	filename <- "all_files.csv"
	# if(file.exists(filename)){
	# 	bool <- FALSE
	# }else{
	# 	bool <- TRUE
	# }
	registers_filepath <- file.path(registers_directory, filename)
	write.table(x = data, file = registers_filepath,
						row.names = FALSE, quote = TRUE, append = TRUE, col.names = FALSE, sep = ",")
}
