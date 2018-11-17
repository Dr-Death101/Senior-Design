Function Test-VMMemory {
[cmdletbinding()]
Param()

#This will get the VM's that are currently running
(Get-VM -ComputerName $env:COMPUTERNAME).where({$_.state -eq 'running'}) |

Select Computername,VMName,
#@{Name = "Status";Expression = {$}},
@{Name="TotalMB";Expression={[int]($_.MemoryAssigned/1mb)}},
@{Name="MemDemandMB";Expression={$_.MemoryDemand/1mb}},
@{Name="PctUsed";Expression={[math]::Round(($_.MemoryDemand/$_.memoryAssigned)*100,2)}},
MemoryStatus | Sort MemoryStatus,PctMemUsed

}