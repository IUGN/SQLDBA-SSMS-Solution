/* Script to create Replication */

-- Dropping the transactional subscriptions on Publisher
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_dropsubscription
		@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls', 
		@subscriber = N'Experiment,1432', 
		@destination_db = N'DBATools', 
		@article = N'all'
GO

/*
use [DBA]
exec sp_droparticle @article = N'<PublishedTableNameHere>', @publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls', @force_invalidate_snapshot = 1
GO
*/

-- Execute <sp_droparticle> for each table

-- Dropping the transactional publication on Publisher
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_droppublication @publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls'
GO


-- Enabling the replication database. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use master
exec sp_replicationdboption @dbname = N'DBA', @optname = N'publish', @value = N'true'
GO

-- Create Logreader agent. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
	-- Ideally there would be only a single LogReaderAgent job per PublisherDb
use [DBA];
exec sys.sp_addlogreader_agent @publisher_login = N'sa', @publisher_password = N'Pa$$w0rd',
					--@job_name = N'', 
					@publisher_security_mode = 0;
GO

-- Adding the transactional publication. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_addpublication @publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls', 
					--@logreader_job_name = N'', 
					@sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', 
					@allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', 
					@compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', 
					@add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', 
					@independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', 
					@autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', 
					@replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', 
					@enabled_for_het_sub = N'false'
GO

-- Add Snapshot agent job. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
	-- Ideally there would be one Snapshot agent per publication
use [DBA]
exec sp_addpublication_snapshot
					@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls', 
					--@snapshot_job_name = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls',
					@publisher_password = N'Pa$$w0rd',
					@publisher_login = N'sa',
					@frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, 
					@frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, 
					@active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = null, 
					@job_password = null, @publisher_security_mode = 0
go

-- Add publication access. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_grant_publication_access @publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls', @login = N'sa';
exec sp_grant_publication_access @publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls', @login = N'grafana';


/*
exec sp_grant_publication_access @publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls', @login = N'<LoginForReplAccessHere>';
*/
GO



-- Adding the transactional articles. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_addarticle	
				@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls',
				@article = N'file_io_stats',
				@source_owner = N'dbo',
				@source_object = N'file_io_stats',
				@destination_owner = N'dbo',
				@destination_table = N'file_io_stats',
				@ins_cmd = N'CALL [sp_MSins_dbofile_io_stats]',
				@del_cmd = N'CALL [sp_MSdel_dbofile_io_stats]',
				@upd_cmd = N'CALL [sp_MSupd_dbofile_io_stats]',
				@type = N'logbased',
				@pre_creation_cmd = N'truncate',
				@schema_option = 0x000000000803508F,
				@identityrangemanagementoption = N'manual',
				@status = 24,
				@vertical_partition = N'false';
GO


-- Adding the transactional articles. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_addarticle	
				@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls',
				@article = N'wait_stats',
				@source_owner = N'dbo',
				@source_object = N'wait_stats',
				@destination_owner = N'dbo',
				@destination_table = N'wait_stats',
				@ins_cmd = N'CALL [sp_MSins_dbowait_stats]',
				@del_cmd = N'CALL [sp_MSdel_dbowait_stats]',
				@upd_cmd = N'CALL [sp_MSupd_dbowait_stats]',
				@type = N'logbased',
				@pre_creation_cmd = N'truncate',
				@schema_option = 0x000000000803508F,
				@identityrangemanagementoption = N'manual',
				@status = 24,
				@vertical_partition = N'false';
GO


-- Adding the transactional articles. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_addarticle	
				@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls',
				@article = N'xevent_metrics',
				@source_owner = N'dbo',
				@source_object = N'xevent_metrics',
				@destination_owner = N'dbo',
				@destination_table = N'xevent_metrics',
				@ins_cmd = N'CALL [sp_MSins_dboxevent_metrics]',
				@del_cmd = N'CALL [sp_MSdel_dboxevent_metrics]',
				@upd_cmd = N'CALL [sp_MSupd_dboxevent_metrics]',
				@type = N'logbased',
				@pre_creation_cmd = N'truncate',
				@schema_option = 0x000000000803508F,
				@identityrangemanagementoption = N'manual',
				@status = 24,
				@vertical_partition = N'false';
