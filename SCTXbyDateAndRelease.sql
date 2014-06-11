--
-- list jira 'PROJECT' between STARTDATE and ENDDATE where 'Affect Version' matches a given version
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
-- philippeg 24Mar2014
--
select to_char(j.created, 'YYYYmm'),concat(p.pkey,'-',j.issuenum),pv.vname
from  jiraissue j 
LEFT OUTER JOIN project p ON 
	p.pkey='SCTX' 
LEFT OUTER JOIN nodeassociation naver ON 
	naver.ASSOCIATION_TYPE='IssueVersion'
	and naver.SOURCE_NODE_ID=j.id
LEFT OUTER JOIN projectversion pv ON
	pv.id=naver.SINK_NODE_ID
where j.project=p.id
order by j.created;


