#Gets the path that the shell is currently running in
$ScriptPath = Split-Path -Path $PSCommandPath

#Include Scripts
. "$ScriptPath\DriveSpace.ps1"
. "$ScriptPath\IPAddress.ps1"
. "$ScriptPath\OSVersion.ps1"
. "$ScriptPath\PhysicalMemory.ps1"
. "$ScriptPath\Services.ps1"
. "$ScriptPath\ShowProcesses.ps1"
. "$ScriptPath\VersionData.ps1"
. "$ScriptPath\VMNames.ps1"

$VMNames = Get-VMComputerNames

Write-Host "Version Data"
Get-VersionData

Write-Host "IP Addresses"
Get-IPs | Format-Table

Write-Host "OS Versions"
Get-OS -VMNames $VMNames | Format-Table

Write-Host "Drive Space"
Get-DriveSpace -VMNames $VMNames | Format-Table

Write-Host "Memory Usage"
Get-MemoryUsage

Write-Host "Processes"
Get-Processes

Write-Output "Services"
Get-Services -VMNames $VMNames | Format-Table