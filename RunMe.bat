start /wait powershell.exe -executionpolicy bypass -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/rolaulten/501-YWE/main/GetComputerInfo.ps1P -Outfile .\GetInfo.ps1"
powershell.exe executionpolicy bypass -Command "powershell.exe '.\GetInfo.ps1' -Verb runAs"
