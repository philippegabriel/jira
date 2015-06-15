#!/bin/bash -e
#
# Exec SQL queries for each teams
#
IssueVersion=Dundee
ExcludeVersion="$IssueVersion Outgoing"
startDate=2014-11-03
teams="xs-ring0 xs-ring3 xs-datapath xs-storage xs-gui xs-perf xs-windows xs-partner xs-nanjing xs-ns"
allteam=`echo $teams | sed 's/ /,/g'`
#
#reset everything
#
make reallyclean
#run per team query
for team in $teams
do
	make team=$team IssueVersion=$IssueVersion ExcludeVersion="$ExcludeVersion" startDate=$startDate 
done
#run all-team query
make team=$allteam IssueVersion=$IssueVersion ExcludeVersion="$ExcludeVersion" startDate=$startDate
#Generate stats
date "+Report generated %d %b %Y %R %ywk%V"	>  trend.csv
for team in $teams
do
	cat $team.trend.csv >> trend.csv
done
cat $allteam.trend.csv >> trend.csv
make trend.html
exit 0


