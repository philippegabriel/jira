--
-- list jira 'PROJECT' issues assigned to 'NAME' between STARTDATE and ENDDATE
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 10apr2014
--
select to_char(changegroup.created, 'YYYY'),to_char(changegroup.created, 'WW'),concat(project.pkey,'-',jiraissue.issuenum),priority.pname,changegroup.author,projectversion.vname
from  jiraissue,project,changeitem,changegroup,nodeassociation,projectversion,priority
where jiraissue.project=project.id and project.pkey='CA'
and changegroup.issueid=jiraissue.id 
and changegroup.id=changeitem.groupid 
and changeitem.field = 'status' 
and changeitem.newstring in ('Resolved')
and projectversion.id=nodeassociation.SINK_NODE_ID
and nodeassociation.ASSOCIATION_TYPE='IssueVersion'
and nodeassociation.SOURCE_NODE_ID=jiraissue.id
and priority.id=jiraissue.priority
order by changegroup.created;



