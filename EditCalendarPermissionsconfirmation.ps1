Write-host -ForegroundColor darkgray 'Script Written By Alex Martini
'
Write-host -ForegroundColor darkgray 'You must have the Exchange Online Management Powershell Module installed to run this script
'

Write-host -ForegroundColor darkgray "This script uses the Add-MailboxFolderPermission cmdlet to add permissions to the target mailbox's calendar folder
"

connect-exchangeonline

$targetuser = Read-Host -Prompt '
Input the target user UPN that you would like to add calendar permissions to
>'

$permissionsuser = Read-Host -Prompt '
Input the user/mail enabled security group UPN that you want to have the calendar permissions
>'

Write-Host -ForegroundColor green '
Author: ' -NoNewline
Write-Host -ForegroundColor white 'CreateItems, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems'

Write-Host -ForegroundColor green '
Contributor: ' -NoNewline
Write-Host -ForegroundColor white 'CreateItems, FolderVisible'

Write-Host -ForegroundColor green '
Editor: '-NoNewline
Write-Host -ForegroundColor white 'CreateItems, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems'

Write-Host -ForegroundColor green '
NonEditingAuthor: ' -NoNewline
Write-Host -ForegroundColor white 'CreateItems, DeleteOwnedItems, FolderVisible, ReadItems'

Write-Host -ForegroundColor green '
Owner: ' -NoNewline
Write-Host -ForegroundColor white 'CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderContact, FolderOwner, FolderVisible, ReadItems'

Write-Host -ForegroundColor green '
PublishingAuthor: ' -NoNewline
Write-Host -ForegroundColor white 'CreateItems, CreateSubfolders, DeleteOwnedItems, EditOwnedItems, FolderVisible, ReadItems'

Write-Host -ForegroundColor green '
PublishingEditor: ' -NoNewline
Write-Host -ForegroundColor white 'CreateItems, CreateSubfolders, DeleteAllItems, DeleteOwnedItems, EditAllItems, EditOwnedItems, FolderVisible, ReadItems'

Write-Host -ForegroundColor green '
Reviewer: ' -NoNewline
Write-Host -ForegroundColor white 'FolderVisible, ReadItems'

Write-Host -ForegroundColor green '
AvailabilityOnly: ' -NoNewline
Write-Host -ForegroundColor white 'View only availability data'

Write-Host -ForegroundColor green '
LimitedDetails: ' -NoNewline
Write-Host -ForegroundColor white 'View availability data with subject and location'

Write-host -ForegroundColor darkgray '


For more info visit https://learn.microsoft.com/en-us/powershell/module/exchange/add-mailboxfolderpermission?view=exchange-ps
'


$permissionlevel = Read-Host -Prompt '
Input permission level for the user/group
>'

Write-Warning "You will be giving $permissionlevel permissions to $permissionsuser for the calendar belonging to $targetuser"

$confirmation = Read-Host "Are you Sure You Want To Proceed (Y/N)"
if ($confirmation -eq 'y') {
    
Add-MailboxFolderPermission ${targetuser}:\calendar -User $permissionsuser -AccessRights $permissionlevel

Write-Host "Current calendar permissions for $targetuser"

get-MailboxFolderPermission ${targetuser}:\calendar |format-list

Write-Host -ForegroundColor Green '
Closing this session to Exchange Online to free up connections
'

Disconnect-ExchangeOnline -Confirm:$false

Read-Host -Prompt 'Script finished, Press Enter to exit'}