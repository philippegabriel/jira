#!/bin/bash -e
#
# Exec SQL queries for each teams
#
deployTarget=/var/www/ely
cp -f *.csv $deployTarget/csvBC-M/
cp -f *.html *.css $deployTarget/htmlBC-M/
cp -f index.html *.css $deployTarget/

