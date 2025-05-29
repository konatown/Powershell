Write-host -ForegroundColor darkgray 'Script Written By Alex Martini
'
Write-host -ForegroundColor darkgray 'You must have the Exchange Online Powershell Module installed to run this script
'

Connect-ExchangeOnline

Write-Host -ForegroundColor green '
Getting list of Distribution Groups
'

Get-DistributionGroup | select name| format-table

$group = Read-Host -Prompt "Input the Distribution Group you would like to export the users of
->"


Get-DistributionGroupMember $group | Select displayname | export-csv c:\users\$env:USERNAME\desktop\$group-DistributionGroupMemberExport.csv


Write-Host -ForegroundColor green "
CSV exported to c:\users\$env:USERNAME\desktop\$group-DistributionGroupMemberExport.csv
"


Disconnect-ExchangeOnline -Confirm:$false

Read-Host "Press enter to exit"