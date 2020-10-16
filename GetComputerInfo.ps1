<#
Script for getting basic info about a workstation. Designed to upload to a remote folder for further processing
#>

# Generate the info that we need
$Version = try{Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId -ErrorAction Stop|Select-Object -expand ReleaseId
}catch{(Get-WmiObject -class Win32_OperatingSystem).Version}
$WinLicence = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName -ErrorAction Stop|Select-Object -expand ProductName

$Report = New-Object psobject -property @{
    "WindowsRelease" = $Version
    "ProductLicence" = $WinLicence
    "Hostname" = (Get-WmiObject Win32_ComputerSystem).Name
    "Domain" = (Get-WmiObject Win32_ComputerSystem).Domain
    "Model" = (Get-WmiObject Win32_ComputerSystem).Model
    "Manufacturer" = (Get-WmiObject Win32_ComputerSystem).Manufacturer
    "TotalMemory" = (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory
    "WindowsVersion" = (get-wmiobject win32_operatingsystem).Version
    "SerialNumber" = (Get-WMIObject -Class WIN32_SystemEnclosure -ComputerName $env:ComputerName).SerialNumber
    "CurrentUser" = $env:USERNAME
    "FreeDiskSpace" = (get-wmiobject -class win32_logicaldisk -Filter "DeviceID='C:'").freespace
    "TotalDiskSpace" = (get-wmiobject -class win32_logicaldisk -Filter "DeviceID='C:'").Size
}

#format as a CSV and export it to local working folder
$csvname = $Report.Hostname.ToString()
$filename = ".\$csvname.csv"
$Contents =  Write-Output $Report | Select-Object -Property *
Export-Csv -InputObject $Contents -Path $filename -NoTypeInformation

#send data to remote folder for further processing - this section does not work

$client = New-Object System.Net.WebClient
$client.Credentials = New-Object System.Net.NetworkCredential("501commons", "Welcome1")
$client.UploadFile("ftp://192.168.1.32/$csvname.csv", "$csvname.csv")


#Cleanup
Remove-Item -Path.\GetInfo.ps1
Remove-Item -path $filename
