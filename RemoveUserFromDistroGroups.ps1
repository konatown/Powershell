$upn = Read-host -Prompt "Input the UPN of the user you would like to convert. ex. User@Example.com
->"

$DistroGroups = Get-DistributionGroup | where { (Get-DistributionGroupMember $_.Name | foreach {$_.PrimarySmtpAddress}) -contains $upn} | select name | Format-Table -HideTableHeaders | Out-String
$Distrogrouptable = Get-DistributionGroup | where { (Get-DistributionGroupMember $_.Name | foreach {$_.PrimarySmtpAddress}) -contains $upn} | select displayname, primarySMTPaddress | Format-Table
$Distrogrouptable
$yesNo = Read-Host -prompt "Would you like to remove $upn from these groups? Y/N"
if ($yesNo -eq 'y')
{
    do 
    {

foreach($DistroGroup in $DistroGroups) { 

        Write-Host Remvoing $upn from $DistroGroup
        Remove-DistributionGroupMember -Identity $Group -Member $upn -Confirm:$false
                }

               
    }
    while($strQuit -eq 'y')
}
