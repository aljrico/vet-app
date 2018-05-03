
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

register_fields_names <- c("Pet's Name",
													 "Species",
													 "Hair Colour",
													 "Castrated?",
													 "Human's Name",
													 "Human's Surname",
													 "Pet's Mood"
													 )

register_fields_names <- c("Pet's Name",
													 "Species",
													 "Hair Colour",
													 "Castrated?",
													 "Human's Name",
													 "Human's Surname",
													 "Pet's Mood"
													 )

register_fieldsMandatory <- all_register_fields[c(1,2,4,5,6)]

registers_directory <- file.path("registers")

