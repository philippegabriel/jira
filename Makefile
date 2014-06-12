#!/usr/bin/make -f
# philippeg mar2014
# Fetch all jira issues for project SCTX
# Plot by month, by release
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login jiraquery clean reallyclean check test
####################autogen variables#######################################
jiratargets=SCTXbyDateAndRelease.csv SCTXSumByMonth.csv
gnuplottargets=SCTX.byQuarter.png
gnuplottargets+=SCTX.byMonth.png
#jira server params, read from .config file
host=$(lastword $(shell grep 'host' .config))
dbname=$(lastword $(shell grep 'dbname' .config))
username=$(lastword $(shell grep 'username' .config))
password=$(lastword $(shell grep 'password' .config))
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
setJiraPass=export PGPASSWORD=$(password)
###################rules#####################################################
all: SCTX.byQuarter.csv SCTX.byMonth.csv $(gnuplottargets) 
jiraquery: $(jiratargets)
%.csv: %.sql
	$(setJiraPass) ; $(ConnectToJira) --field-separator="," --no-align --tuples-only -f  $< > $@

SCTX.byMonth.csv: SCTXbyDateAndRelease.csv
	./list2matrix.pl xsreleases < $< > $@

SCTX.byQuarter.csv: SCTX.byMonth.csv	
	./month2quarter.pl < $< > $@

%.byQuarter.png: %.byQuarter.csv
	gnuplot -e "title='XenServer LCM Quarterly';outfile='$@';infile='$<';xmin='2';xmax='26';ylabel='# issues';xlabel='Quarter'"  csv2stackedLines.gnuplot
%.byMonth.png: %.byMonth.csv
	gnuplot -e "title='XenServer LCM Monthly';outfile='$@';infile='$<';xmin='5';xmax='78';ylabel='# issues';xlabel='Month'"  csv2stackedLines.gnuplot
%.thumb.png: %.png
	convert $< -thumbnail x200 $@
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f $(gnuplottargets)  SCTX.byQuarter.csv SCTX.byMonth.csv
reallyclean: clean
	rm -f $(jiratargets)
################testing######################################################
test: test.csv















	

   





