#Gets the path that the shell is currently running in
$ScriptPath = Split-Path -Path $PSCommandPath

#Run the IPAddress script
& "$ScriptPath\IPAddress"
#Run the OSVersion script
& "$ScriptPath\OSVersion"