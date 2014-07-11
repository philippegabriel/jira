#!/usr/bin/make -f
# philippeg jun2014
# Generate csv files
# with persons who were assigned or commented on jira tickets, between a set of dates
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean reallyclean deploy test 

##########################customise this section###############################################
team=xs-ring0
IssueVersion=Creedence
FixVersion=Creedence Outgoing
startDate=2014-04-01 00:00:00
deployTarget=/local/scratch/creedence
########################end of custom section##################################################
#jira server params, read from .config file
host=$(lastword $(shell grep 'host' .config))
dbname=$(lastword $(shell grep 'dbname' .config))
username=$(lastword $(shell grep 'username' .config))
password=$(lastword $(shell grep 'password' .config))
#Define function to set multiple argument list in a compatible psql format, i.e. 'item1','item2',...
qw=$(shell echo $(1) | sed "s/\([^,]*\)/'\1'/g")
#Sets of csv targets
inflowCSV =$(team).C+.csv $(team).V+.csv $(team).T+.csv $(team).BC.P+.csv $(team).M.P+.csv $(team).O+.csv
outflowCSV=$(team).R-.csv $(team).V-.csv $(team).T-.csv $(team).BC.P-.csv $(team).M.P-.csv 
inflowByPriority= $(team).Blocker,Critical.inflow.csv   $(team).Major.inflow.csv
outflowByPriority=$(team).Blocker,Critical.outflow.csv  $(team).Major.outflow.csv
report=$(team).Blocker,Critical.report.csv $(team).Major.report.csv
#psql generic query
setJiraPass=export PGPASSWORD=$(password)
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
params=--field-separator="," --no-align --tuples-only 
params+= --variable=TEAM="$(call qw,$(team))" --variable=PROJECTS="'CA'"
params+= --variable=RELIN="$(IssueVersion)" --variable=RELEXCL="$(FixVersion)"
params+= --variable=STATUS="'Resolved','Closed'" --variable=STARTDATE="'$(startDate)'"
###############################################################################################
all: $(inflowCSV) $(outflowCSV) $(inflowByPriority) $(outflowByPriority) $(report)

#Targets for calculation using the 'lifecycle method'
#switched off for now as they don't provide increase in accuracy
#$(team).allEvents.csv: $(inflowCSV) $(outflowCSV)
#	sort -r $^ | ./filter.pl > $@

#$(team).Blocker,Critical.inflow.csv: $(team).allEvents.csv
#	grep -P '^.*?,.*?,.\+,.*?,(Critical|Blocker),' $< >$@
#$(team).Blocker,Critical.outflow.csv: $(team).allEvents.csv
#	grep -P '^.*?,.*?,.\-,.*?,(Critical|Blocker),' $< >$@
#$(team).Major.inflow.csv: $(team).allEvents.csv
#	grep -P '^.*?,.*?,.\+,.*?,Major,' $< >$@
#$(team).Major.outflow.csv: $(team).allEvents.csv
#	grep -P '^.*?,.*?,.\-,.*?,Major,' $< >$@

 
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

#	cat /tmp/P+.csv $(team).Major.inflow.csv > /tmp/inflowmap.$@ 

$(team).%.report.csv: $(team).%.inflow.csv $(team).%.outflow.csv
	@echo 'Generating report...'
	@echo 'Team: $(team)'							| tee -a  $@
	@echo 'Release: $(IssueVersion)'				| tee -a  $@
	@echo 'Priority: $(priority)'					| tee -a  $@
	@echo 											| tee -a  $@
	@echo 'C+ Created                    R- Issue Resolved'			| tee -a  $@
	@echo 'V+ Version set to project     V- Issue set to outgoing'	| tee -a  $@
	@echo 'P+ Priority promoted          P- Priority demoted'		| tee -a  $@
	@echo 'T+ Team affected              T- Team not affected'		| tee -a  $@
	@echo 'O+ Issue Reopened'						| tee -a  $@
	@echo 											| tee -a  $@
	@cat $^ | sort -r | tee -a  $@
	
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f *.report.csv report.csv *inflow.csv *outflow.csv
reallyclean:
	rm -f *.csv
lifecycle.dot.png: lifecycle.dot
	 dot -O -Tpng $<
$(team).BC.P+.csv: P+.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical'" --variable=LOG="P+" \
	-f $< | uniq | tee   $@
$(team).M.P+.csv: P+.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Major'" --variable=LOG="P+" \
	-f $< | uniq | tee   $@
$(team).BC.P-.csv: P-.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical'"	--variable=LOG="P-" \
	-f $< | uniq | tee   $@
$(team).M.P-.csv: P-.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Major'" --variable=LOG="P-" \
	-f $< | uniq | tee   $@
$(team).%.csv: %.sql
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical','Major'" --variable=LOG="$*" \
	-f $< | uniq | tee   $@
deploy:
	cp -f *report.csv $(deployTarget)/csv/
	cp -f index.html $(deployTarget)/
test:
	@echo $(params)


