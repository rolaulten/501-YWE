#COmbines all incoming CSV's into one report. Warning, do not have outfile in the same drectory that this script was called in, you will create a loop with no exit clause

$loc = 'C:\Users\dorian\OneDrive - 501 Commons\Projects\YWE - BSK windwos update\inventoryreport.csv'
Get-ChildItem -Filter *.csv | Select-Object -ExpandProperty FullName | Import-Csv | Export-Csv $loc -NoTypeInformation -Append
