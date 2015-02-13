#!/bin/bash -e
#
# Exec SQL queries for each teams
#
IssueVersion=Dundee
ExcludeVersion=TTTTTTT
startDate=2014-11-03
teams="xs-ring0 xs-ring3 xs-datapath xs-storage xs-gui xs-perf xs-windows xs-partner xs-nanjing xs-ns"
for team in $teams
do
	make team=$team IssueVersion=$IssueVersion ExcludeVersion=$ExcludeVersion startDate=$startDate 
done
#
# Exec global SQL query
#
allteam='xs-ring0,xs-ring3,xs-datapath,xs-storage,xs-gui,xs-perf,xs-windows,xs-partner,xs-nanjing,xs-ns'
make team=$allteam IssueVersion=$IssueVersion ExcludeVersion=$ExcludeVersion startDate=$startDate
#
#Generate stats
#
date "+Report generated %d %b %Y %R %ywk%V"	>  trend.csv
for team in $teams
do
	cat $team.trend.csv >> trend.csv
done
cat $allteam.trend.csv >> trend.csv
exit 0


