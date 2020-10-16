start /wait powershell.exe -executionpolicy bypass -Command "Invoke-WebRequest -Uri https://501commons-my.sharepoint.com/:u:/g/personal/dorian_501commons_org/EeL_uxRTJj5MphyVMuOhlsIBL1OS2f0r8UTapjVmsTlh5g?e=VNrRVP -Outfile .\Test.ps1"
powershell.exe executionpolicy bypass -Command "powershell.exe '.\Test.ps1' -Verb runAs"
