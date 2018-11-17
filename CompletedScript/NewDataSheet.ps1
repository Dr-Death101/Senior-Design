#Author Corey S. Pollock, Alec Bonnell
#Datasheet.ps1

function Get-DataSheet{
    [CmdletBinding()]
    param (
    )
	
    Begin{}

	Process{
            $path = "C:\Project6\CompletedScript"
            #Include Scripts
            . "$path\DriveSpace.ps1"
            . "$path\IPAddress.ps1"
            . "$path\OSVersion.ps1"
            . "$path\PhysicalMemory.ps1"
            . "$path\Services.ps1"
            . "$path\ShowProcesses.ps1"
            . "$path\VersionData.ps1"
            . "$path\VMNames.ps1"
            #. "$path\DataSheet.ps1"
            . "$path\DateTime.ps1"

            $vmnames = Get-Content C:\Project6\OtherServers.txt
            $serviceFilter = Get-Content C:\Project6\ServiceFilter.txt
            
            $frag1 = Get-VersionData -BaseLinePath "C:\Project6\baseline.txt" | convertto-json -Compress
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

            $date = Get-Date | select DateTime | convertto-json -Compress
            
            $allJSON = "var reportTime = $date`nvar versionData = $frag1;`nvar driveData = $frag2;`nvar ipData = $frag3;`nvar osData = $frag4;`nvar memoryData = $frag5;`nvar timeData = $frag6;`nvar processData = $frag7;`nvar servicesData = $frag8;"
            $allJSON | Out-File "C:\Project6\CompletedScript\Data Sheet\js\allJSON.js"
            
            <#
            $head = @'

            <style>

            body { background-color:#dddddd;

                font-family:Tahoma;

                font-size:12pt; }

            td, th { border:1px solid black;

                    border-collapse:collapse; }

            th { color:white;

                background-color:black; }

            table, tr, td, th { padding: 2px; margin: 0px }

            table { margin-left:50px; }

            </style>

'@#>
            #Formatting

            #convertto-html -head $head -PostContent $frag1,$frag2,$frag3,$frag4,$frag5,$frag6,$frag7,$frag8 -PreContent '<h1>Data Collection Sheet</h1>' | out-file C:\Project6\DataSheet.html
            #Creating the main html page comprised of the fragments.

            #Invoke-Item "C:\Project6\DataSheet.html"
            #Invoke-Item "C:\Project6\TestingScript\web test\index.html"
            #Open the document.
    }
    End{}
}

#NOTES:
#-As LIST' is for verticle view. Try using that on some fragments to see if it fits better.
#may need to add '-computername' to retrieve the correct information from server.
#convertto-html -CssUri "documentName.css" will allow you to convert the information to html page that is influenced by css markup. Usefull for implemementing the red highlighting.