#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# The Google Spreadsheets Connection
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Reminder ----------------------------------------------------------------
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# The first time you should do something like
# (1) In R execute:
#     library(googlesheets)
#     token <- gs_auth(cache = FALSE)
# (2) The browser will be open and you need to autenticate yourself
# (3) Back in R may want to save your token for future usage:
#     gd_token()
#     saveRDS(token, file = "~/Downloads/googlesheets_token.rds")


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Autenticate on Google spreadsheets --------------------------------------
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Parameters for function getGoogleSpreadsheetMetadata
# gs_token_file_path : Path where your token is stored

autenticateOnGoogleSpreadsheets <- function(
  gs_token_file_path = paste0(dirname(sys.frame(1)$ofile),"/credentials/googlesheets_token.rds")
  ){
  require(googlesheets)

  # Autenticate on Google spreadsheets using the given token
  output <- try(gs_auth(token = gs_token_file_path),silent = TRUE)

  # Prepare and return output. Notes: If transaction is
  # * OK then output will have the class like "Token2.0"
  # * KO then output will have other class (e.g.,"simpleError")
  if(class(output)[1] == "try-error"){
    return(attributes(output)$condition)
  }else{
    return(output)
  }
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Get Google spreadsheet metadata -----------------------------------------
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Parameters for function getGoogleSpreadsheetMetadata
# gs_token_file_path : Path where your token is stored
# spreadsheet_name   : Spreadsheet name as shown in Google

getGoogleSpreadsheetMetadata <- function(
  spreadsheet_name = "Feature importance | Payer again"
  ,gs_token_file_path = paste0(dirname(sys.frame(1)$ofile),"/credentials/googlesheets_token.rds")
  ){
  # Initialize output variable
  output <- data.frame()

  # Autenticate on Google spreadsheets using the given token
  try_to_autenticate <- autenticateOnGoogleSpreadsheets(gs_token_file_path)

  if(class(try_to_autenticate)[1] == "simpleError"){
    # Update output attributes
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Authentification error."

    return(output)
    }

  # Get metadata from desired Google spreadsheet
  metadata <- try(gs_title(spreadsheet_name), silent = TRUE)

  # Prepare and return output. Notes: If transaction is
  # OK then output will have the class "googlesheet"
  # KO then output will have other class (e.g.,"simpleError")
  if(class(metadata)[1] == "try-error"){
    # Update output attributes
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Authentification OK. But couldn't load requested spredsheet."
  }else{
    output <- metadata

    # Update output attributes
    attributes(output)$status = "SUCCESS"
    attributes(output)$message = "OK"
  }

    return(output)
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Get Google spreadsheet as list of data frames ---------------------------
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Parameters for function getGoogleSpreadsheetAsListOfDataframes
# gs_token_file_path : Path where your token is stored
# spreadsheet_name   : Spreadsheet name as shown in Google
# required_sheets    : List of required sheets names, e.g., c("Sheet1", "Sheet 2")
#                      Use NA to retrieve all available sheets

getGoogleSpreadsheetAsListOfDataframes <- function(
  gs_token_file_path = paste0(dirname(sys.frame(1)$ofile),"/credentials/googlesheets_token.rds")
  ,spreadsheet_name = "Feature importance | Payer again"
  ,required_sheets = c("feature_importance_dc"
                       ,"feature_importance_wc"
                       ,"feature_importance_ml"
                       )
  , sleep_time = 1
  ){
  # Initialize output variable
  output <- list()

  # Open the desired Google spreadsheet
  target_spreasheet <- getGoogleSpreadsheetMetadata(spreadsheet_name, gs_token_file_path)
  if(attributes(target_spreasheet)$status == "FAILURE"){
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Can't access requested spreadsheet."
    return(output)
  }

  # Restrict request to existing sheets
  list_of_existing_sheets <- try(gs_ws_ls(ss = target_spreasheet), silent = TRUE)
  if(class(list_of_existing_sheets)[1] == "try-error"){
    # Update output attributes
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Connection broke when reading sheets list."
    return(output)
  }

  # Select sublist if required
  if(length(required_sheets) == 0){
    valid_required_sheets <- list_of_existing_sheets
  }else{
    valid_required_sheets <- intersect(list_of_existing_sheets,required_sheets)
  }

  # Stop if there are no valid sheets to get from the spreadsheet
  if(length(valid_required_sheets) == 0){
    attributes(output)$status = "SUCCESS"
    attributes(output)$message = "Required sheets were not found in the spreadsheet."
    return(output)
  }

  # Get all required sheets
  for(sheet_ in valid_required_sheets){
    Sys.sleep(sleep_time)
    current_sheet <- try(gs_read(target_spreasheet, ws = sheet_) , silent = TRUE)

    # if OK you should be looking at message like this:
    # Accessing worksheet titled ws_name.
    # Downloading: 1.3 kB
    # Parsed with column specification:
    # ...

    if(class(current_sheet)[1] != "try-error"){
      output[[sheet_]] <- current_sheet
    }

  }

  # Update output attributes
  attributes(output)$status = "SUCCESS"
  attributes(output)$message = paste0("Sheets properly processed: ",length(output),".")

  return(output)
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# List all spreadsheets of the user  --------------------------------------
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Parameters for function listGoogleSpreadsheet
# gs_token_file_path : Path where your token is stored
# owned   : Logical (default = TRUE) to include spreadsheets owned
# read_permission    : Logical (default = TRUE) to include spreadsheets which user has read permissions
# write_permission   : Logical (default = TRUE) to include spreadsheets which user has write permissions

listGoogleSpreadsheet <- function(
  gs_token_file_path = paste0(dirname(sys.frame(1)$ofile),"/credentials/googlesheets_token.rds")
  ,owned = TRUE
  ,read_permission = TRUE
  ,write_permission = TRUE
){
  # Initialize output variable
  output <- list()

  # Autenticate on Google spreadsheets using the given token
  try_to_autenticate <- autenticateOnGoogleSpreadsheets(gs_token_file_path)

  if(class(try_to_autenticate)[1] == "simpleError"){
    # Update output attributes
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Authentification error."

    return(output)
  }

  # Check existance of the spreadsheet
  spreadsheets_list<-try({gs_ls()}, silent = TRUE)
  author_name<-try({gd_user();unlist(strsplit(user_info$user$emailAddress, "@socialpoint.es"))[1]}, silent = TRUE)
  # Prepare and return output. Notes: If transaction is
  # OK then output will have the class "googlesheet"
  # KO then output will have other class (e.g.,"simpleError")
  if(class(spreadsheets_list)[1] == "try-error"){
    # Update output attributes
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Authentification OK. But couldn't list all spreadsheets."
  }else if(class(author_name)[1] == "try-error"){
    # Update output attributes
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Authentification OK. But couldn't get user information"
  }
  spreadsheets_filtered_list<-rep(1,nrow(spreadsheets_list))
  if(read_permission) spreadsheets_filtered_list<-spreadsheets_filtered_list*as.numeric(grepl("r",spreadsheets_list$perm))
  if(write_permission) spreadsheets_filtered_list<-spreadsheets_filtered_list*as.numeric(grepl("w",spreadsheets_list$perm))
  if(owned) spreadsheets_filtered_list<-spreadsheets_filtered_list*as.numeric(spreadsheets_list$author == author_name)
  output <- spreadsheets_list[spreadsheets_filtered_list == 1,]

  # Update output attributes
  attributes(output)$status = "SUCCESS"
  attributes(output)$message = "OK"

  return(output)
}



#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Insert Data Frame into a Google spreadsheet  ----------------------------
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Parameters for function getGoogleSpreadsheetAsListOfDataframes
# gs_token_file_path : Path where your token is stored
# spreadsheet_name   : Spreadsheet name as shown in Google
# sheet_name    : Sheet name as shown in Google
# data_frame    : R data frame to send to Google Spreadsheet

insertDataFrameintoGoogleSpreadSheet <- function(
  gs_token_file_path = paste0(dirname(sys.frame(1)$ofile),"/credentials/googlesheets_token.rds")
  ,spreadsheet_name = NA
  ,sheet_name = NA
  ,data_frame = NA
){
  # Initialize output variable
  output <- list()
  if(is.na(gs_token_file_path) || is.null(gs_token_file_path) || length(gs_token_file_path) == 0){
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Empty token path. Please, insert a token path"
    return(output)
  }

  if(is.na(spreadsheet_name) || is.null(spreadsheet_name) || length(spreadsheet_name) == 0){
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Empty sheet name. Please, insert a spread sheet name"
    return(output)
  }
  if(is.na(sheet_name) || is.null(sheet_name) || length(sheet_name) == 0){
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Empty sheet name. Please, insert a sheet name"
    return(output)
  }
  if(is.na(data_frame) || is.null(data_frame) || nrow(data_frame) == 0){
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Data Frame variable is empty. Please check the data frame you are trying to insert."
    return(output)
  }

  # Check existance of the spreadsheet
  spreadsheet_list<-listGoogleSpreadsheet(gs_token_file_path, write_permission = FALSE, owned = FALSE, read_permission = FALSE)
  if(attributes(spreadsheet_list)$status == "FAILURE"){
    attributes(output)$status = "FAILURE"
    attributes(output)$message = "Can't access requested spreadsheet."
    return(output)
  }
  if(spreadsheet_name %in% spreadsheet_list$sheet_title){
    row_spreadsheet<-spreadsheet_list[spreadsheet_name == spreadsheet_list$sheet_title,]
    if(!grepl("w",row_spreadsheet$perm)){
      stop("No permissions to write!!")
    }
    target_spreasheet <- getGoogleSpreadsheetMetadata(spreadsheet_name, gs_token_file_path)
    if(attributes(target_spreasheet)$status == "FAILURE"){
      attributes(output)$status = "FAILURE"
      attributes(output)$message = "Can't access requested spreadsheet."
      return(output)
    }

    # Restrict request to existing sheets
    list_of_existing_sheets <- try(gs_ws_ls(ss = target_spreasheet), silent = TRUE)
    if(class(list_of_existing_sheets)[1] == "try-error"){
      # Update output attributes
      attributes(output)$status = "FAILURE"
      attributes(output)$message = "Connection broke when reading sheets list."
      return(output)
    }

    if(sheet_name %in% list_of_existing_sheets){
      sheet_name_tmp<-paste0(sheet_name,substring(tempfile(pattern = "", tmpdir = ""),first = 2))
      new_sheet_gs<-try({gs_ws_new(target_spreasheet, ws_title = sheet_name_tmp, input = data_frame, trim = TRUE, col_names = TRUE)},silent = TRUE)
    }else{
      new_sheet_gs<-try({gs_ws_new(target_spreasheet, ws_title = sheet_name, input = data_frame, trim = TRUE, col_names = TRUE)}, silent = TRUE)
    }
    if(attributes(new_sheet_gs)$class[1] == "try-error"){
      attributes(output)$status = "FAILURE"
      attributes(output)$message = "Error creating the new sheet"
      return(output)
    }

  }else{
    write.csv(data_frame, file = paste0("/tmp/test.csv"))
    upload_file_to_spreadsheet<-try({gs_upload(paste0("/tmp/test.csv"),spreadsheet_name)}, silent = TRUE)
    if(attributes(upload_file_to_spreadsheet)$class == "try-error"){
      attributes(output)$status = "FAILURE"
      attributes(output)$message = "Can't upload file into requested spreadsheet."
      return(output)
    }
    target_spreasheet <- getGoogleSpreadsheetMetadata(spreadsheet_name, gs_token_file_path)
    if(attributes(target_spreasheet)$status == "FAILURE"){
      attributes(output)$status = "FAILURE"
      attributes(output)$message = "Can't access requested spreadsheet."
      return(output)
    }
    rename_sheet<-try({gs_ws_rename(target_spreasheet, from = 1, to = sheet_name)}, silent = TRUE)
    if(attributes(rename_sheet)$class == "try-error"){
      attributes(output)$status = "FAILURE"
      attributes(output)$message = "Can't rename new sheet created into the new spreadsheet."
      return(output)
    }
    #new_spreadsheet <- try({gs_new(spreadsheet_name, ws_title = sheet_name, input = data_frame, trim = TRUE, col_names = TRUE)}, silent = TRUE)
    # if(attributes(new_spreadsheet)$class == "try-error"){
    #   attributes(output)$status = "FAILURE"
    #   attributes(output)$message = "Can't create the requested spreadsheet."
    #   return(output)
    # }

  }

  output<-paste0(spreadsheet_name," > ", sheet_name)
  # Update output attributes
  attributes(output)$status = "SUCCESS"
  attributes(output)$message = "Sheet properly created"

  return(output)
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Examples ----------------------------------------------------------------
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# example_ <- getGoogleSpreadsheetAsListOfDataframes(
#   spreadsheet_name = "Marketing DP Analytics"
#   ,required_sheets = NA
#   )


# a <- getGoogleSpreadsheetAsListOfDataframes(gs_token_file_path = "~/Downloads/googlesheets_token.rds"
# ,spreadsheet_name = "Marketing Budgeting Tool _ Assumptions"
# , required_sheets = NA
# )
