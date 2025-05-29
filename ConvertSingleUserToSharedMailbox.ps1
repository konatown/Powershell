Write-host -ForegroundColor darkgray "This script will convert a user to a shared mailboxe, append (Shared Mailbox) to their display name, Hide them from the GAL, and block direct signin to the individual account"
Write-host -ForegroundColor darkgray "Script written by Alex Martini"
Read-Host "Press enter to continue"


Write-host -ForegroundColor green "Login to Exchange Online"

#Connect to ExchangeOnline PS module

Connect-ExchangeOnline

Write-host -ForegroundColor green "Login to AzureAD"

#Connect to the AzureAD PS Module

Connect-AzureAD


Do{

#Request UPN

$upn = Read-host -Prompt "Input the UPN of the user you would like to convert. ex. User@Example.com
->"




#Pull user info

$userinfo = get-user $upn
$displayname = $userinfo.displayname 
$isdirsynced = $userinfo.IsDirSynced


#Check if user is synced with local AD

if($isdirsynced -eq $True){

    Write-host -ForegroundColor red $upn is synced with the local directory, unsync the user before continuing.
    Read-Host 'Press any key to quit'
        Exit
     }



#Get mailbox TotalItemSize value

$MailboxSize = (Get-EXOMailboxStatistics -Identity $upn).TotalItemSize.Value


#Compare $mailboxsize against 49.9GB

if($MailboxSize -gt 53579700000){

    Write-host -ForegroundColor red $upn is over 50 GB and cannot be converted to a shared mailbox.
    Read-Host 'Press any key to quit'
        Exit
     }


#Check ArchiveStatus

$ArchiveStatus = get-mailbox $upn | select ArchiveStatus | Format-Table -HideTableHeaders | Out-String
if($ArchiveStatus -match "Active") {
    
    Write-host -ForegroundColor red $upn has an Online Archive attached to it, if you convert this user mailbox to a shared mailbox the Archive will be Deleted. If you want to continue, delete the archive first, then run the script again. Stopping Script.
    Read-Host 'Press any key to quit'
        Exit
    }


#Find distro groups where $upn is a member

$Groups = Get-AzureADUserMembership -ObjectId $upn

Write-Host Removing $upn from groups: 
Echo $Groups.DisplayName


#Remove $upn form all $Groups

foreach($Group in $Groups){ 
    try { 
        Remove-AzureADGroupMember -ObjectId $Group.ObjectID -MemberId $upn -erroraction Stop 
    }
    catch {
        
        Remove-DistributionGroupMember -identity $group.mail -member $upn -BypassSecurityGroupManagerCheck -Confirm:$false
    }



}


#Convert Mailbox to Shared type

Write-host Converting $upn to a shared mailbox
Set-Mailbox -Identity $upn -Type Shared


#Edit display name of mailbox

Write-Host Changing display name of $upn to $displayname "(Shared Mailbox)"
Set-User -Identity $upn -DisplayName "$displayname (Shared Mailbox)" -Confirm:$false


#Block Signin

Write-Host "Blocking direct signin to $upn"
Set-AzureADUser -ObjectID $upn -AccountEnabled $false


#Hide user from GAL

Write-Host "Hiding $upn from GAL"
Set-Mailbox -Identity $upn -HiddenFromAddressListsEnabled $true




Write-host -ForegroundColor green "$upn has been converted to a shared mailbox."


Write-host -ForegroundColor red "Be sure to remove any licneses, the shared mailbox does not require one."


$initialResponse = Read-Host "Do you want delegate the $upn mailbox to any users? (y/n)"

if ($initialResponse -eq 'n') {
    Write-Host "Skipping delegate addition."
    # Continue with the rest of the script here
} else {
    # If the user chooses 'y', continue with the delegate addition process
    do {
        # Prompt for the delegate user
        $delegateuser = Read-Host "Enter the UPN of the user you want to delegate $upn to"

        # Run the Add-MailboxPermission command with the delegate user
        Add-MailboxPermission $upn -User $delegateuser -AccessRights FullAccess

        # Ask if the user wants to continue
        $response = Read-Host "Do you want to add another delegate? (y/n)"
    } while ($response -eq 'y')
}




#Ask user if they would like to restart the script with a new user

Do
   {
      $again = Read-host "Would you like run again? (Y/N)"
      If (($again -eq "Y") -or ($again -eq "N"))
      { $go = $true
      }
      Else
      { write-host -ForegroundColor red "Invalid input. Please try again"
      }
   }Until($go)

}
Until($again -eq "N")
Disconnect-ExchangeOnline
Disconnect-AzureAD