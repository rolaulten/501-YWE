$WinTaskname = 'WeeklyWindowsUpdate'
$WinTrigger = New-ScheduledTaskTrigger -At 3:00PM -Weekly -DaysOfWeek Wednesday
$WinAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command {Install-WindowsUpdate -MicrosoftUpdate -AcceptAll}"
Register-ScheduledTask -Action $WinAction -Trigger $WinTrigger -TaskName $WinTaskname
