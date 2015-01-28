# Script for downloading Guinea 4W data,
# executing validation tests, and storing
# data into a DataStore on HDX.

# Dependencies
library(RCurl)

###################
## Configuration ##
###################

PATH = 'tool/data/guinea_4w_data.csv'
url = 'https://docs.google.com/spreadsheets/d/1_TFjKh_rcZmYFjgEDhDXoya16piFZHMpmZgLzrqlS5Y/export?format=csv&gid=2125848767&single=true'

# ScraperWiki helper script.
onSw <- function(d = T, p = NULL, l = 'tool/') {
	if (d) return(paste0(l, p))
	else return(p)
}

# Function to download the file into a specific location.
downloadFile <- function(u = NULL, p = NULL) {
	download.file(u, p, method = 'wget')
}

# Function to validate the spreadsheet.
validateData <- function(p = NULL) {
	# Loading data
	data <- read.csv(p)
	data <- data[-1,]  # Removing HXL tags row.

	cat('-------------------------------------\n')
	cat('Performing validation tests.\n')
	cat('-------------------------------------\n')

	#################
	# Configuration #
	#################
	n_cols = 8  # Number of original rows
	column_names = c("Region","P_Code","Sector","Activity_Type","Organisation","Activity_Description","Start_Date","End_Date","Comments")
	place_names = c("Beyla","Boffa","Boké","Conakry","Coyah","Dalaba","Dinguiraye","Dubréka","Faranah","Forecariah","Fria","Gaoual","Guéckédou","Kankan","Kérouané","Kindia","Kissidougou","Koubia","Koundara","Kouroussa","Labé","Lelouma","Lola","Macenta","Mali","Mamou","Mandiana","N'zérékoré","National","Pita","Siguiri","Télimélé","Tougue","Yomou")
	sector_names = c("Communications","Coordination","Finance","Gestion des corps","Gestion des donnés","Logistiques","Prise en charge","Recherche","Sécurité","Soutien nutritionnel et social","Surveillance & suivi","Transport & diagnostiques")

	# Test for number of original rows.
	cat('Testing original number of rows | ')
	if (ncol(data) != n_cols) cat('SUCCESS\n')
	else cat('FAIL\n')

	# Testing for the correct columns names.
	cat('Testing for original column names | ')
	if (any(names(data) %in% column_names) == FALSE) cat('FAIL\n')
	else cat('SUCCESS\n')

	# Test for the correct place names.
	cat('Testing place names | ')
	if (any((data$Region %in% place_names) == FALSE)) cat('FAIL\n')
	else cat('SUCCESS\n')

	# Test for correct sector names.
	cat('Testing sector names | ')
	if (any((data$Sector %in% sector_names) == FALSE)) cat('FAIL\n')
	else cat('SUCCESS\n')

	# Test for organization object type.
	cat('Testing organization object type | ')
	test_vector <- as.numeric(data$Organisation)
	if (any(!is.na(test_vector)) == TRUE) cat('FAIL\n')
	else cat('SUCCESS\n')

	# Test for the object type in start date.
	cat('Testing start date object type | ')
	test_vector <- nchar(as.character(data$Start_Date))
	if(any(na.omit(test_vector) != 10)) cat('FAIL\n')
	else cat('SUCCESS\n')

	# Test for the object type in start date.
	cat('Testing end date object type | ')
	test_vector <- nchar(as.character(data$End_Date))
	if(any(na.omit(test_vector) != 10)) cat('FAIL\n')
	else cat('SUCCESS\n')

	cat('-------------------------------------\n')
}

###################
### ScraperWiki ###
###################

# ScraperWiki wraper function
runScraper <- function(p) {
	downloadFile(url, p)
	validateData(p)
}

runScraper(PATH)

# ScraperWiki-specific error handler
# Changing the status of SW.
# tryCatch(runScraper(),
#          error = function(e) {
#            cat('Error detected ... sending notification.')
#            system('mail -s "Guinea 3W: Validation script failed." luiscape@gmail.com')
#            changeSwStatus(type = "error", message = "Validation failed.")
#            { stop("!!") }
#          }
# )

# # If success:
# changeSwStatus(type = 'ok')
