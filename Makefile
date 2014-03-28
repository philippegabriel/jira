#!/usr/bin/make -f
# philippeg mar2014
# Fetch all jira issues for project SCTX
# Plot by month, by release
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean genplot genpng test

# List of all XS release 
XSReleases="4.0.1"
XSReleases+="4.1"
XSReleases+="5.0"
XSReleases+="5.5"
XSReleases+="5.6"
XSReleases+="6.0"
XSReleases+="6.0.2"
XSReleases+="6.1"
XSReleases+="6.2"
####################autogen variables#######################################
plotfiles=$(addprefix XenServer.,$(addsuffix .plot, $(XSReleases)))
jiratargets=SCTXbyDateAndRelease.csv SCTXSumByMonth.csv
gnuplottargets=SCTXbyReleaseByMonth.png
#jira server params, read from .config file
host=$(lastword $(shell grep 'host' .config))
dbname=$(lastword $(shell grep 'dbname' .config))
username=$(lastword $(shell grep 'username' .config))
password=$(lastword $(shell grep 'password' .config))
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
setJiraPass=export PGPASSWORD=$(password)
###################rules#####################################################
all: $(jiratargets) $(plotfiles) $(gnuplottargets)
%.csv: %.sql
	$(setJiraPass) ; $(ConnectToJira) --field-separator="," --no-align --tuples-only -f  $< > $@
XenServer.%.plot: $(jiratargets)
	grep  "$*" SCTXbyDateAndRelease.csv | cut -d, -f1 | uniq -c  | perl -npe 's/^\s+(\d+) (\d+)$$/\2,\1/;' > $@
%.png: $(plotfiles)
	gnuplot -e "filename='$@'"  script.gp
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f *.plot $(gnuplottargets)
reallyclean: clean
	rm -f $(jiratargets)
################testing######################################################
test:
	echo $(plotfiles)





	

   





