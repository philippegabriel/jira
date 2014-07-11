select to_char(j.created, 'YYYY-MM-DD","YY"wk"IW'),:'LOG',concat(project.pkey,'-',j.issuenum),priority.pname,j.assignee
from  jiraissue j,project,issuetype,priority
where j.project=project.id and project.pkey in (:PROJECTS)
and j.priority=priority.id and priority.pname in (:PRIORITY)
and j.issuetype=issuetype.id and issuetype.pname='Bug'
and j.created > :'STARTDATE'
and j.id in (select label.issue from label where label.label in (:TEAM))
and j.id in (select nain.SOURCE_NODE_ID from nodeassociation nain,projectversion pvin 
	where nain.ASSOCIATION_TYPE='IssueVersion'
	and pvin.id=nain.SINK_NODE_ID and pvin.vname=:'RELIN')
/*Exclude issues whose version was changed after creation*/
and j.id not in (select changegroup.issueid from changeitem,changegroup
	where changegroup.id=changeitem.groupid
	and changeitem.field = 'Version' and changeitem.newstring=:'RELIN')
order by j.created DESC;


