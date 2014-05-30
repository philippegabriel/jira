-- list jira issues for the a given project
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- Using OUTER JOIN, see: https://confluence.atlassian.com/display/JIRA041/Example+SQL+queries+for+JIRA
-- philippeg 30may2014
--
select to_char(j.created, 'YYYY'),to_char(j.created, 'WW'),concat(p.pkey,'-',j.issuenum),pri.pname,j.assignee,pv.vname
from  jiraissue j 
LEFT OUTER JOIN project p ON 
	p.pkey='CA' 
LEFT OUTER JOIN nodeassociation naver ON 
	naver.ASSOCIATION_TYPE='IssueVersion'
	and naver.SOURCE_NODE_ID=j.id
LEFT OUTER JOIN projectversion pv ON
	pv.id=naver.SINK_NODE_ID
LEFT OUTER JOIN priority pri ON
	pri.id=j.priority

where j.project=p.id
order by j.created;

