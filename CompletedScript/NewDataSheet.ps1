#Author Corey S. Pollock, Alec Bonnell
#Datasheet.ps1

function Get-DataSheet{
    [CmdletBinding()]
    param (
    )
	
    Begin{}

	Process{
            #Include Scripts
            . "$PSScriptRoot\DriveSpace.ps1"
            . "$PSScriptRoot\IPAddress.ps1"
            . "$PSScriptRoot\OSVersion.ps1"
            . "$PSScriptRoot\PhysicalMemory.ps1"
            . "$PSScriptRoot\Services.ps1"
            . "$PSScriptRoot\ShowProcesses.ps1"
            . "$PSScriptRoot\VersionData.ps1"
            . "$PSScriptRoot\DateTime.ps1"

            $vmnames = Get-Content "$PSScriptRoot\..\OtherServers.txt"
            $serviceFilter = Get-Content "$PSScriptRoot\..\ServiceFilter.txt"

            
            $frag1 = Get-VersionData -BaseLinePath "$PSScriptRoot\..\baseline.txt" | convertto-json -Compress
            #Each cmdlet will return information to a table called a "fragement" that will be conjoined into a single html file later.
            #'Out-String is used here to resolve any potentially strange information created with 'convertto-html' to regular strings so there are no pipelining errors later.

            $frag2 = Get-DriveSpace -VMNames $vmnames | convertto-json -Compress

            $frag3 = Get-IPs | convertto-json -Compress

            $frag4 = Get-OS -VMNames $vmnames | convertto-json -Compress

            $frag5 = Test-MemoryUsage | convertto-json -Compress

            $frag6 = Get-Time -VMNames $vmnames | convertto-json -Compress

            $frag7 = Get-Processes | convertto-json -Compress

            $frag8 = Get-Services -VMNames $vmnames -Filter $serviceFilter | select * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName| convertto-json -Compress

            if($frag5[0] -ne "[") {
                $frag5 = "[" + $frag5 + "]"
            }
			
			$time = Get-Date

            $fileName = "$($time.Year)$($time.Month.ToString("D2"))$($time.Day.ToString("D2"))T$($time.Hour.ToString("D2"))$($time.Minute.ToString("D2"))$($time.Second.ToString("D2"))"

            $date = @{ "DateTime"=$time.DateTime } | convertto-json -Compress
            
            $allJSON = "var reportTime = $date`nvar versionData = $frag1;`nvar driveData = $frag2;`nvar ipData = $frag3;`nvar osData = $frag4;`nvar memoryData = $frag5;`nvar timeData = $frag6;`nvar processData = $frag7;`nvar servicesData = $frag8;"
            $allJSON | Out-File "$PSScriptRoot\Data Sheet\reports\$fileName.js"
			
			return $fileName
    }
    End{}
}

