USE [SQLWATCH]
GO
CREATE PROCEDURE [dbo].[CollectData01]
AS
BEGIN
	SET NOCOUNT ON;

declare @sql varchar(max)

--SQL01
declare @enabled tinyint = 1
set @enabled = case when object_id('master.dbo.sp_whoisactive') is not null or object_id('dbo.sp_whoisactive') is not null then 1 else 0 end

exec dbo.usp_sqlwatch_logger_whoisactive
exec dbo.usp_sqlwatch_logger_performance
exec dbo.usp_sqlwatch_logger_requests_and_sessions
exec dbo.usp_sqlwatch_logger_xes_blockers
exec dbo.usp_sqlwatch_logger_xes_waits
exec dbo.usp_sqlwatch_logger_xes_diagnostics
exec dbo.usp_sqlwatch_logger_xes_long_queries
exec dbo.usp_sqlwatch_logger_hadr_database_replica_states
exec dbo.usp_sqlwatch_trend_perf_os_performance_counters @interval_minutes = 1, @valid_days = 7
exec dbo.usp_sqlwatch_trend_perf_os_performance_counters @interval_minutes = 5, @valid_days = 90
exec dbo.usp_sqlwatch_trend_perf_os_performance_counters @interval_minutes = 60, @valid_days = 720

exec dbo.usp_sqlwatch_internal_process_checks
exec dbo.usp_sqlwatch_internal_process_reports @report_batch_id = 'AzureLogMonitor-1'

END
GO

CREATE PROCEDURE [dbo].[CollectData02]
AS
BEGIN
	SET NOCOUNT ON;
exec dbo.usp_sqlwatch_logger_agent_job_history
exec dbo.usp_sqlwatch_internal_retention
exec dbo.usp_sqlwatch_internal_purge_deleted_items
exec dbo.usp_sqlwatch_logger_disk_utilisation
exec dbo.usp_sqlwatch_logger_disk_utilisation_table
END
GO

CREATE PROCEDURE [dbo].[CollectData03]
AS
BEGIN
	SET NOCOUNT ON;
	exec dbo.usp_sqlwatch_internal_add_index
	exec dbo.usp_sqlwatch_internal_add_index_missing	
	exec dbo.usp_sqlwatch_logger_missing_index_stats
	exec dbo.usp_sqlwatch_logger_index_usage_stats
	exec dbo.usp_sqlwatch_logger_index_histogram
	exec dbo.usp_sqlwatch_internal_add_database
	exec dbo.usp_sqlwatch_internal_add_master_file
	exec dbo.usp_sqlwatch_internal_add_table
	exec dbo.usp_sqlwatch_internal_add_job
	exec dbo.usp_sqlwatch_internal_add_performance_counter
	exec dbo.usp_sqlwatch_internal_add_memory_clerk
	exec dbo.usp_sqlwatch_internal_add_wait_type
	exec dbo.usp_sqlwatch_internal_expand_checks
	exec dbo.usp_sqlwatch_internal_add_procedure
	exec dbo.usp_sqlwatch_internal_add_system_configuration
	exec dbo.usp_sqlwatch_logger_system_configuration
	exec dbo.usp_sqlwatch_logger_procedure_stats
END
GO
