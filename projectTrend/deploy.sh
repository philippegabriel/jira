#!/bin/bash -e
#
# Exec SQL queries for each teams
#
deployTarget=/local/scratch/dundee
cp -f *.csv $deployTarget/csv/
cp -f *.html *.css $deployTarget/html/
cp -f index.html *.css $deployTarget/

