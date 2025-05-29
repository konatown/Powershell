$csvfile = "C:\rename.csv"
Import-Csv $csvfile | foreach { 
$oldName = $_.OldName;
$newName = $_.NewName;
$UN = Read-Host -Prompt 'Input the Doamin Administrator Username (Domain\Username)'
$PW = Read-Host -Prompt 'Input the Doamin Administrator Password'
  
Write-Host "Renaming computer from: $oldName to: $newName"
netdom renamecomputer $oldName /newName:$newName /uD:$UN /passwordD:$PW /force 
}

Pause