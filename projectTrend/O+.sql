select to_char(changegroup.created, 'YYYY-MM-DD","YY"wk"IW'),:'LOG',concat(project.pkey,'-',j.issuenum),priority.pname,j.assignee,concat(oldstatus.pname,'->',newstatus.pname)
from  jiraissue j,project,changeitem,changegroup,priority,issuetype,label l,issuestatus newstatus, issuestatus oldstatus
where j.project=project.id and project.pkey in (:PROJECTS)
and j.priority=priority.id and priority.pname in (:PRIORITY)
and j.issuetype=issuetype.id and issuetype.pname='Bug'
and l.issue=j.id and l.label in (:TEAM)
and changeitem.field = 'status' 
and changeitem.newvalue=newstatus.id and newstatus.pname NOT in (:STATUS)
and changeitem.oldvalue=oldstatus.id and oldstatus.pname in (:STATUS)
and changegroup.id=changeitem.groupid and changegroup.issueid=j.id 
and changegroup.created  > :'STARTDATE'
and j.id in (select SOURCE_NODE_ID from nodeassociation nain,projectversion pvin 
	where nain.ASSOCIATION_TYPE='IssueVersion' 
	and pvin.id=nain.SINK_NODE_ID 
	and pvin.vname=:'RELIN')
and j.id not in (select SOURCE_NODE_ID  from nodeassociation naout,projectversion pvout
	where naout.ASSOCIATION_TYPE='IssueFixVersion' 
	and pvout.id=naout.SINK_NODE_ID and pvout.vname=:'RELEXCL')

order by changegroup.created DESC;

