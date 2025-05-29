$csvfile = Read-Host -Prompt "
Drag and drop your CSV file into the script window, it must have one column with all the addresses whith the header titled Users
->"


Import-Csv $csvfile | foreach { 
$User = $_.Users;

Write-Host "Setting ChangePasswordAtLogon to True for $User"
Set-Aduser -Identity $user -ChangePasswordAtLogon:$True

Write-Host "Setting PasswordNeverExpires to False for $User"
Set-Aduser -Identity $user -PasswordNeverExpires:$False

}


Pause