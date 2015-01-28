## Simple script to clean data 
## for the Guinea 4W work.

# Dependencies
library(stringr)

# SW helper function
onSw <- function(file_loc = NULL, d = F, root = 'tool/') {
  # sanity check
  if (is.null(file_loc)) stop("SW Helper: Please provide a file_loc.")
  
  # function
  file_path = paste0(root, file_loc)
  if (d) return(file_path)
  else return(file_loc)
}


file_path = onSw('data/guinea_4w_data.csv')

# Loading data
cleanData <- function(file_path) {
  data <- read.csv(file_path)
  data <- data[-1,]  # getting rid of the HXL tags
  data$Region <- as.character(data$Region)
  data$Region <- str_trim(data$Region)
  
  # Fixing differences
  findReplace <- function(df = NULL, dic = onSw('data/find_replace.csv')) {
    dic <- read.csv(dic)
    for (i in 1:nrow(dic)) {
      df$Region <- ifelse(df$Region == dic$find[i], dic$replace[i], df$Region)
    }
    return(df)
  }

  data <- findReplace(data)
}

