#!/bin/bash -e
#
# Exec SQL queries for each teams
#
deployTarget=/var/www/ely
cp -f *.csv $deployTarget/csvBCM/
cp -f *.html *.css $deployTarget/htmlBCM/
cp -f index.html *.css $deployTarget/

