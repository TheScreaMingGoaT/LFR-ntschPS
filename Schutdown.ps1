$action = New-ScheduledTaskAction -Execute ".\message.bat"
$trigger = New-ScheduledTaskTrigger -Daily -At "15:50"
$princibal = New-ScheduledTaskPrincipal -Userid 'gr2.laba304.local\Administrator' -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet 
$task = New-ScheduledTask -Action $action -Principal $princibal -Trigger $trigger -Settings $settings 
Register-ScheduledTask Scheduled_Message -InputObject $task

$actionShutdown = New-ScheduledTaskAction -Execute "shutdown" -Argument "/s /t 0"
$triggerShutdown = New-ScheduledTaskTrigger -Daily -At "16:00"
$princibalShutdown = New-ScheduledTaskPrincipal -Userid 'gr2.laba304.local\Administrator' -RunLevel Highest
$settingsShutdown = New-ScheduledTaskSettingsSet 
$taskShutdown = New-ScheduledTask -Action $actionShutdown -Principal $princibalShutdown -Trigger $triggerShutdown -Settings $settingsShutdown 
Register-ScheduledTask Scheduled_Shutdown -InputObject $task