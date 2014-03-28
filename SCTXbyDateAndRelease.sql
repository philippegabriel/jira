--
-- list jira 'PROJECT' between STARTDATE and ENDDATE where 'Affect Version' matches a given version
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 24Mar2014
--
select to_char(jiraissue.created, 'YYYYmm'),project.pkey,jiraissue.issuenum,projectversion.vname
from  jiraissue,project,nodeassociation,projectversion
where jiraissue.project=project.id and project.pkey='SCTX'
and projectversion.id=nodeassociation.SINK_NODE_ID
and nodeassociation.ASSOCIATION_TYPE='IssueVersion'
and nodeassociation.SOURCE_NODE_ID=jiraissue.id
order by jiraissue.created;


