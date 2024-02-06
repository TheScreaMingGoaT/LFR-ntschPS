$action = New-ScheduledTaskAction -Execute "shutdown" -Argument "/s /t 0"
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00"
$princibal = New-ScheduledTaskPrincipal -Userid 'gr2.laba304.local\Administrator' -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet 
$task = New-ScheduledTask -Action $action -Principal $princibal -Trigger $trigger -Settings $settings 
Register-ScheduledTask Scheduled_Shutdown -InputObject $task