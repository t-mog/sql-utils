/*
* Select top worst performing queries by average CPU time
* Ref: https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql#a-finding-the-top-n-queries
*/
SELECT TOP 10 
	MIN(query_stats.[statement_text]) AS Statement_Text,
    SUM(query_stats.[execution_count]) AS Execution_Count,
    SUM(query_stats.[total_worker_time]) / SUM(query_stats.[execution_count]) AS Avg_CPU_Time
FROM   
    (SELECT 
		q_stats.*,   
		SUBSTRING(
			sql_text.[text], 
			(q_stats.[statement_start_offset]/2) + 1,  
			((CASE q_stats.[statement_end_offset]
				WHEN -1 THEN DATALENGTH(sql_text.[text])  
				ELSE q_stats.[statement_end_offset] END
					- q_stats.[statement_start_offset])/2) + 1) AS statement_text  
     FROM sys.dm_exec_query_stats AS q_stats  
     CROSS APPLY sys.dm_exec_sql_text(q_stats.[sql_handle]) 
	 AS sql_text)
AS query_stats  
GROUP BY query_stats.[query_hash]
ORDER BY Avg_CPU_Time DESC;  