GO


-- Adding the transactional articles. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_addarticle	
				@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls',
				@article = N'xevent_metrics_queries',
				@source_owner = N'dbo',
				@source_object = N'xevent_metrics_queries',
				@destination_owner = N'dbo',
				@destination_table = N'xevent_metrics_queries',
				@ins_cmd = N'CALL [sp_MSins_dboxevent_metrics_queries]',
				@del_cmd = N'CALL [sp_MSdel_dboxevent_metrics_queries]',
				@upd_cmd = N'CALL [sp_MSupd_dboxevent_metrics_queries]',
				@type = N'logbased',
				@pre_creation_cmd = N'truncate',
				@schema_option = 0x000000000803508F,
				@identityrangemanagementoption = N'manual',
				@status = 24,
				@vertical_partition = N'false';
GO


-- Adding the transactional articles. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_addarticle	
				@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls',
				@article = N'sql_agent_job_stats',
				@source_owner = N'dbo',
				@source_object = N'sql_agent_job_stats',
				@destination_owner = N'dbo',
				@destination_table = N'sql_agent_job_stats',
				@ins_cmd = N'CALL [sp_MSins_dbosql_agent_job_stats]',
				@del_cmd = N'CALL [sp_MSdel_dbosql_agent_job_stats]',
				@upd_cmd = N'CALL [sp_MSupd_dbosql_agent_job_stats]',
				@type = N'logbased',
				@pre_creation_cmd = N'truncate',
				@schema_option = 0x000000000803508F,
				@identityrangemanagementoption = N'manual',
				@status = 24,
				@vertical_partition = N'false';
GO


-- Start snapshot agent. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_startpublication_snapshot
			@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls'
go


-- Get Snapshot Agent history
  -- Execute on DistributorServer [SQLMonitor]
use [distribution];
select	agent_id, runstatus, start_time, time, duration, comments, delivered_transactions,
		delivered_commands, delivery_rate, error_id, timestamp 
from dbo.MSsnapshot_history h
join dbo.MSsnapshot_agents a
	on a.id = h.agent_id
where 1=1
and publication = 'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls'
and (	comments = 'Starting agent.'
	or	comments like '![100!%!] A snapshot of 5 article(s) was generated.' escape '!'
	)
order by start_time
go


-- Adding the transactional subscriptions. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_addsubscription
		@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls',
		@subscriber = N'Experiment,1432',
		@destination_db = N'DBATools',
		@subscription_type = N'Push', 
		@sync_type = N'automatic', 
		@article = N'all', 
		@update_mode = N'read only', 
		@subscriber_type = 0;
go

-- Add distribution agent. Execute on Publisher Db
  -- Execute on PublisherServer [Demo\SQL2019]
use [DBA]
exec sp_addpushsubscription_agent
		@publication = N'NTT_Demo__DBA_2_DBATools_SQLMonitor_Tbls', 
		@subscriber = N'Experiment,1432', 
		@subscriber_db = N'DBATools',
		@subscriber_password = N'Pa$$w0rd',
		@subscriber_login = N'sa', 
		@subscriber_security_mode = 0, 
		@frequency_type = 64, 
		@frequency_interval = 1, 
		@frequency_relative_interval = 1, 
		@frequency_recurrence_factor = 0, 
		@frequency_subday = 4, 
		@frequency_subday_interval = 5, 
		@active_start_time_of_day = 0, 
		@active_end_time_of_day = 235959, 
		@active_start_date = 0, 
		@active_end_date = 0, 
		@dts_package_location = N'Distributor'
GO


