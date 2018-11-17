function Get-DriveSpace {
    <#
    .DESCRIPTION
    Gets the list of drives on the server and on the VMs
    .PARAMETER VMNames
    List of VMs to get drive info about
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [string[]]$VMNames
    )

    Begin { }

    Process {
        $drives = [System.IO.DriveInfo]::GetDrives()

        $output = @()

        foreach ($drive in $drives) {
            $total = $drive.TotalSize / 1GB
            if ($total -eq 0) { #Skip drives with zero space
                continue
            }
            $driveTable = [ordered]@{
                Server = $env:COMPUTERNAME
                Name = $drive.Name
                Used = [math]::Round(($drive.TotalSize - $drive.AvailableFreeSpace) / 1GB, 2)
                Free = [math]::Round($drive.AvailableFreeSpace / 1GB, 2)
                Total = [math]::Round($total)
                PercentFree = [math]::Round(($drive.AvailableFreeSpace/$drive.TotalSize)*100, 2)
            }
            $output += (New-Object psobject –Prop $driveTable)
        }

        #Write-Output $output

        foreach ($vm in $VMNames) {
            
            $output += Invoke-Command -ComputerName $vm -ArgumentList $vm -ScriptBlock {
                param([string]$vmName)

                $drives = [System.IO.DriveInfo]::GetDrives()
                
                $vmOutput = @()

                foreach ($drive in $drives) {
                    $total = $drive.TotalSize / 1GB
                    if ($total -eq 0) { #Skip drives with zero space
                        continue
                    }
                    $driveTable = [ordered]@{
                        Server = $vmName
                        Name = $drive.Name
                        Used = [math]::Round(($drive.TotalSize - $drive.AvailableFreeSpace) / 1GB, 2)
                        Free = [math]::Round($drive.AvailableFreeSpace / 1GB, 2)
                        Total = [math]::Round($total, 2)
                        PercentFree = [math]::Round(($drive.AvailableFreeSpace/$drive.TotalSize)*100, 2)
                    }
                    $vmOutput += (New-Object psobject –Prop $driveTable)
                }

                return $vmOutput
            }

            #Write-Output $output
        }

        return $output | select Server, Name, Used, Free, Total, PercentFree
    }

    End { }
}

#Get-DriveSpace -VMNames @("WIN-TDB4N5JL0G1", "WIN-29RPC41COL1") | Format-Table