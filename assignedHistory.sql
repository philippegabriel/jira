--
-- list jira 'PROJECT' issues assigned to 'NAME' between STARTDATE and ENDDATE
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 19feb2014
--
select changeitem.newvalue,changegroup.created,changeitem.field,project.pkey,jiraissue.issuenum,jiraissue.summary
from  jiraissue,project,changeitem,changegroup 
where date(changegroup.created) between :'STARTDATE' and :'ENDDATE'  
and changeitem.field = 'assignee' 
and newvalue in (:NAMES)
and changegroup.id=changeitem.groupid 
and changegroup.issueid=jiraissue.id 
and jiraissue.project=project.id and project.pkey in (:PROJECTS)
order by changegroup.created DESC;

