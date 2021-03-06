--
-- list jira issues resolved for a given IssueVersion,project, priority, team, start date
-- Using the jira SQL interface, ref:
-- https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- https://confluence.atlassian.com/display/JIRA041/Example+SQL+queries+for+JIRA
-- philippeg jul2014
--
select to_char(j.resolutiondate, 'YYYY-MM-DD","YY"wk"IW'),:'LOG',concat(project.pkey,'-',j.issuenum),priority.pname,j.assignee,resolution.pname
from  jiraissue j,project,priority,issuetype,label l,resolution
where j.project=project.id and project.pkey in (:PROJECTS)
and j.priority=priority.id and priority.pname in (:PRIORITY)
and j.issuetype=issuetype.id and issuetype.pname='Bug'
and l.issue=j.id and l.label in (:TEAM) 
and j.resolution=resolution.id
and j.resolutiondate  > :'STARTDATE'

and j.id in (select SOURCE_NODE_ID from nodeassociation nain,projectversion pvin 
	where nain.ASSOCIATION_TYPE='IssueVersion' 
	and pvin.id=nain.SINK_NODE_ID 
	and pvin.vname=:'RELIN')
and j.id not in (select SOURCE_NODE_ID  from nodeassociation naout,projectversion pvout
	where naout.ASSOCIATION_TYPE='IssueFixVersion' 
	and pvout.id=naout.SINK_NODE_ID and pvout.vname=:'RELEXCL')

order by j.resolutiondate DESC;

