#!/usr/bin/make -f
# philippeg jun2014
# Generate csv files
# with persons who were assigned or commented on jira tickets, between a set of dates
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean reallyclean deploy test 
include ../jira.mk
##########################customise this section###############################################
team=xs-ring0,xs-ring3,xs-storage,xs-gui,xs-perf,xs-window
IssueVersion=Creedence
FixVersion=Creedence Outgoing
startDate=2014-04-01 00:00:00
deployTarget=/local/scratch/creedence
########################end of custom section##################################################
#Sets of csv targets
inflowCSV =$(team).C+.csv $(team).V+.csv $(team).T+.csv $(team).BC.P+.csv $(team).M.P+.csv $(team).O+.csv
outflowCSV=$(team).R-.csv $(team).V-.csv $(team).T-.csv $(team).BC.P-.csv $(team).M.P-.csv 
inflowByPriority= $(team).Blocker,Critical.inflow.csv   $(team).Major.inflow.csv
outflowByPriority=$(team).Blocker,Critical.outflow.csv  $(team).Major.outflow.csv
report=$(team).Blocker,Critical.report.csv $(team).Major.report.csv
#psql params
params=--field-separator="," --no-align --tuples-only 
params+= --variable=TEAM="$(call qw,$(team))" --variable=PROJECTS="'CA'"
params+= --variable=RELIN="$(IssueVersion)" --variable=RELEXCL="$(FixVersion)"
params+= --variable=STATUS="'Resolved','Closed'" --variable=STARTDATE="'$(startDate)'"
#autogen vars
startWk:=$(shell date --date="$(startDate)" +"%V")
###############################################################################################
all: $(inflowCSV) $(outflowCSV) $(inflowByPriority) $(outflowByPriority) $(report) $(team).trend.csv

$(team).Blocker,Critical.inflow.csv: $(inflowCSV)
	grep -P --no-filename '^.*?,.*?,.\+,.*?,(Critical|Blocker),' $^ > /tmp/raw.$@
	sort -r /tmp/raw.$@ | ./rmdupIn.pl	>  $@
$(team).Blocker,Critical.outflow.csv: $(outflowCSV)
	grep -P --no-filename '^.*?,.*?,.\-,.*?,(Critical|Blocker),' $^ > /tmp/raw.$@
	sort -r /tmp/raw.$@ | ./rmdupOut.pl $(team).Blocker,Critical.inflow.csv >  $@
$(team).Major.inflow.csv: $(inflowCSV)
	grep -P --no-filename '^.*?,.*?,.\+,.*?,Major,' $^ > /tmp/raw.$@
	sort -r /tmp/raw.$@ | ./rmdupIn.pl	>  $@
$(team).Major.outflow.csv: $(outflowCSV)
	grep -P --no-filename '^.*?,.*?,.\-,.*?,Major,' $^ > /tmp/raw.$@
	grep ',P+,' $(team).Blocker,Critical.inflow.csv > /tmp/inflowmap.$@ 
	cat  $(team).Major.inflow.csv >> /tmp/inflowmap.$@ 
	sort -r /tmp/raw.$@ | ./rmdupOut.pl /tmp/inflowmap.$@ >  $@

$(team).%.report.csv: $(team).%.inflow.csv $(team).%.outflow.csv
	@echo "Generating report $@..."
	date "+Report generated: %m %b %Y %R %ywk%V"	>  $@
	@echo 'Team: $(team)'							>>  $@
	@echo 'Release: $(IssueVersion)'				>>  $@
	@echo 'Priority: $(priority)'					>>  $@
	@echo 											>>  $@
	@echo 'C+ Created                    R- Issue Resolved'			>>  $@
	@echo 'V+ Version set to project     V- Issue set to outgoing'	>>  $@
	@echo 'P+ Priority promoted          P- Priority demoted'		>>  $@
	@echo 'T+ Team affected              T- Team not affected'		>>  $@
	@echo 'O+ Issue Reopened'						>>  $@
	@echo 											>>  $@
	@cat $^ | sort -r >>  $@
$(team).trend.csv: $(report)
	./genstats.pl --startweek $(startWk) --team $(team) > $@
clean: 
	rm -f *.report.csv report.csv *inflow.csv *outflow.csv *.trend.csv trend.csv
reallyclean:
	rm -f *.csv
$(team).BC.P+.csv: P+.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical'" --variable=LOG="P+" \
	-f $< | uniq >   $@
$(team).M.P+.csv: P+.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Major'" --variable=LOG="P+" \
	-f $< | uniq >   $@
$(team).BC.P-.csv: P-.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical'"	--variable=LOG="P-" \
	-f $< | uniq >   $@
$(team).M.P-.csv: P-.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Major'" --variable=LOG="P-" \
	-f $< | uniq >   $@
$(team).%.csv: %.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical','Major'" --variable=LOG="$*" \
	-f $< | uniq >   $@
deploy:
	cp -f *report.csv trend.csv $(deployTarget)/csv/
	cp -f index.html $(deployTarget)/
login:
	$(setJiraPass) ; $(ConnectToJira)
test:
	@echo $(startWk)

