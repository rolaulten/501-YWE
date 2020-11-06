<#
Installs all windows updates, and requested apps, as well as setting tasks for ongoing weekly updates.

This script must be called as an administrator

Currently untested!
#>

#Install windows update modual - https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
Set-ExecutionPolicy RemoteSigned
Install-Module -Name PSWindowsUpdate –Force 
Import-Module PSWindowsUpdate 

#set Windows updates to download and install every wedensday 
$WinTaskname = 'WeeklyWindowsUpdate'
#$user = $env:system #I dont think this works?
$WinTrigger = New-ScheduledTaskTrigger -At 3:00PM -Weekly -DaysOfWeek Wednesday
$WinAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command {Install-WindowsUpdate -MicrosoftUpdate -AcceptAll}"
Register-ScheduledTask -Action $WinAction -Trigger $WinTrigger -TaskName $WinTaskname


#Instlal Choco for app updates - see https://chocolatey.org/docs/installation
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Install standard apps - this may be updated as needed
choco install firefox -y
choco install googlechrome -y
choco install adobereader -params '"/DesktopIcon /UpdateMode:0"' -y

#Create task for weekly app updates 
$ChocoTaskName = "Weekly App Update"
$ChocoTrigger = New-ScheduledTaskTrigger -At 3:00PM -Weekly -DaysOfWeek Tuesday
$ChocoAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command {choco upgrade all -y}"
Register-ScheduledTask -Action $ChocoAction -Trigger $ChocoTrigger -TaskName $ChocoTaskName

#######Create/manage local user acconts

#Disable all current accounts
Get-LocalUser | Disable-LocalUser

#Function as we will be createing muliple accounts
function UserCreate ($Username,$Password) {
    $SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    New-LocalUser -Name $Username -Password $SecurePassword
}
   
UserCreate('YWEAdmin','SomePassword') #CreateAdmin Account
Add-LocalGroupMember -Group 'Administrators' -Member 'YWEAdmin'

UserCreate('YWEUser','SomePassword') #Create local user account

#Install all Windows Updates - note this will restart the computer if needed. 
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot