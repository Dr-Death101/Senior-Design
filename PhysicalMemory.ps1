function Get-MemoryUsage {
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

}