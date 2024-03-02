/*
* Select index fragmentation percentage
* Ref: https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-index-physical-stats-transact-sql
*/
SELECT
	dbschemas.[name] AS 'schema',
	dbtables.[name] AS 'table',
	dbindexes.[name] AS 'index',
	indexstats.[avg_fragmentation_in_percent],
	indexstats.[page_count]
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables 
	ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas 
	ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes 
	ON dbindexes.[object_id] = indexstats.[object_id]
	AND indexstats.[index_id] = dbindexes.[index_id]
WHERE indexstats.[database_id] = DB_ID()
ORDER BY indexstats.[avg_fragmentation_in_percent] DESC