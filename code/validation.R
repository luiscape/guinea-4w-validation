# Script for downloading Guinea 4W data,
# executing validation tests, and storing
# data into a DataStore on HDX.

# Dependencies
library(RCurl)
library(RJSONIO)

###################
## Configuration ##
###################
args <- commandArgs(T)
PATH = args[1]
gdocs_url = 'http://docs.google.com/spreadsheets/d/1_TFjKh_rcZmYFjgEDhDXoya16piFZHMpmZgLzrqlS5Y/export?format=csv&gid=2125848767&single=true'

# ScraperWiki helper script.
onSw <- function(p = NULL, l = 'tool/', d = TRUE) {
	if (d) return(paste0(l, p))
	else return(p)
}

# Helper functions
source(onSw('code/write_tables.R'))
source(onSw('code/sw_status.R'))

# Function to validate the spreadsheet.
validateData <- function(path = NULL) {
	# Loading data
	data <- read.csv(path)
	data <- data[-1,]  # Removing HXL tags row.

	cat('-------------------------------------\n')
	cat('Performing validation tests.\n')
	cat('-------------------------------------\n')

	#################
	# Configuration #
	#################
	n_cols = 9  # Number of original columns / variables.
  sector_names = c("Coordination", "Surveillance & suivi", "Prise en charge", "Gestion des données", "Recherche", "Communication", "Gestion des corps", "Soutien nutritionnel", "Logistique", "Soutien social", "Sécurité")
	column_names = c("Region","P_Code","Sector","Activity_Type","Organisation","Activity_Description","Start_Date","End_Date","Comments")
	place_names = c("Conakry","Siguiri","Coyah","Dalaba", "Forecariah", "Labé", "Lelouma", "Pita", "Nzérékoré", "Beyla", "Boffa", "Boké", "Dabola", "Dinguiraye", "Dubreka", "Faranah", "Fria", "Gaoual", "Guéckédou", "Kankan", "Kérouané", "Kindia", "Kissidougou", "Koubia", "Koundara", "Kouroussa", "Lola", "Macenta", "Mali", "Mamou", "Mandiana", "Télimélé", "Tougue", "Yomou")
	# sector_names = c("Communication","Coordination","Finance","Gestion des corps","Gestion des donnés","Logistiques","Prise en charge","Recherche","Sécurité","Soutien nutritionnel et social","Surveillance & suivi","Transport & diagnostiques")

	#########
	# Tests #
	#########
  
	# Test for number of original rows.
	cat('Testing original number of columns | ')
	if (ncol(data) == n_cols) {
    test_it <- data.frame(name = paste("Original number of columns is", n_cols) , success = TRUE)
    cat('SUCCESS\n')
	}
	else {
	  test_it <- data.frame(name = paste("Original number of columns is", n_cols) , success = FALSE)
    cat('FAIL\n')
	}
  
  # creating a tests data.frame
  test_df <- test_it
  
	# Testing for the correct columns names.
	cat('Testing for original column names | ')
	if (any(names(data) %in% column_names) == FALSE) {
	  test_it <- data.frame(name = paste("Original column names") , success = FALSE)
    cat('FAIL\n')
	}
	else {
	  test_it <- data.frame(name = paste("Original column names") , success = TRUE)
    cat('SUCCESS\n')
	}
  
  # adding test.
	test_df <- rbind(test_df, test_it)

	# Test for the correct place names.
	cat('Testing place names | ')
	if (any((data$Region %in% place_names) == FALSE)) {
	  test_it <- data.frame(name = paste("Original column names") , success = FALSE)
    cat('FAIL\n')
	}
	else {
	  test_it <- data.frame(name = paste("Original column names") , success = TRUE)
    cat('SUCCESS\n')
	}

	# Test for correct sector names.
	cat('Testing sector names | ')
	if (any((data$Sector %in% sector_names) == FALSE)) {
	  test_it <- data.frame(name = paste("Sector names are correct") , success = FALSE)
    cat('FAIL\n')
	}
	else {
	  test_it <- data.frame(name = paste("Sector names are correct") , success = TRUE)
    cat('SUCCESS\n')
	}
  
  # Adding test results.
  test_df <- rbind(test_df, test_it)

	# Test for organization object type.
	cat('Testing organization object type | ')
	test_vector <- as.numeric(as.character(data$Organisation))
	if (any(!is.na(test_vector)) == TRUE) {
	  test_it <- data.frame(name = paste("Organization object type is correct") , success = FALSE)
    cat('FAIL\n')
	}
	else {
	  test_it <- data.frame(name = paste("Organization object type is correct") , success = TRUE)
    cat('SUCCESS\n')
	}
  
	# Adding test results.
	test_df <- rbind(test_df, test_it)

	# Test for the object type in start date.
	cat('Testing start date object type | ')
	test_vector <- nchar(as.character(data$Start_Date))
	if(any(na.omit(test_vector) %in% c(0, 8, 9, 10) == FALSE)) {
	  test_it <- data.frame(name = paste("Start date object type (date)") , success = FALSE)
    cat('FAIL\n')
	}
	else {
	  test_it <- data.frame(name = paste("Start date object type (date)") , success = TRUE)
    cat('SUCCESS\n') 
  }
  
	# Adding test results.
	test_df <- rbind(test_df, test_it)

	# Test for the object type in start date.
	cat('Testing end date object type | ')
	test_vector <- nchar(as.character(data$End_Date))
	if(any(na.omit(test_vector) %in% c(0, 8, 9, 10) == FALSE)) {
	  test_it <- data.frame(name = paste("End date object type (date)") , success = FALSE)
    cat('FAIL\n')
	}
	else {
	  test_it <- data.frame(name = paste("End date object type (date)") , success = TRUE)
    cat('SUCCESS\n')
	}
  
	# Adding test results.
	test_df <- rbind(test_df, test_it)

	cat('-------------------------------------\n')
  
  # writing JSON
	sink(onSw("http/test_results.json"))
	  cat(toJSON(test_df))
	sink()

	return(data)
}

###################
### ScraperWiki ###
###################

# ScraperWiki wraper function
runScraper <- function(p) {
	download.file(url=gdocs_url, destfile=p, method='wget')
	data <- suppressWarnings(validateData(p))
	if (is.data.frame(data)) write.csv(data, p, row.names = F)
	else stop("Could not write CSV: isn't data.frame.")
}

# ScraperWiki-specific error handler
# Changing the status of SW.
tryCatch(runScraper(PATH),
         error = function(e) {
           cat('Error detected ... sending notification.')
           system('mail -s "Guinea 3W: Validation script failed." luiscape@gmail.com')
           changeSwStatus(type = "error", message = "Validation failed.")
           { stop("!!") }
         }
)

# If success:
changeSwStatus(type = 'ok')
