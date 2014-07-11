select to_char(changegroup.created, 'YYYY-MM-DD'),concat(project.pkey,'-',jiraissue.issuenum),priority.pname,concat(oldstatus.pname,'->',newstatus.pname)
from  jiraissue,project,changeitem,changegroup,priority,issuestatus newstatus, issuestatus oldstatus
where date(changegroup.created) between :'STARTDATE' and :'ENDDATE'  
and changeitem.field = 'status' 
and changeitem.newvalue=newstatus.id
and changeitem.oldvalue=oldstatus.id
and changegroup.id=changeitem.groupid 
and changegroup.issueid=jiraissue.id 
and changegroup.author in (:NAMES)
and jiraissue.project=project.id and project.pkey in (:PROJECTS)
and jiraissue.priority=priority.id
order by changegroup.created ASC;

