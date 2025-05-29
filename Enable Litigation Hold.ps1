Connect-exchangeonline
$User = Read-Host -Prompt 'Input the email address you would like to enable litigation hold for'
Set-Mailbox $User -LitigationHoldEnabled $True
Read-Host -Prompt "Press Enter to test Litigation Hold"
$P = get-mailbox $User | fl LitigationHoldEnabled
Write-Output $P
Read-Host -Prompt "Press Enter to exit"
