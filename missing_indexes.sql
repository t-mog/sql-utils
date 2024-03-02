/*
* Select missing indexes
* Note that missing index information is not persisted and is available only until the database engine restart.
* Ref: https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-missing-index-details-transact-sql
*/
SELECT 
	idx_details.[statement] AS [table_name], 
	idx_details.[equality_columns], 
	idx_details.[inequality_columns], 
	idx_details.[included_columns], 
	idx_group_stats.[user_scans], 
	idx_group_stats.[user_seeks], 
	idx_group_stats.[avg_total_user_cost], 
	idx_group_stats.[avg_user_impact], 
	ROUND(idx_group_stats.avg_total_user_cost * (idx_group_stats.avg_user_impact/100.0), 3) AS [avg_cost_savings], 
	ROUND(idx_group_stats.avg_total_user_cost * (idx_group_stats.avg_user_impact/100.0) * (idx_group_stats.user_seeks + idx_group_stats.user_scans), 3) AS [total_cost_savings] 
FROM sys.dm_db_missing_index_groups idx_groups
INNER JOIN sys.dm_db_missing_index_group_stats idx_group_stats 
	ON idx_group_stats.group_handle = idx_groups.index_group_handle 
INNER JOIN sys.dm_db_missing_index_details idx_details 
	ON idx_details.index_handle = idx_groups.index_handle 
WHERE idx_details.database_id = DB_ID() 
ORDER BY [total_cost_savings] DESC;