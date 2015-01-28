#!/bin/bash

# Creating / updating datastore
source venv/bin/activate
python ~/tool/code/create-datastore.py XXX

# Run validation script.
# ~/R/bin/Rscript ~/tool/code/scraper.R