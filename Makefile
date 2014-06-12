#!/usr/bin/make -f
# philippeg feb2014
# Generate csv files
# with persons who were assigned or commented on jira tickets, between a set of dates
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean reallyclean test dotar

##########################customise this section###############################################
#start date: yyyy-mm-dd 
startdate=2014-06-09
#end date: yyyy-mm-dd 
enddate=2014-06-12
#jira projects, e.g. CA, CP, SCTX... 
projects=CA
#Set of people for report
r3=akshayr,jonathanlu,johnel,ravip,robho,simonbe,thomassa,euanh,philippeg,\#ring-3\ defect\ coordinator
#storage team
#sto=andreil,chandrikas,germanop,keithpe,thanosm,vineetht,zhengl 
#windows team
#win=bench,owensm,pauldu 
names=$(r3)
########################end of custom section##################################################
#jira server params, read from .config file
host=$(lastword $(shell grep 'host' .config))
dbname=$(lastword $(shell grep 'dbname' .config))
username=$(lastword $(shell grep 'username' .config))
password=$(lastword $(shell grep 'password' .config))
#
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
setJiraPass=export PGPASSWORD=$(password)

#autogenerated name
suffix=$(names).$(projects).from.$(startdate).to.$(enddate)
namesPsqlFormat=$(shell echo $(names) | sed "s/\([^,]*\)/'\1'/g")
projectsPsqlFormat=$(shell echo $(projects) | sed "s/\([^,]*\)/'\1'/g")
targets=commentsHistory.$(suffix).csv assignedHistory.$(suffix).csv 
targets+=statusHistory.$(suffix).csv priorityHistory.$(suffix).csv 
report=jira.report.$(suffix).csv
ticketlist=jira.ticketlist.$(suffix).csv
###############################################################################################
all: clean $(report) $(ticketlist)
%.$(names).$(projects).from.$(startdate).to.$(enddate).csv: %.sql
	$(setJiraPass) ; $(ConnectToJira) \
	--field-separator="," --no-align --tuples-only \
	--variable=STARTDATE=$(startdate) --variable=ENDDATE=$(enddate) \
	--variable=NAMES="$(namesPsqlFormat)" --variable=PROJECTS="$(projectsPsqlFormat)" \
	-f $< >> $@
   
$(report): $(targets)
	cat  $^ | sort > $@

$(ticketlist): $(report)
	cat $< | cut -d, -f1,4,5 | sort | uniq > $@
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f $(targets) $(report) $(ticketlist)
reallyclean:
	rm -f *.csv
dotar:
	rm -f archive.*
	tar -cjf archive.tar ./*
test:
	$(setJiraPass) ; $(ConnectToJira) \
	--field-separator="," --no-align --tuples-only \
	--variable=STARTDATE=$(startdate) --variable=ENDDATE=$(enddate) \
	--variable=NAMES="$(namesPsqlFormat)" --variable=PROJECTS="$(projectsPsqlFormat)" \
	-f statusHistory.sql 
#> priorityHistory.csv










