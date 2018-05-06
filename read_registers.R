library(data.table)

read_register <- function(){
	register_files = list.files(path = "./registers_data/",pattern="*.csv", full.names = TRUE)
	myfiles = lapply(register_files, read.delim)

	registers_data = do.call(base::rbind, c(lapply(register_files, fread), fill = TRUE))
	return(registers_data)
}

