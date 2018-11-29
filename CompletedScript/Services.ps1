function Get-Services {
   <#
    .DESCRIPTION
    Gets a list of the names, states, and start modes of all services on the local server and VMs
    .PARAMETER VMNames
    A list of VMs to get the services from
    #>

    [CmdletBinding()]
    param (
        #The list of VMs to get the services from
        [parameter(Mandatory=$true)]
        [string[]]$VMNames,
        [parameter(Mandatory=$true)]
        [string[]]$Filter
    )

    Begin { }

    Process {
        $name = $env:COMPUTERNAME
        <#| Where-Object {$_.state -eq 'Stopped' -and $_.StartMode -eq 'Auto'}#> 
        Get-WmiObject -Class Win32_Service | Select-Object @{ l="Server";e={$name} },Name,State,StartMode,DisplayName,@{ l="Ignore";e={$Filter.Contains($_.Name)} } | Write-Output


        $VMNames | ForEach-Object {
            Invoke-Command -ComputerName $_ -ArgumentList $_,$Filter -ScriptBlock {
                Param(
                    [string]$VMName,
                    [string[]]$Filter
                )
                Get-WmiObject -class Win32_Service | Select-Object @{ l="Server";e={$VMName} },Name,State,StartMode,DisplayName,@{ l="Ignore";e={$Filter.Contains($_.Name)} }
            }
        } | Write-Output
        
    }

    End { }
}

#Get-Services -VMNames @("WIN-TDB4N5JL0G1", "WIN-29RPC41COL1")