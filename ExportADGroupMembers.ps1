Write-host -ForegroundColor darkgray 'Script Written By Alex Martini
'
Write-host -ForegroundColor darkgray '
This script must be run on a Domain Controller
'
Read-Host "Press enter to continue"

Write-Host -ForegroundColor green '
Getting list of AD Security Groups
'

Get-ADGroup -filter * |select name |sort name |format-table

$group = Read-Host -Prompt "Input the AD sec group you would like to export the users of
->"


Get-ADGroupMember $group | Select name | export-csv c:\users\$env:USERNAME\desktop\$group-GroupMemberExport.csv

Write-Host -ForegroundColor green "
CSV Exported to c:\users\$env:USERNAME\desktop\$group-GroupMemberExport.csv
"

Read-Host "Press enter to exit"