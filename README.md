# jira
Projects related to data mining JIRA

Retrieves JIRA issues, using the [JIRA SQL interface](https://developer.atlassian.com/display/JIRADEV/Database+Schema)
Post process the results, to produce html report and/or graphs.

 - [`CAHistory`](CAHistory) - Graph defects inflow/outflow by team/week
 - [`SCTXHistory`](SCTXHistory) - Graph LCM defects by release/month or quarter
 - [`projectTrend`](projectTrend) - Web app, fine grained inflow/outflow per team/week
 - [`teamHistory`](teamHistory) - Web app, tickets assigned to or commented by contributors, for a date range


prerequisites:
==============
- Tested on Ubuntu 14.04
- psql (PostgreSQL) 	- tested with: 9.3.4
- gnuplot 			- tested with 4.6 patchlevel 4
- perl 5 				- tested with version 18, subversion 2 (v5.18.2)

