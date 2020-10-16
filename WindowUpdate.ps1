<#
Install All windwos updates and set up re-occuring windows update
reoccuring windows update will be forced

This script must be called as an administrator

Currently untested!
#>

#Install windows update modual - https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
Set-ExecutionPolicy RemoteSigned
Install-Module -Name PSWindowsUpdate –Force 
Import-Module PSWindowsUpdate 

#set updates to download ever wedensday 
$taskname = 'WeeklyWindowsUpdate'
$user = $env:system #I dont think this works?
$Trigger = New-ScheduledTaskTrigger -At 3:00PM -Weekly
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "powershell.exe Install-WindowsUpdate -MicrosoftUpdate -AcceptAll"


#Install all the updates
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot