
sqlcmd.exe -S localhost\SQLEXPRESS -Q "EXEC [SQLWATCH].[dbo].[CollectData01]"

$output = "x"
while ($output -ne $null) { 
	$output = Invoke-SqlCmd -ServerInstance "localhost\SQLEXPRESS" -Database "SQLWATCH" -MaxCharLength 2147483647 -Query "exec [dbo].[usp_sqlwatch_internal_action_queue_get_next]"

	$status = ""
	$queue_item_id = $output.queue_item_id
    $operation = ""
	$ErrorOutput = ""
	$MsgType = "OK"
	
	if ( $output -ne $null) {
		if ( $output.action_exec_type -eq "T-SQL" ) {
			try {
				$ErrorOutput = Invoke-SqlCmd -ServerInstance "localhost\SQLEXPRESS" -Database 'SQLWATCH'  -ErrorAction "Stop" -Query $output.action_exec -MaxCharLength 2147483647
			}
			catch {
				$ErrorOutput = $error[0] -replace "''", "''''"
				$MsgType = "ERROR"
			}
		}

		if ( $output.action_exec_type -eq "PowerShell" ) {
			try {
				$ErrorOutput = Invoke-Expression $output.action_exec -ErrorAction "Stop" 
			}
			catch {
				$ErrorOutput = $_.Exception.Message -replace "''", "''''"
				$MsgType = "ERROR"
			}
		}
		Invoke-SqlCmd -ServerInstance "localhost\SQLEXPRESS" -Database 'SQLWATCH' -ErrorAction "Stop" -Query "exec [dbo].[usp_sqlwatch_internal_action_queue_update]
					@queue_item_id = $queue_item_id,
					@error = ''$ErrorOutput'',
					@exec_status = ''$MsgType''"
	}
}

sqlcmd.exe -S localhost\SQLEXPRESS -Q "EXEC [SQLWATCH].[dbo].[CollectData02]"


##Get-WMIObject Win32_Volume',		2,'SQLWATCH-LOGGER-DISK-UTILISATION',	'PowerShell', N'
#https://msdn.microsoft.com/en-us/library/aa394515(v=vs.85).aspx
#driveType 3 = Local disk
Get-WMIObject Win32_Volume | ?{$_.DriveType -eq 3 -And $_.Name -notlike "?\Volume*" } | %{
    $VolumeName = $_.Name
    $FreeSpace = $_.Freespace
    $Capacity = $_.Capacity
    $VolumeLabel = $_.Label
    $FileSystem = $_.Filesystem
    $BlockSize = $_.BlockSize
    Invoke-SqlCmd -ServerInstance "localhost\SQLEXPRESS" -Database "SQLWATCH" -Query "
	 exec [dbo].[usp_sqlwatch_internal_add_os_volume] 
		@volume_name = '$VolumeName', 
		@label = '$VolumeLabel', 
		@file_system = '$FileSystem', 
		@block_size = '$BlockSize';
	 exec [dbo].[usp_sqlwatch_logger_disk_utilisation_os_volume] 
		@volume_name = '$VolumeName',
		@volume_free_space_bytes = $FreeSpace,
		@volume_total_space_bytes = $Capacity
    " 
}

sqlcmd.exe -S localhost\SQLEXPRESS -Q "EXEC [SQLWATCH].[dbo].[CollectData03]"
