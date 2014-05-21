--
-- list jira 'PROJECT' issues assigned to 'NAME' between STARTDATE and ENDDATE
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 20may2014
--
select to_char(jiraissue.resolutiondate, 'YYYY'),to_char(jiraissue.resolutiondate, 'WW'),concat(project.pkey,'-',jiraissue.issuenum),priority.pname,jiraissue.assignee,projectversion.vname
from  jiraissue,project,nodeassociation,projectversion,priority
where jiraissue.project=project.id and project.pkey='CA'
and jiraissue.resolutiondate is not null
and projectversion.id=nodeassociation.SINK_NODE_ID
and nodeassociation.ASSOCIATION_TYPE='IssueFixVersion'
and nodeassociation.SOURCE_NODE_ID=jiraissue.id
and priority.id=jiraissue.priority
order by jiraissue.resolutiondate;



