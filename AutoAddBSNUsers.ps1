#Connect to AzureAD PS Module, Must have proper cert installed in localmachine\personal

$tenantId = 
$appId = 
$thumb = 
Connect-AzureAD -TenantId $tenantId -ApplicationId $appId -CertificateThumbprint $thumb -InformationAction Ignore


#Get object ID of "BSN-Employees" group

$GroupID_1 = get-azureadgroup -searchstring "BSN-Employees" | select -expand objectID


#Get object ID of "BSN-Exclusion" group

$GroupID_2 = get-azureadgroup -searchstring "BSN-Exclusion" | select -expand objectID


#Get current Members of "BSN-Employees" group and "BSN-Exclusion" group

$Groups=@($GroupID_1,
    $GroupID_2)

 $UsersToExclude =  ForEach($Group in $Groups){
Get-AzureADGroupMember -all $true -ObjectId $Group | Select ObjectID 
}


#Get users with Exchange mailboxes

$ExchangeUsers = Get-AzureADUser -All $true|select objectID -ExpandProperty AssignedPlans|Where-Object {$_.CapabilityStatus -eq "Enabled" -and $_.Service -eq "MicrosoftCommunicationsOnline"} | select ObjectID


#Remove members of of "BSN-Employees" and "BSN-Exclusion" groups from $ExchangeUsers

$UsersToAdd = $ExchangeUsers |Where-Object {$item = $_; ! $UsersToExclude.Where({$item -like "${_}*"}, 'First')}


#Add remaining users to group

$UsersToAdd | ForEach-Object {Add-AzureADGroupMember -ObjectId $GroupID_1 -RefObjectId $_.ObjectId} 


#Disconnect
Disconnect-AzureAD
