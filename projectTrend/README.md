ProjectTrend
============
Retrieves JIRA issues contributing to the inflow and outflow for a release, then generate report and inflow/outflow metrics.

prerequisites:
==============
- Tested on Ubuntu 14.04
- psql (PostgreSQL) 	- tested with: 9.3.4
- gnuplot 			- tested with 4.6 patchlevel 4
- perl 5 				- tested with version 18, subversion 2 (v5.18.2)

Description
============

Generate csv files, from a set of sql queries, using the [JIRA SQL interface](https://developer.atlassian.com/display/JIRADEV/Database+Schema).

Each sql query takes a few parameters (team, release, start date, priority...) and represents a set of issues contributing to inflow or outflow for a given release, defined as:

**Inflow Set**

* `C+.sql` 'Affect version' set to given release, on creation 
* `V+.sql` 'Affect Version' was changed to include given release
* `P+.sql` Priority has increased
* `T+.sql` Given team now in scope
* `O+.sql` Issues reopened

**Outflow Set**

* `R-.sql` Resolved Issues for given release
* `V-.sql` 'Fix Version' was changed to exclude given release
* `P-.sql` Priority has decreased
* `T-.sql` given team no longer scope

The Inflow set csv files are then sorted in inverse chronological order, duplicate issues (that appear in distinct csv files) are filtered by the `rmdupIn.pl` script 
and an outflow csv file is produced per team, per priority (i.e. one for Blocker & Critical, another one for Major), see `$(team).*.inflow.csv` rules in the `Makefile`

The same process is applied to the Outflow csv file set, which is additionally filtered for issues in the outflow set not present in the inflow set (`rmdupOut.pl` script), 
see `$(team).*.outflow.csv` rules in the `Makefile`

Team inflow and outflow csv files are then combined to produce a per team, per priority report csv file, which lists all the relevant events in inverse chronological order,
see `$(team).%.report.csv` rules in the `Makefile`

Finally, the team report is synthesized further with `genstats.pl`, which produces a table, (see `$(team).trend.csv` target in the `Makefile` such as:

 wk number | 14wk20 | 14wk21 |
 --------- | ------ | ------ |
 Unresolved (start of week) | 9 | 12 |
 C+ | 2 | |
 V+ | 2 | 2 |
 P+ | 1 | 2 |
 T+ | 1 | |
 O+ | | |	
 Inflow | 6 | 4 |
 R- | 3 | 4 |
 V- | | |	
 P- | | |	
 T- | | 1 |
 Outflow | 3 | 5 |
 Unresolved (end of week) | 12 | 11 |
 Cumulative defects raised | 22 | 26 |




