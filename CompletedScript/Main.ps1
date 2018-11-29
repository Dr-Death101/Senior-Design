. "$PSScriptRoot\NewDataSheet.ps1"

$newFile = Get-DataSheet

$reportsPath = "$PSScriptRoot\Data Sheet\js\reports.js"

$reports = Get-Content $reportsPath
$reports[$reports.Length - 1] = "`"$newFile`",`n];"
$reports | Set-Content $reportsPath

Invoke-Item "$PSScriptRoot\Data Sheet\index.html"