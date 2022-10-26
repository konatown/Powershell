$VerbosePreference = "Continue"
connect-msolservice
$User = Read-Host -Prompt 'Input the email address you would like to never expire'
Get-MsolUser –UserPrincipalName $User | Set-MsolUser –PasswordNeverExpires $True
$P = Get-MSOLUser -UserPrincipalName $User | Select PasswordNeverExpires
Write-Output $P
Read-Host -Prompt "Press Enter to test"
Read-Host -Prompt "Press Enter to exit"
