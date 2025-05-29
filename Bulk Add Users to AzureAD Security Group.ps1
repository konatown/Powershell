Write-host -ForegroundColor darkgray "This script will allow you to add a CSV of UPNs to an Azure Security Group"
Write-host -ForegroundColor darkgray "Script written by Alex Martini"
Read-Host "Press enter to continue"

Write-host -ForegroundColor darkgray "You can get the ObjectID of the group by running Get-AzureADGroup with no arguments" 


$GroupObjectID = Read-host -Prompt "Input the Object ID of the group you would like to add users to
->"

$CSVPath = Read-host -Prompt "Input the full path to the CSV containing your users UPNs. It must be one column with a header of Userprincipalname
->"


#Connect to AzureAD PowerShell Module
Connect-AzureAD

#Convert UPNs to ObjectIDs and add them to the group
Import-Csv $CSVPath | ForEach-Object {
    $ObjectId = (Get-AzureADUser -ObjectId $_.Userprincipalname).ObjectId
    If ($ObjectId) {
        Add-AzureADGroupMember -ObjectId $GroupObjectID -RefObjectId $ObjectId
    }
}

Read-Host "Complete, press enter to disconnect from AzureAD and close"

#Disconnect from AzureAD PS Module
Disconnect-AzureAD