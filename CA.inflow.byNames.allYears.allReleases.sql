--
-- list jira 'PROJECT' between STARTDATE and ENDDATE where 'Affect Version' matches a given version
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 10apr2014
--
select to_char(jiraissue.created, 'YYYY'),to_char(jiraissue.created, 'WW'),concat(project.pkey,'-',jiraissue.issuenum),priority.pname,jiraissue.assignee,projectversion.vname
from  jiraissue,project,nodeassociation,projectversion,priority
where jiraissue.project=project.id and project.pkey='CA'
and projectversion.id=nodeassociation.SINK_NODE_ID
and nodeassociation.ASSOCIATION_TYPE='IssueVersion'
and nodeassociation.SOURCE_NODE_ID=jiraissue.id
and priority.id=jiraissue.priority
order by jiraissue.created;


