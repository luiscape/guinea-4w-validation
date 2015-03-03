#!/bin/bash

# Config
FILE_PATH='tool/data/guinea-4w-data.csv'
CKAN_API_KEY='a6863277-f35e-4f50-af85-78a2d9ebcdd3'

# Downloading and validating file
~/R/bin/Rscript ~/tool/code/validation.R $FILE_PATH > http/validation_log.txt

# Creating / updating datastore
source venv/bin/activate
python ~/tool/code/create_datastore.py $CKAN_API_KEY $FILE_PATH