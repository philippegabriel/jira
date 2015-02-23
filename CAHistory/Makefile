#!/usr/bin/make -f
# philippeg apr2014
# Fetch issues from jira using the SQL interface
# Graph the reports, using gnuplot
# see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
#
.PHONY: mkdir login clean reallyclean check test jiraquery
include ../jira.mk
###################customise this section###################################
#release info
release=creedence
#release=tampa
#xmin and xmax define the interval plotted from the csv file
creedence.xminrange=241
creedence.xmaxrange=259
clearwater.xminrange=205
clearwater.xmaxrange=242
tampa.xminrange=170
tampa.xmaxrange=242
#teams info
teams=doc partner perf qa r0 r3 sto win xc
####################autogen variables#######################################
jiratargets=CA.outflow.byNames.allReleases.csv CA.inflow.byNames.allReleases.csv
#All teams target files
allPribyTeamstargets=csv/CA.inflow.allPri.byTeams.$(release).csv csv/CA.outflow.allPri.byTeams.$(release).csv 
B+CbyTeamstargets=csv/CA.inflow.B+C.byTeams.$(release).csv csv/CA.outflow.B+C.byTeams.$(release).csv 
targets=$(allPribyTeamstargets) $(B+CbyTeamstargets)
pngtargets=$(subst csv,png,$(targets))
#Individual teams target files
allPriteamtargets=$(foreach team,$(teams),csv/CA.InOutflow.allPri.$(team).$(release).csv)
B+Cteamtargets=$(foreach team,$(teams),csv/CA.InOutflow.B+C.$(team).$(release).csv)
teamtargets=$(allPriteamtargets) $(B+Cteamtargets)
pngteamtargets=$(subst csv,png,$(teamtargets))
#thumbnails
thumbnails=$(subst .png,.thumb.png,$(subst png/,thumb/,$(pngtargets) $(pngteamtargets)))
###################rules#####################################################
all: mkdir $(targets) $(pngtargets) $(teamtargets) $(pngteamtargets) $(thumbnails)
jiraquery: $(jiratargets)
mkdir:
	mkdir -p csv/ png/ thumb/
#Fetch data from jira
%.byNames.allReleases.csv: %.byNames.allReleases.sql
	$(setJiraPass) ; $(ConnectToJira) --field-separator="," --no-align --tuples-only -f  $< > $@

#Filter by release
csv/%.allPri.byNames.$(release).csv: %.byNames.allReleases.csv
	cat $< | grep -i $(release) | grep -i --invert-match "$(release) outgoing" > $@
	
#Filter Blocker and Critical
%.B+C.byNames.$(release).csv: %.allPri.byNames.$(release).csv
	cat $< | grep "Blocker\|Critical" > $@

#Map individual names to team names, using mapping defined in .teamMap	
%.byTeams.$(release).csv: %.byNames.$(release).csv
	cat $< | perl map2team.pl .teamMap > $@

#Produce individual team combined inflow and outflow all priorities
$(allPriteamtargets): $(allPribyTeamstargets)
	perl combineInOutflow.pl "$(teams)" "$(allPriteamtargets)" $^

#Produce individual team combined inflow and outflow B+C
$(B+Cteamtargets): $(B+CbyTeamstargets) 
	perl combineInOutflow.pl "$(teams)" "$(B+Cteamtargets)" $^

#Produce png files
png/%.byTeams.$(release).png: csv/%.byTeams.$(release).csv
	gnuplot -e "outfile='$@';infile='$<';title='$(@F)';ylabel='issues';xlabel='sprints';\
		xmin='$($(release).xminrange)';xmax='$($(release).xmaxrange)'" csv2stackedLines.gnuplot 

png/%.$(release).png: csv/%.$(release).csv
	gnuplot -e "outfile='$@';infile='$<';title='$(@F)';ylabel='issues';xlabel='sprints';\
		xmin='$($(release).xminrange)';xmax='$($(release).xmaxrange)'" csv2lines.gnuplot 
thumb/%.thumb.png: png/%.png
	convert $< -thumbnail x200 $@
#############################utility##########################################
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f  png/* csv/* thumb/*
reallyclean: clean
	rm -f *.csv








	











	

   





