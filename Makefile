#!/usr/bin/make -f
# philippeg apr2014
# Fetch issues from jira using the SQL interface
# see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
# Produce "byTeams" csv files, mapping id to team id
# Produce "allPri" and "B+C" for 
#
.PHONY: login clean reallyclean check test
###################customise this section###################################
release=clearwater
year=2013
teams=doc partner perf qa r0 r3 sto win xc
fnametemplate=$(year).$(release)
jiratargets=CA.outflow.byNames.allYears.allReleases.csv
jiratargets+=CA.inflow.byNames.allYears.allReleases.csv
allPribyTeamstargets=CA.inflow.allPri.byTeams.$(fnametemplate).csv 
allPribyTeamstargets+=CA.outflow.allPri.byTeams.$(fnametemplate).csv 
B+CbyTeamstargets=CA.inflow.B+C.byTeams.$(fnametemplate).csv 
B+CbyTeamstargets+=CA.outflow.B+C.byTeams.$(fnametemplate).csv 
targets=$(allPribyTeamstargets) $(B+CbyTeamstargets)
allPriteamtargets=$(foreach team,$(teams),CA.InOutflow.allPri.$(team).$(fnametemplate).csv)
B+Cteamtargets=$(foreach team,$(teams),CA.InOutflow.B+C.$(team).$(fnametemplate).csv)
teamtargets=$(allPriteamtargets) $(B+Cteamtargets)
pngtargets=$(subst .csv,.png,$(targets) $(teamtargets))
####################autogen variables#######################################
#jira server params, read from .config file
host=$(lastword $(shell grep 'host' .config))
dbname=$(lastword $(shell grep 'dbname' .config))
username=$(lastword $(shell grep 'username' .config))
password=$(lastword $(shell grep 'password' .config))
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
setJiraPass=export PGPASSWORD=$(password)
###################rules#####################################################
all: $(targets) $(teamtargets) $(pngtargets)
#Fetch data from jira
#%.byNames.allYears.allReleases.csv: %.byNames.allYears.allReleases.sql
#	$(setJiraPass) ; $(ConnectToJira) --field-separator="," --no-align --tuples-only -f  $< > $@

#Filter by year and release
%.allPri.byNames.$(year).$(release).csv: %.byNames.allYears.allReleases.csv
	cat $< | grep -i $(release) | grep $(year) > $@
	
#Filter Blocker and Critical
%.B+C.byNames.$(year).$(release).csv: %.allPri.byNames.$(year).$(release).csv
	cat $< | grep "Blocker\|Critical" > $@

#Map individual names to team names, using mapping defined in .teamMap	
%.byTeams.$(year).$(release).csv: %.byNames.$(year).$(release).csv
	cat $< | perl map2team.pl .teamMap > $@

#Produce individual team combined inflow and outflow all priorities
$(allPriteamtargets): $(allPribyTeamstargets)
	perl combineInOutflow.pl "$(teams)" "$(allPriteamtargets)" $^

#Produce individual team combined inflow and outflow B+C
$(B+Cteamtargets): $(B+CbyTeamstargets) 
	perl combineInOutflow.pl "$(teams)" "$(B+Cteamtargets)" $^

#Produce png files; emit warning if csv file has too few columns
%.png: %.csv
	gnuplot -e "outfile='$@';infile='$<'" csv2stackedLines.gnuplot > /dev/null
#############################utility##########################################
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f $(targets) $(teamtargets) $(pngtargets)  
reallyclean: clean
	rm -f $(targets)
############################testing###########################################
test: CA.InOutflow.B+C.r3.2013.clearwater.png



	











	

   





