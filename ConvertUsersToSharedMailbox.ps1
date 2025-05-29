Write-host -ForegroundColor darkgray "This script will convert your CSV file of users to shared mailboxes, append (Shared Mailbox) to their display name, Hide them from the GAL, and block direct signin to the individual account"
Write-host -ForegroundColor darkgray "Script written by Alex Martini"
Read-Host "Press enter to continue"

Write-host -ForegroundColor red 'Your CSV file must be formatted like the table below for the script to function.'

#Show Example Table

$table = New-Object System.Data.DataTable

[void]$table.Columns.Add("displayname")
[void]$table.Columns.Add("upn")
[void]$table.Rows.Add("Linus Torvalds", "ltorvalds@contoso.com")
[void]$table.Rows.Add("Bill Gates", "bgates@contoso.com")
[void]$table.Rows.Add("Steve Jobs", "sjobs@contoso.com")


$table |ft

Write-host -ForegroundColor red 'All users in your CSV file must have an Exchange license to be converted to a shared mailbox. The license can be removed after conversion.'

Read-host -Prompt "Press enter to continue"


Write-host -ForegroundColor green "Login to Exchange Online"

#Connect to ExchangeOnline PS module

Connect-ExchangeOnline

Write-host -ForegroundColor green "Login to AzureAD"

#Connect to the AzureAD PS Module

Connect-AzureAD


Do{

#Request CSV path from user

$csvfile = Read-host -Prompt "Input the full path to the csv file that contains your list of display names and email addresses. There must be two columns with the headers displayname and upn.
->"


#Import CSV to PS session

Import-Csv $csvfile | foreach { 
$displayname = $_.displayname;
$upn = $_.upn;


#Convert Mailbox to Shared type

Write-host Converting $upn to a shared mailbox
Set-Mailbox -Identity $upn -Type Shared


#Edit display name of mailbox

Write-Host Changing display name of $upn to "$displayname (Shared Mailbox)"
Set-User -Identity $upn -DisplayName "$displayname (Shared Mailbox)" -Confirm:$false


#Block Signin

Write-Host "Blocking direct signin to $upn"
Set-AzureADUser -ObjectID $upn -AccountEnabled $false



#Hide user from GAL

Write-Host "Hiding $upn from GAL"
Set-Mailbox -Identity $upn -HiddenFromAddressListsEnabled $true


}


Write-host -ForegroundColor green "The users in the CSV have been converted."

#Ask user if they would like to restart the script with a new list

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