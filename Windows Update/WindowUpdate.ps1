<#
Installs all windows updates, and requested apps, as well as setting tasks for ongoing weekly updates.

This script must be called as an administrator

Currently untested!
#>

#Install windows update modual - https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
Set-ExecutionPolicy RemoteSigned
Install-Module -Name 'PSWindowsUpdate' –Force 
Import-Module PSWindowsUpdate 

# #Install office
# Start-Process .\office\setup.exe -wait
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Use choco to install adobe reader, chrome, firefox

choco install firefox -y
choco install googlechrome -y
choco install adobereader -params ''/DesktopIcon /UpdateMode:0'' -y

Get-LocalUser | Disable-LocalUser  
& $PSScriptRoot/InstallScripts/UserAdd.ps1

#create task to update every week
& $PSScriptRoot/InstallScripts/WinUpdateTask.ps1

#Install all Windows Updates - note this will restart the computer if needed. 
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoRebo

Write-Host -NoNewLine 'Script complete. Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

