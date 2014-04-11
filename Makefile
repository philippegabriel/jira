#!/usr/bin/make -f
# philippeg apr2014
# Fetch issues from jira sing the SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean reallyclean check test
.SECONDARY:
###################customise this section###################################
release=clearwater
year=2013
#targets=CAInflow.allYears.allReleases.csv CAOutflow.allYears.allReleases.csv
#targets+=CAInflow.$(release).$(year).csv CAOutflow.$(release).$(year).csv
targets=CAInflow.$(release).$(year).bySprint.byTeams.csv 
targets+=CAOutflow.$(release).$(year).bySprint.byTeams.csv
####################autogen variables#######################################
#jira server params, read from .config file
host=$(lastword $(shell grep 'host' .config))
dbname=$(lastword $(shell grep 'dbname' .config))
username=$(lastword $(shell grep 'username' .config))
password=$(lastword $(shell grep 'password' .config))
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
setJiraPass=export PGPASSWORD=$(password)
###################rules#####################################################
all: $(targets)
%.allYears.allReleases.csv: %.allYears.allReleases.sql
	$(setJiraPass) ; $(ConnectToJira) --field-separator="," --no-align --tuples-only -f  $< > $@
%.$(release).$(year).csv: %.allYears.allReleases.csv
	cat $< | grep -i $(release) | grep $(year) > $@	
%.$(release).$(year).bySprint.byTeams.csv: %.$(release).$(year).csv
	cat $< | perl map2team.pl teamMap.csv > $@
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f *.plot 
reallyclean: clean
	rm -f $(targets)
################testing######################################################
test: CAOutflowByDateAndRelease.csv













	

   





