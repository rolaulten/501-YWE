# Unattended Install of Firefox

# Path for the workdir
$workdir = "$ENV:Temp\Firefox"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
ELSE
{ New-Item -Path $workdir  -ItemType directory }

# Download the installer
If (Test-Path "$workdir\Firefox.exe" -ne true) {
    $source = "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US"
    $destination = "$workdir\Firefox.exe"
    
    # Check if Invoke-Webrequest exists otherwise execute WebClient

    if (Get-Command 'Invoke-Webrequest') {
        Invoke-WebRequest $source -OutFile $destination
    }
    else {
        $WebClient = New-Object System.Net.WebClient
        $webclient.DownloadFile($source, $destination)
    }
}

Start-Process -FilePath $destination -Args "/s" -Verb RunAs -Wait; 
Remove-Item $destination;