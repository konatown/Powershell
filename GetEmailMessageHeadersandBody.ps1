Write-host -ForegroundColor darkgray 'Script Written By Alex Martini
'
Write-host -ForegroundColor darkgray 'You must have the MS Graph SDK Powershell Module installed to run this script
'

Write-host -ForegroundColor darkgray "This script will retrieve the message headers for an E-Mail
You will need the Online Message ID from the More Information section of a Message Trace
"

Write-host -ForegroundColor darkgray "The account you authenticate with must have Read/Manage permissions to the mailbox
"
#Connect to MS Graph
Connect-MgGraph 

#Gather parameters
$UPN = Read-Host -Prompt '
Input the E-Mail address of the recipient.
>'

$MessageID = Read-Host -Prompt '
Input the full internet message ID from the Message Trace. Ex. "<BN0PR13MB5149C3E4SLEK2355JENSQ@BN0PR13MB5149.namprd13.prod.outlook.com>" You must include the angle brackets.
>'



$Message = Get-MgUserMessage -UserId $UPN -Filter "internetMessageId eq '$MessageID'"

Write-host Subject: $Message.Subject
Write-host Body: ($Message.Body |fl |out-string)
Write-host Headers: ($Message.InternetMessageHeaders|fl |out-string)

Read-Host -Prompt 'Script finished, Press Enter to exit'

Disconnect-MgGraph
