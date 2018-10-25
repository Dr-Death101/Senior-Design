#Gets the path that the shell is currently running in
$ScriptPath = Split-Path -Path $PSCommandPath

Write-Host "IP Addresses:"
#Run the IPAddress script
. "$ScriptPath\IPAddress"
Get-IPs -IncludeVM

Write-Host "OS Versions:"
#Run the OSVersion script
. "$ScriptPath\OSVersion"
Get-OS -IncludeVM -VMCredential (Get-Credential) | Format-Table | Write-Host
#Run the DriveSpace script and pipe output to Format-Table for better readablility
#The paramter it takes is the minimum amount of space in GB that should trigger a warning
& "$ScriptPath\DriveSpace" 5 | Format-Table