#!/usr/bin/make -f
# philippeg apr2014
# Fetch issues from jira sing the SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean reallyclean check test
.SECONDARY:
###################customise this section###################################
release=clearwater
year=2013
teams=doc partner perf qa r0 r3 sto win xc
fnametemplate=$(year).$(release)
targets=CA.inflow.allPri.byTeams.$(fnametemplate).png 
targets+=CA.inflow.B+C.byTeams.$(fnametemplate).png 
targets+=CA.outflow.allPri.byTeams.$(fnametemplate).png 
targets+=CA.outflow.B+C.byTeams.$(fnametemplate).png 
teamtargets=$(foreach team,$(teams),$(team).CA.inAndOutflow.$(fnametemplate).csv)

####################autogen variables#######################################
#jira server params, read from .config file
host=$(lastword $(shell grep 'host' .config))
dbname=$(lastword $(shell grep 'dbname' .config))
username=$(lastword $(shell grep 'username' .config))
password=$(lastword $(shell grep 'password' .config))
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
setJiraPass=export PGPASSWORD=$(password)
###################rules#####################################################
all: $(targets)
%.byNames.allYears.allReleases.csv: %.byNames.allYears.allReleases.sql
	$(setJiraPass) ; $(ConnectToJira) --field-separator="," --no-align --tuples-only -f  $< > $@
%.allPri.byNames.$(year).$(release).csv: %.byNames.allYears.allReleases.csv
	cat $< | grep -i $(release) | grep $(year) > $@	
%.B+C.byNames.$(year).$(release).csv: %.allPri.byNames.$(year).$(release).csv
	cat $< | grep "Blocker\|Critical" > $@	
%.byTeams.$(year).$(release).csv: %.byNames.$(year).$(release).csv
	cat $< | perl map2team.pl teamMap.csv > $@
#################################################################################
%.png: %.csv
	gnuplot -e "outfile='$@';infile='$<'" csvStackedLines.gnuplot
teamtargets: %.byTeams.$(year).$(release).csv 
	perl mergeInflowanOutflow.pl \
		"$(teams)" \
		"team.CAInAndOutflow.$(release).$(year)." \
		CAInflow.$(release).$(year).bySprint.byTeams.csv \
		CAOutflow.$(release).$(year).bySprint.byTeams.csv
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f *.png 
reallyclean: clean
	rm -f $(targets)
################testing######################################################
test: 
	perl mergeInflowanOutflow.pl $(teams) "CAInAndOutflow.$(release).$(year).bySprint." CAInflow.$(release).$(year).bySprint.byTeams.csv CAOutflow.$(release).$(year).bySprint.byTeams.csv
test2: CAInAndOutflow.$(release).$(year).bySprint.r0.csv
test3:
	echo $(targets)

#%.byTeams.$(year).$(release).png: %.byTeams.$(year).$(release).csv












	

   





