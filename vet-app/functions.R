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
	fileName <- sprintf("%s_%s.csv",
											humanTime(),
											digest::digest(data))

	write.csv(x = data, file = file.path(registers_directory, fileName),
						row.names = FALSE, quote = TRUE)
}
