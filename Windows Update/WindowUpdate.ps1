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

# #Install Chrome - Removing this install methid in faovr of choco. Scritps are still in place if errors occure
# & $PSScriptRoot/InstallScripts/Chromeinstall.ps1
# #Install Firefox
# & $PSScriptRoot/InstallScripts/FirefoxInstall.ps1
# #Install Adobe
# & $PSScriptRoot/InstallScripts/AdobeInstall.ps1

# #Install office
# Start-Process .\office\setup.exe -wait
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Use choco to install adobe reader, chrome, firefox

choco install firefox -y
choco install googlechrome -y
choco install adobereader -params ''/DesktopIcon /UpdateMode:0'' -y

Get-LocalUser | Disable-LocalUser  
& $PSScriptRoot/InstallScripts/UserAdd.ps1

#Install all Windows Updates - note this will restart the computer if needed. 
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoRebo

Write-Host -NoNewLine 'Script complete. Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

