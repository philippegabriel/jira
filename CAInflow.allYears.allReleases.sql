--
-- list jira 'PROJECT' between STARTDATE and ENDDATE where 'Affect Version' matches a given version
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 10apr2014
--
select to_char(jiraissue.created, 'YYYY'),to_char(jiraissue.created, 'WW'),concat(project.pkey,'-',jiraissue.issuenum),jiraissue.assignee,projectversion.vname
from  jiraissue,project,nodeassociation,projectversion
where jiraissue.project=project.id and project.pkey='CA'
and projectversion.id=nodeassociation.SINK_NODE_ID
and nodeassociation.ASSOCIATION_TYPE='IssueVersion'
and nodeassociation.SOURCE_NODE_ID=jiraissue.id
order by jiraissue.created;


