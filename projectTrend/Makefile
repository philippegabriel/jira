#!/usr/bin/make -f
# philippeg jun2014
# Generate csv files
# with persons who were assigned or commented on jira tickets, between a set of dates
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean reallyclean deploy test 
include ../jira.mk
##########################customise this section###############################################
team=xs-ring3
IssueVersion=Dundee
ExcludeVersion=Dundee Outgoing
startDate=2014-04-01
########################end of custom section##################################################
#Sets of csv targets
inflowCSV =$(team).C+.csv $(team).V+.csv $(team).T+.csv $(team).BC.P+.csv $(team).M.P+.csv $(team).O+.csv
outflowCSV=$(team).R-.csv $(team).V-.csv $(team).T-.csv $(team).BC.P-.csv $(team).M.P-.csv 
inflowByPriority= $(team).BC.inflow.csv   $(team).M.inflow.csv
outflowByPriority=$(team).BC.outflow.csv  $(team).M.outflow.csv
report=$(team).BC.report.csv $(team).M.report.csv
#psql params
params=--field-separator="," --no-align --tuples-only 
params+= --variable=TEAM="$(call qw,$(team))" --variable=PROJECTS="'CA'"
params+= --variable=RELIN="$(IssueVersion)" --variable=RELEXCL="$(ExcludeVersion)"
params+= --variable=STATUS="'Resolved','Closed'" --variable=STARTDATE="'$(startDate)'"
#autogen vars
startWk:=$(shell date --date="$(startDate)" +"%ywk%V")
htmlreport=$(subst csv,html,$(report))
#targets
Jiratargets=$(inflowCSV) $(outflowCSV)
targets+=$(inflowByPriority) $(outflowByPriority)
targets+=$(report) $(htmlreport) $(team).trend.csv $(team).trend.html
###############################################################################################
all: $(Jiratargets) $(targets)

$(team).BC.inflow.csv: $(inflowCSV)
	grep -P --no-filename '^.*?,.*?,.\+,.*?,(Critical|Blocker),' $^ > /tmp/raw.$@ || true
	sort -r /tmp/raw.$@ | ./rmdupIn.pl	>  $@
$(team).BC.outflow.csv: $(outflowCSV)
	grep -P --no-filename '^.*?,.*?,.\-,.*?,(Critical|Blocker),' $^ > /tmp/raw.$@ || true
	sort -r /tmp/raw.$@ | ./rmdupOut.pl $(team).BC.inflow.csv >  $@
$(team).M.inflow.csv: $(inflowCSV)
	grep -P --no-filename '^.*?,.*?,.\+,.*?,Major,' $^ > /tmp/raw.$@ || true
	sort -r /tmp/raw.$@ | ./rmdupIn.pl	>  $@
$(team).M.outflow.csv: $(outflowCSV)
	grep -P --no-filename '^.*?,.*?,.\-,.*?,Major,' $^ > /tmp/raw.$@ || true
	grep ',P+,' $(team).BC.inflow.csv > /tmp/inflowmap.$@ || true
	cat  $(team).M.inflow.csv >> /tmp/inflowmap.$@ 
	sort -r /tmp/raw.$@ | ./rmdupOut.pl /tmp/inflowmap.$@ >  $@

$(team).%.report.csv: $(team).%.inflow.csv $(team).%.outflow.csv
	@echo "Generating report $@..."
	date "+Report generated %d %b %Y %R %ywk%V"	>  $@
	@echo 'team,$(team)'							>>  $@
	@echo 'release,$(IssueVersion)'				>>  $@
	@echo 'priority,$(priority)'					>>  $@
	@echo 											>>  $@
	@echo 'C+ Created,R- Issue Resolved'			>>  $@
	@echo 'V+ Version set to project,V- Issue set to outgoing'	>>  $@
	@echo 'P+ Priority promoted,P- Priority demoted'		>>  $@
	@echo 'T+ Team affected,T- Team not affected'		>>  $@
	@echo 'O+ Issue Reopened',						>>  $@
	@echo '__________________,______________________'>>  $@
	@cat $^ | sort -r >>  $@
$(team).trend.csv: $(report)
	./genstats.pl --startweek $(startWk) --team $(team) > $@
clean: 
	rm -f *report.csv *inflow.csv *outflow.csv *trend.csv
	rm -f *report.html *inflow.html *outflow.html *trend.html
reallyclean: clean
	rm -f *.csv
$(team).BC.P+.csv: P+.sql
	touch $@
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical'" --variable=LOG="P+" \
	-f $< | uniq >   $@
$(team).M.P+.csv: P+.sql
	touch $@
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Major'" --variable=LOG="P+" \
	-f $< | uniq >   $@
$(team).BC.P-.csv: P-.sql
	touch $@
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical'"	--variable=LOG="P-" \
	-f $< | uniq >   $@
$(team).M.P-.csv: P-.sql
	touch $@
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Major'" --variable=LOG="P-" \
	-f $< | uniq >   $@
$(team).%.csv: %.sql
	touch $@
	$(setJiraPass) ; $(ConnectToJira) $(params) \
	--variable=PRIORITY="'Blocker','Critical','Major'" --variable=LOG="$*" \
	-f $< | uniq >   $@
%.report.html: %.report.csv
	./csvreport2html.pl < $< > $@
%.trend.html: %.trend.csv
	./csvtrend2html.pl < $< > $@
trend.html: trend.csv
	./csvtrend2html.pl < $< > $@

login:
	$(setJiraPass) ; $(ConnectToJira)
test:
	@echo $(startWk)

