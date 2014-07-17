#!/usr/bin/make -f
# philippeg feb2014
# Generate csv files
# with persons who were assigned or commented on jira tickets, between a set of dates
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean reallyclean deploy test
inclfile:=jira.mk
#include file is parent dir (testing), or same dir (deployed)
inclpath=$(if $(shell test -e ./$(inclfile) && echo ok),./,../)
include $(inclpath)$(inclfile)
##########################customise this section###############################################
#start date: yyyy-mm-dd 
startdate:=2014-06-09
#end date: yyyy-mm-dd 
enddate:=2014-06-12
#jira projects, e.g. CA, CP, SCTX... 
projects:=CA
#Set of people for report
r3=akshayr,jonathanlu,johnel,ravip,robho,simonbe,thomassa,euanh,philippeg,\#ring-3\ defect\ coordinator
#storage team
#sto=andreil,chandrikas,germanop,keithpe,thanosm,vineetht,zhengl 
#windows team
#win=bench,owensm,pauldu 
names=$(r3)
#target dir to host the web service
deployTarget:=/local/scratch/jirasql
########################end of custom section##################################################
########################autogen vars###########################################################
#create a no space filename
suffix=$(subst \ ,_,$(names).$(projects).from.$(startdate).to.$(enddate))
namesPsqlFormat=$(call qw,$(names))
projectsPsqlFormat=$(call qw,$(projects))
targets=commentsHistory.$(suffix).csv assignedHistory.$(suffix).csv 
report=jira.report.$(suffix).csv
ticketlist=jira.ticketlist.$(suffix).csv
###############################################################################################
all: clean $(targets) $(report) $(ticketlist)
%.$(suffix).csv: %.sql
	$(setJiraPass) ; $(ConnectToJira) \
	--field-separator="," --no-align --tuples-only \
	--variable=STARTDATE=$(startdate) --variable=ENDDATE=$(enddate) \
	--variable=NAMES="$(namesPsqlFormat)" --variable=PROJECTS="$(projectsPsqlFormat)" \
	-f $< > $@
   
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
deploy:
	cp -f * $(deployTarget)
	cp -f $(inclpath)$(inclfile) $(deployTarget)








