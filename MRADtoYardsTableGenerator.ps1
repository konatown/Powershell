Do{

Write-host -ForegroundColor darkgray "This script will allow you to calculate the distance of a known size object using an optic with an MRAD reticle.
"
Write-host -ForegroundColor darkgray "This script will also allow you to save the data to a CSV file, this type of file can be opened with a spreadsheet program such as MS Excel, then printed out into range cards.
"
Write-host -ForegroundColor darkgray "If you decide to export the data table, a folder will be created on your desktop called MRAD-Calc. The actual tables will be titled after the object name you provide the script.
"
Write-host -ForegroundColor darkgray "When entering values do not use symbols, dashes, etc. Only letters and numbers. If you want your values capitalized do so when inputting the data.
"




$objectName = Read-Host -Prompt 'Input your object name
->'

$objectsize = Read-Host -Prompt 'Input your object size in inches
->'

$wh = Read-Host -Prompt 'Width or Height? (Type H or W for concise coloumns)
->'



$100ymils = [math]::Round([decimal]$objectsize * 27.77 / 100,2)
$150ymils = [math]::Round([decimal]$objectsize * 27.77 / 150,2)
$200ymils = [math]::Round([decimal]$objectsize * 27.77 / 200,2)
$250ymils = [math]::Round([decimal]$objectsize * 27.77 / 250,2)
$300ymils = [math]::Round([decimal]$objectsize * 27.77 / 300,2)
$350ymils = [math]::Round([decimal]$objectsize * 27.77 / 350,2)
$400ymils = [math]::Round([decimal]$objectsize * 27.77 / 400,2)
$450ymils = [math]::Round([decimal]$objectsize * 27.77 / 450,2)
$500ymils = [math]::Round([decimal]$objectsize * 27.77 / 500,2)
$550ymils = [math]::Round([decimal]$objectsize * 27.77 / 550,2)
$600ymils = [math]::Round([decimal]$objectsize * 27.77 / 600,2)
$650ymils = [math]::Round([decimal]$objectsize * 27.77 / 650,2)
$700ymils = [math]::Round([decimal]$objectsize * 27.77 / 700,2)



$table = New-Object System.Data.DataTable

[void]$table.Columns.Add("Object")
[void]$table.Columns.Add("Inches")
[void]$table.Columns.Add("W/H")
[void]$table.Columns.Add("Mils")
[void]$table.Columns.Add("Yards")



[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$100ymils", "100")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$150ymils", "150")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$200ymils", "200")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$250ymils", "250")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$300ymils", "300")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$350ymils", "350")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$400ymils", "400")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$450ymils", "450")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$500ymils", "500")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$550ymils", "550")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$600ymils", "600")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$650ymils", "650")
[void]$table.Rows.Add("$objectName", "$objectsize", $wh, "$700ymils", "700")


Write-Output $table |ft


if ((Read-Host "Would you like to export this table as a CSV file? (Y/N)") -eq "Y") {
    do {

Write-Host -ForegroundColor green "File will be exported to Desktop\MRAD-Calc\$objectname.csv" 

$desktop = [environment]::GetFolderPath('Desktop')


New-Item -Force -Path $desktop -Name "MRAD-Calc" -ItemType Directory


$table | export-csv -path $desktop\MRAD-Calc\$objectname.csv -NoTypeInformation
    }
    while ($strQuit -eq "N")
}


   Do
   {
      $again = Read-host "Would you like to calculate another object? (Y/N)"
      If (($again -eq "Y") -or ($again -eq "N"))
      { $go = $true
      }
      Else
      { write-host -fg Red "Invalid input. Please try again"
      }
   }Until($go)

}
Until($again -eq "N")