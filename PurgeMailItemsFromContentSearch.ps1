Write-host -ForegroundColor darkgray 'Script Written By Alex Martini
'
Write-host -ForegroundColor darkgray 'You must have the MS 365 Compliance Powershell Module installed to run this script
'



#Connect to MS Compliance module
    Connect-IPPSSession



Write-Host -ForegroundColor green '
Getting list of open compliance searches
'


#Pull current content searches with details
    Get-ComplianceSearch | Format-Table


Write-Warning "Be sure that you have reviewed the results of your content search and are okay with ALL items being purged"

#Get content search name
$searchname = Read-Host -Prompt '

Enter the name of the Content Search you would like to purge:
>'



Write-Host -ForegroundColor green '
SoftDelete: ' -NoNewline
Write-Host -ForegroundColor white "message/s are moved to the Deletions folder in the user's Recoverable Items folder. It isn't immediately purged from Microsoft 365. The user can recover messages in the Deleted Items folder for the duration based on the deleted item retention period configured for the mailbox. After this retention period expires (or if user purges the message before it expires), the message is moved to the Purges folder and can no longer be accessed by the user. Once in the Purges folder, the message is retained for the duration based on the deleted item retention period configured for the mailbox if single items recovery is enabled for the mailbox. (In Microsoft 365, single item recovery is enabled by default when a new mailbox is created.) After the deleted item retention period expires, the message is marked for permanent deletion and will be purged from Microsoft 365 the next time that the mailbox is processed by the Managed Folder assistant"


Write-Host -ForegroundColor green '
HardDelete: ' -NoNewline
Write-Host -ForegroundColor white "message/s is moved to the Purges folder and can't be accessed by the user. After the message is moved to the Purges folder, the message is retained for the duration of the deleted item retention period if single item recovery is enabled for the mailbox. (In Microsoft 365, single item recovery is enabled by default when a new mailbox is created.) After the deleted item retention period expires, the message is marked for permanent deletion and will be purged from Microsoft 365 the next time the mailbox is processed by the Managed Folder assistant"

#Get desired purge type
$purgetype = Read-Host -Prompt '
Enter HardDelete or SoftDelete:
>'


Write-Warning "You will be deleting all mail in $searchname using the $purgetype purge type"


#Run purge    
  
    New-ComplianceSearchAction -SearchName $searchname -Purge -PurgeType $purgetype

    Get-ComplianceSearchAction ${searchname}_purge |format-list
    
Write-Host -ForegroundColor Green 'Purge running on the Exchange server, closing this session to Exchange Online to free up connections'
       
#Disconnect from cloud resource  
    Disconnect-ExchangeOnline -Confirm:$false


Read-Host 'Press enter to close script'