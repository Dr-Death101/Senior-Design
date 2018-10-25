function Get-Processes {
    [CmdletBinding()]
    Param(
    )

    BEGIN{}

    PROCESS{
        $ProcArray = @()
        $Processes = get-process | Group-Object -Property ProcessName
        foreach($Process in $Processes)
        {
            $prop = @(
                    @{n='Count';e={$Process.Count}}
                    @{n='Name';e={$Process.Name}}
                    @{n='Memory';e={($Process.Group|Measure WorkingSet -Sum).Sum}}
                    )
            $ProcArray += "" | select $prop  
        }
        $ProcArray | sort -Descending Memory | select Count,Name,@{n='Memory usage(Total)';e={"$(($_.Memory).ToString('N0'))Kb"}}
    }

    END{}
}