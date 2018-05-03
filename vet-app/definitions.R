
# Parameteres and General Definitions -------------------------------------


# Colours of the pet
colours <- sort(c("Black",
									"White",
									"Red",
									"Yellow",
									"Brown",
									"Grey",
									"Blue",
									"Green"
									))

# Personality of the pet
pet_mood <- c("Good Guy",
							"Nervous",
							"Agressive"
							)


# Pet's Information requiered to the register of the pet
pet_register_fields <- c("pet_name",
												 "pet_species",
												 "pet_colour",
												 "castrated",
												 "pet_mood"
												 )

# Owner's Information required for registering the pet
owner_register_fields <- c("owner_name",
													 "owner_surname",
													 "owner_id",
													 "phone_number",
													 "gender"
													 )

all_register_fields <- c(pet_register_fields,
												 owner_register_fields
												 )


list_fields <- as.list(all_register_fields)
names(list_fields) <- all_register_fields

# Set Public Names
	list_fields[["pet_name"]] <- "Pet's Name"
	list_fields[["pet_species"]] <- "Species"
	list_fields[["pet_colour"]] <- "Cape"
	list_fields[["castrated"]] <- "Castrated?"
	list_fields[["pet_mood"]] <- "Pet's Mood"
	list_fields[["owner_name"]] <- "Human's Name"
	list_fields[["owner_surname"]] <- "Human's Surname"
	list_fields[["owner_id"]] <- "Human ID"
	list_fields[["phone_number"]] <- "Phone Number"
	list_fields[["gender"]] <- "Gender"


register_fieldsMandatory <- all_register_fields[c(1,2,4,6,7,8,9)]

registers_directory <- file.path("registers_data")

