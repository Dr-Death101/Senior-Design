#Gets all IP addresses that do not have the maximum lifespan value
function Get-IP {
    Get-NetIPAddress | Where-Object {$_.ValidLifetime -Lt ([TimeSpan]::MaxValue)} | Select-Object IPAddress
}

Get-IP