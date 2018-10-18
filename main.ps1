#Gets the path that the shell is currently running in
$ScriptPath = Split-Path -Path $PSCommandPath

#Run the IPAddress script
. "$ScriptPath\IPAddress"
Get-IPs -IncludeVM
#Run the OSVersion script
. "$ScriptPath\OSVersion"
Get-OS | fl
#Run the DriveSpace script and pipe output to Format-Table for better readablility
#The paramter it takes is the minimum amount of space in GB that should trigger a warning
& "$ScriptPath\DriveSpace" 5 | Format-Table