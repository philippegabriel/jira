--
-- list jira 'PROJECT' issues where 'NAME' created a comment between dates STARTDATE and ENDDATE
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 19feb2014
--
select jiraaction.author,jiraaction.created,jiraaction.actiontype,project.pkey,jiraissue.issuenum,jiraissue.summary
from  jiraissue,project, jiraaction 
where date(jiraaction.created) between :'STARTDATE' and :'ENDDATE'  
and jiraaction.author in (:NAMES)
and jiraaction.actiontype = 'comment'
and jiraaction.issueid=jiraissue.id 
and jiraissue.project=project.id and project.pkey in (:PROJECTS)
order by jiraaction.created DESC;

