#!/usr/bin/make -f
# philippeg apr2014
# Fetch issues from jira using the SQL interface
# Graph the reports, using gnuplot
# see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
#
.PHONY: login clean reallyclean check test jiraquery
###################customise this section###################################
release=clearwater
teams=doc partner perf qa r0 r3 sto win xc
fnametemplate=allYears.$(release)
jiratargets=CA.outflow.byNames.allYears.allReleases.csv CA.inflow.byNames.allYears.allReleases.csv
allPribyTeamstargets=CA.inflow.allPri.byTeams.$(fnametemplate).csv CA.outflow.allPri.byTeams.$(fnametemplate).csv 
B+CbyTeamstargets=CA.inflow.B+C.byTeams.$(fnametemplate).csv CA.outflow.B+C.byTeams.$(fnametemplate).csv 
targets=$(allPribyTeamstargets) $(B+CbyTeamstargets)
allPriteamtargets=$(foreach team,$(teams),CA.InOutflow.allPri.$(team).$(fnametemplate).csv)
B+Cteamtargets=$(foreach team,$(teams),CA.InOutflow.B+C.$(team).$(fnametemplate).csv)
teamtargets=$(allPriteamtargets) $(B+Cteamtargets)
pngtargets=$(subst .csv,.png,$(targets))
pngteamtargets=$(subst .csv,.png,$(teamtargets))
####################autogen variables#######################################
#jira server params, read from .config file
host=$(lastword $(shell grep 'host' .config))
dbname=$(lastword $(shell grep 'dbname' .config))
username=$(lastword $(shell grep 'username' .config))
password=$(lastword $(shell grep 'password' .config))
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
setJiraPass=export PGPASSWORD=$(password)
###################rules#####################################################
#all: $(targets) $(pngtargets) $(teamtargets) $(pngteamtargets)
all: $(targets) $(pngtargets) $(teamtargets) $(pngteamtargets)
jiraquery: $(jiratargets)
#Fetch data from jira
%.byNames.allYears.allReleases.csv: %.byNames.allYears.allReleases.sql
	$(setJiraPass) ; $(ConnectToJira) --field-separator="," --no-align --tuples-only -f  $< > $@

#Filter by year and release
%.allPri.byNames.allYears.$(release).csv: %.byNames.allYears.allReleases.csv
	cat $< | grep -i $(release) > $@
	
#Filter Blocker and Critical
%.B+C.byNames.allYears.$(release).csv: %.allPri.byNames.allYears.$(release).csv
	cat $< | grep "Blocker\|Critical" > $@

#Map individual names to team names, using mapping defined in .teamMap	
%.byTeams.allYears.$(release).csv: %.byNames.allYears.$(release).csv
	cat $< | perl map2team.pl .teamMap > $@

#Produce individual team combined inflow and outflow all priorities
$(allPriteamtargets): $(allPribyTeamstargets)
	perl combineInOutflow.pl "$(teams)" "$(allPriteamtargets)" $^

#Produce individual team combined inflow and outflow B+C
$(B+Cteamtargets): $(B+CbyTeamstargets) 
	perl combineInOutflow.pl "$(teams)" "$(B+Cteamtargets)" $^

#Produce png files
$(pngtargets):
	gnuplot -e "outfile='$@';infile='$(subst png,csv,$@)';xmin='205';xmax='240';ylabel='# issues';xlabel='Sprint'" csv2stackedLines.gnuplot 
$(pngteamtargets):
	gnuplot -e "outfile='$@';infile='$(subst png,csv,$@)';xmin='205';xmax='240';ylabel='# issues';xlabel='Sprint'" csv2lines.gnuplot 
#############################utility##########################################
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f $(targets) $(teamtargets) $(pngtargets) $(pngteamtargets)
reallyclean: clean
	rm -f *.csv *.png








	











	

   





