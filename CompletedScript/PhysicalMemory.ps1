Function Test-MemoryUsage {
[cmdletbinding()]
Param()
 
$os = Get-Ciminstance Win32_OperatingSystem -ComputerName $env:COMPUTERNAME
$pctFree = [math]::Round(($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100,2)
 
if ($pctFree -ge 50) {
$Status = "Good"
}
elseif ($pctFree -ge 20 ) {
$Status = "Warning"
}
else {
$Status = "Critical"
}
 
$os | Select @{Name = "Computer Name"; Expression = {$os.PSComputerName}},
@{Name = "Status";Expression = {$Status}},
@{Name = "PctFree"; Expression = {$pctFree}},
@{Name = "FreeGB";Expression = {[math]::Round($_.FreePhysicalMemory/1mb,2)}},
@{Name = "TotalGB";Expression = {[int]($_.TotalVisibleMemorySize/1mb)}}


#This will get the VM's that are currently running
<#(Get-VM -ComputerName $env:COMPUTERNAME).where({$_.state -eq 'running'}) |

Select Computername,VMName,
#@{Name = "Status";Expression = {$}},
@{Name="TotalMB";Expression={[int]($_.MemoryAssigned/1mb)}},
@{Name="MemDemandMB";Expression={$_.MemoryDemand/1mb}},
@{Name="PctUsed";Expression={[math]::Round(($_.MemoryDemand/$_.memoryAssigned)*100,2)}},
MemoryStatus | Sort MemoryStatus,PctMemUsed#> 
 
}






<#function Get-MemoryUsage {
    [CmdletBinding()]
    Param(
    )

    BEGIN{}

    PROCESS{
        $ComputerName=$ENV:ComputerName

        if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
            $ComputerSystem = Get-WmiObject -ComputerName $ComputerName -Class Win32_operatingsystem -Property CSName, TotalVisibleMemorySize, FreePhysicalMemory
            $MachineName = $ComputerSystem.CSName
            $FreePhysicalMemory = ($ComputerSystem.FreePhysicalMemory) / (1mb)
            $TotalVisibleMemorySize = ($ComputerSystem.TotalVisibleMemorySize) / (1mb)
            $TotalVisibleMemorySizeR = “{0:N2}” -f $TotalVisibleMemorySize
            $TotalFreeMemPerc = ($FreePhysicalMemory/$TotalVisibleMemorySize)*100
            $TotalFreeMemPercR = “{0:N2}” -f $TotalFreeMemPerc

            # print the machine details:
            “Name: $MachineName”
            “RAM: $TotalVisibleMemorySizeR GB”
            “Free Physical Memory: $TotalFreeMemPercR %”

        }
    }

    END{}

}#>
