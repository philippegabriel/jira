#!/usr/bin/make -f
# philippeg mar2014
# Fetch all jira issues for project SCTX
# Plot by month, by release
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login jiraquery clean reallyclean check test
# List of all XS release 
XSReleases=4.0.1
XSReleases+=4.1
XSReleases+=5.0
XSReleases+=5.5
XSReleases+=5.6
XSReleases+=6.0
XSReleases+=6.0.2
XSReleases+=6.1
XSReleases+=6.2
####################autogen variables#######################################
jiratargets=SCTXbyDateAndRelease.csv SCTXSumByMonth.csv
monthplotfiles=$(addprefix XenServer.,$(addsuffix .month.plot, $(XSReleases)))
quarterplotfiles=$(addprefix XenServer.,$(addsuffix .quarter.plot, $(XSReleases)))
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
all: $(monthplotfiles) $(quarterplotfiles) SCTXSum.month.plot SCTXSum.quarter.plot SCTX.byQuarter.csv SCTX.byMonth.csv $(gnuplottargets) 
jiraquery: $(jiratargets)
%.csv: %.sql
	$(setJiraPass) ; $(ConnectToJira) --field-separator="," --no-align --tuples-only -f  $< > $@
XenServer.%.sparse.month.plot: $(jiratargets)
	perl -ne '/XenServer $*[^\.]/ && print' SCTXbyDateAndRelease.csv | cut -d, -f1 | uniq -c | perl -npe 's/^\s+(\d+) (\d+)$$/\2,\1/;' > $@
XenServer.%.month.plot: XenServer.%.sparse.month.plot
	cat $< | perl sparseMonth2Month.pl > $@
XenServer.%.quarter.plot: XenServer.%.month.plot
	cat $< | perl month2quarter.pl > $@

SCTXSum.month.plot: SCTXSumByMonth.csv
	cat $< | perl sparseMonth2Month.pl > $@
SCTXSum.quarter.plot: SCTXSum.month.plot
	cat $< | perl month2quarter.pl > $@
%.byQuarter.csv:
	echo rank,quarter,totalSCTX,$(XSReleases) | sed 's/ /,/g' > $@
	paste -d, SCTXSum.quarter.plot $(quarterplotfiles) | cut -d, -f1-3,6,9,12,15,18,21,24,27,30 >> $@
%.byMonth.csv:
	echo rank,month,totalSCTX,$(XSReleases) | sed 's/ /,/g' > $@
	paste -d, SCTXSum.month.plot $(monthplotfiles) | cut -d, -f1-3,6,9,12,15,18,21,24,27,30 >> $@

%.byQuarter.png: %.byQuarter.csv
	gnuplot -e "title='XenServer LCM Quarterly';outfile='$@';infile='$<';xmin='2';xmax='25';ylabel='# issues';xlabel='Quarter'"  csv2stackedLines.gnuplot
%.byMonth.png: %.byMonth.csv
	gnuplot -e "title='XenServer LCM Monthly';outfile='$@';infile='$<';xmin='5';xmax='75';ylabel='# issues';xlabel='Month'"  csv2stackedLines.gnuplot
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f *.plot $(gnuplottargets)  SCTX.byQuarter.csv SCTX.byMonth.csv
reallyclean: clean
	rm -f $(jiratargets)
################testing######################################################
test: test.csv















	

   





