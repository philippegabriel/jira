inFlowOutFlowGraph
==================
Graph JIRA inflow and outflow of defects

- Retrieves JIRA defects, unsing the SQL interface https://developer.atlassian.com/display/JIRADEV/Database+Schema
- Maps assignee names to team names, following a given map
- Reduces defect inflow and outflow by names to a table of inflow/outflow by teams and sprints
- Graph the result per team
- Graph the result for all teams

Sample Graphs:
