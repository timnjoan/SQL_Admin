SELECT 
dbs.[name] AS [Database Name], 
CONVERT(DECIMAL(18,2), dopc1.cntr_value/1024.0) AS [Log Size (MB)], 
CONVERT(DECIMAL(18,2), dopc.cntr_value/1024.0) AS [Log Used (MB)],
CONVERT(DECIMAL(18,2), dopc1.cntr_value/1024.0) - CONVERT(DECIMAL(18,2), dopc.cntr_value/1024.0)[Log Free Space Left (MB)],
CAST(CAST(dopc.cntr_value AS FLOAT) / CAST(dopc1.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log space Used (%)], 
dbs.recovery_model_desc AS [Recovery Model], 
dbs.state_desc [Database State], 
dbs.log_reuse_wait_desc AS [Log Reuse Wait Description]
FROM sys.databases AS dbs WITH (NOLOCK)
INNER JOIN sys.dm_os_performance_counters AS dopc  WITH (NOLOCK) ON dbs.name = dopc.instance_name
INNER JOIN sys.dm_os_performance_counters AS dopc1 WITH (NOLOCK) ON dbs.name = dopc1.instance_name
WHERE dopc.counter_name LIKE N'Log File(s) Used Size (KB)%' 
AND dopc1.counter_name LIKE N'Log File(s) Size (KB)%'
AND dopc1.cntr_value > 0 
order by 5 DESC OPTION (RECOMPILE)