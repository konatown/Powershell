Write-host -ForegroundColor darkgray '

This script will create the Exchange rule and connector to limit inbound mail to AppRiver servers only

If an email is sent directly to the Exchange server (likely spam attempting to circumvent the filter) the mail will be 
redirected to to AppRiver for analysis.


Script written by Alex Martini


' 


$Domain = Read-Host -Prompt "
Input the organization's domain to confirm that the MX records are configured properly before limiting inbound mail
-->"



#MX Record check
$String = Resolve-DnsName -Name $Domain.trim() -Type MX | select -expandproperty NameExchange |out-string
$Table = Resolve-DnsName -Name $Domain.trim() -Type MX |ft |out-string
if ($string.Contains("arsmtp.com")) {
    Write-Host "
    MX Records for $Domain : $Table
    "
    
    
    Write-Host -ForegroundColor green '
The MX Records are correctly setup to point to AppRiver
The script will continue now
    '
    
    
Read-Host 'Press enter to connect to Exchange Online'

#Connect to Exchange Online
    Connect-ExchangeOnline -ShowBanner:$false


Write-Host -ForegroundColor green '


Creating Connector'

    New-OutboundConnector -Enabled:$True -ConnectorType Partner -TlsSettings CertificateValidation -IsTransportRuleScoped:$True -RouteAllMessagesViaOnPremises:$False -CloudServicesMailEnabled:$False -AllAcceptedDomains:$False -SenderRewritingEnabled:$False -TestMode:$False -Name "Limit Inbound to AppRiver"


Write-Host -ForegroundColor green '
Validating Connector'
Write-host 'This will take some time
'
     
    Validate-OutboundConnector -Identity "Limit Inbound to AppRiver" -Recipients techs@grovenetworks.com |select TaskName, IsTaskSuccessful |fl
    Set-OutboundConnector -Identity "Limit Inbound to AppRiver" -IsValidated:$true

Write-Host '
Waiting 15 seconds for connector to propagate
'

    Start-Sleep -Seconds 15


Write-Host -ForegroundColor green '
Creating Limit Inbound to Appriver Transport Rule
'

    New-TransportRule -Name 'Limit Inbound to AppRiver' -Mode Enforce -SetAuditSeverity High -FromScope NotInOrganization -ExceptIfMessageTypeMatches Voicemail -ExceptIfSenderIpRanges 5.152.184.128/25, 5.152.185.128/26, 8.19.118.0/24, 8.31.233.0/24, 69.20.58.224/28, 5.152.188.0/24, 199.187.164.0/24, 199.187.165.0/24, 199.187.166.0/24, 199.187.167.0/24, 69.25.26.128/26, 204.232.250.0/24, 74.203.184.184/32 -ExceptIfHeaderContainsMessageHeader 'x-ms-exchange-meetingforward-message' -ExceptIfHeaderContainsWords 'Forward' -RouteMessageOutboundConnector 'Limit Inbound to AppRiver' -Enabled:$True -Priority 0 |select Identity, IsValid |fl


$msg = 'Do you want to create an addtional rule to set the spam confidence level to -1 for all mail recieved from AppRiver Servers? [Y/N]'
do {
    $response = Read-Host -Prompt $msg
    if ($response -eq 'y') {
            
Write-Host -ForegroundColor green '
Creating Limit Bypass Spam Filtering for Appriver IPs Rule
'
      New-TransportRule -Name 'Bypass Spam Filtering for Appriver IPs' -Comments ' ' -Mode Enforce -SenderIpRanges 5.152.184.128/25, 5.152.185.128/26, 8.19.118.0/24, 8.31.233.0/24, 69.20.58.224/28, 5.152.188.0/24, 199.187.164.0/24, 199.187.165.0/24, 199.187.166.0/24, 199.187.167.0/24, 69.25.26.128/26, 204.232.250.0/24, 74.203.184.184/32 -SetSCL -1 -Priority 1 |select Identity, IsValid |fl


Read-Host -Prompt '
Script Finished.

Press Enter to close'



#Disconnect from Exchange
    Disconnect-ExchangeOnline -Confirm:$false

Exit

    }
} until ($response -eq 'n')



Read-Host -Prompt '
Script Finished.

Press Enter to close'



#Disconnect from Exchange
    Disconnect-ExchangeOnline -Confirm:$false



} else {
    Write-Host "
    MX Records For $Domain : $Table
    "
    Write-Host -ForegroundColor red "
The MX Records are not configured properly
Please exit the script and come back when they are configured correctly.

If you attempt to bypass this check and create the connector/rule you will block all inbound mail to the organization.
    "
    Read-Host -Prompt '
    Press enter to exit script'
    Exit
}