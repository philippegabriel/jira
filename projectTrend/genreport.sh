#!/bin/bash -e
#
# Exec SQL queries for each teams
#
teams="xs-ring0 xs-ring3 xs-storage xs-gui xs-perf xs-windows"
for team in $teams
do
	make team=$team
done
#
# Exec global SQL query
#
allteam='xs-ring0,xs-ring3,xs-storage,xs-gui,xs-perf,xs-windows'
make team=$allteam
#
#Generate stats
#
date "+Report generated: %m %b %Y %R %ywk%V"	>  trend.csv
for team in $teams
do
	cat $team.trend.csv >> trend.csv
done
cat $allteam.trend.csv >> trend.csv
exit 0


