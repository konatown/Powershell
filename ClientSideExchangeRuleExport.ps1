Write-host -ForegroundColor darkgray "

This script will export the user side Exchange rule's Name, Enabled/Disabled State, Description, and MailboxOwnerId

Script written by Alex Martini

"


Read-Host 'Press enter to connect to Exchange Online'

    Connect-Exchangeonline -ShowBanner:$false



$ruleidentity = Read-Host -Prompt '
Enter the rule ID/item from the alert recieved

Example: "be23e59a-8d14-4687-8a97-98c7af55c7c2\14084856363989598209"

-->'

    get-inboxrule -identity $ruleidentity |Select Name,Enabled,Description,MailboxOwnerId |fl


$msg = 'Would you like to export the above information to a TXT file? (Y/N)'
do {
    $response = Read-Host -Prompt $msg
    if ($response -eq 'y') {


            
Write-Host -ForegroundColor green '
Exporting data to c:\users\$Env:UserName\desktop\RuleInfo.txt
'

    get-inboxrule -identity $ruleidentity |Select Name,Enabled,Description,MailboxOwnerId |fl > c:\users\$Env:UserName\desktop\RuleInfo.txt


Read-Host '
Script Finished.

Press Enter to close'


#Disconnect from Exchange
    Disconnect-ExchangeOnline -Confirm:$false

Exit

    }
} until ($response -eq 'n')


Read-Host '
Script Finished.

Press Enter to close'

    Disconnect-ExchangeOnline -Confirm:$false
    Exit