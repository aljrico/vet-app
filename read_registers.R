library(data.table)

read_register <- function(){
	register_files = list.files(path = "./registers_data/",pattern="*.csv", full.names = TRUE)
	myfiles = lapply(register_files, read.delim)

	registers_data = do.call(base::rbind, c(lapply(register_files, fread), fill = TRUE))
	return(registers_data)
}

read_register <- function(){
	filename <- registers_file
	files_path <- file.path(registers_directory, filename)
	fread(file = files_path)
}
