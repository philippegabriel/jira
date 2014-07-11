select to_char(changegroup.created, 'YYYY-MM-DD'),concat(project.pkey,'-',jiraissue.issuenum),concat(pold.pname,'->',pnew.pname)
from  jiraissue,project,changeitem,changegroup,priority pold,priority pnew
where date(changegroup.created) between :'STARTDATE' and :'ENDDATE'  
and changeitem.field = 'priority' 
and changeitem.newvalue=pnew.id
and changeitem.oldvalue=pold.id
and changegroup.id=changeitem.groupid 
and changegroup.issueid=jiraissue.id 
and jiraissue.project=project.id and project.pkey in (:PROJECTS)
and jiraissue.assignee in (:NAMES)
order by changegroup.created DESC;

