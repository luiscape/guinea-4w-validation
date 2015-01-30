#!/bin/bash

# Config
PATH='tool/data/guinea-4w-data.csv'
CKAN_API_KEY='XXX'

# Downloading and validating file
~/R/bin/Rscript ~/tool/code/validation.R $PATH

# Creating / updating datastore
source venv/bin/activate
python ~/tool/code/create_datastore.py $CKAN_API_KEY $PATH
