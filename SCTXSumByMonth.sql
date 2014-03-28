--
-- list jira 'PROJECT' between STARTDATE and ENDDATE where 'Affect Version' matches a given version
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 24Mar2014
--
select to_char(jiraissue.created, 'YYYYmm'),count(jiraissue.issuenum)
from  jiraissue,project,nodeassociation,projectversion
where jiraissue.project=project.id and project.pkey='SCTX'
and projectversion.id=nodeassociation.SINK_NODE_ID
and nodeassociation.ASSOCIATION_TYPE='IssueVersion'
and nodeassociation.SOURCE_NODE_ID=jiraissue.id
group by to_char(jiraissue.created, 'YYYYmm')
order by to_char(jiraissue.created, 'YYYYmm');


