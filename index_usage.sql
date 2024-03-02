/*
* Select usage of indexes
* Ref: https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-index-usage-stats-transact-sql
*/
SELECT
	OBJECT_NAME(idx_stats.[OBJECT_ID]) AS Table_Name,
	DB_NAME(idx_stats.[database_id]) AS Database_Name,
	idx.[NAME] AS Index_Name,
	idx_stats.[USER_SEEKS],
	idx_stats.[USER_SCANS],
	idx_stats.[USER_LOOKUPS],
	idx_stats.[USER_UPDATES]
FROM sys.dm_db_index_usage_stats AS idx_stats
INNER JOIN sys.indexes AS idx
	ON idx.[OBJECT_ID] = idx_stats.[OBJECT_ID] 
	AND idx.[INDEX_ID] = idx_stats.[INDEX_ID]