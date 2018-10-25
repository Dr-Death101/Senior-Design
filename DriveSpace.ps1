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
                Used = ($drive.TotalSize - $drive.AvailableFreeSpace) / 1GB
                Free = $drive.AvailableFreeSpace / 1GB
                Total = $total
            }
            $output += (New-Object psobject –Prop $driveTable)
        }

        Write-Output -NoEnumerate $output

        foreach ($vm in $VMNames) {
            
            $output = Invoke-Command -ComputerName $vm -ArgumentList $vm -ScriptBlock {
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
                        Used = ($drive.TotalSize - $drive.AvailableFreeSpace) / 1GB
                        Free = $drive.AvailableFreeSpace / 1GB
                        Total = $total
                    }
                    $vmOutput += (New-Object psobject –Prop $driveTable)
                }

                $vmOutput
            }

            Write-Output -NoEnumerate $output
        }
    }

    End { }
}

#Get-DriveSpace -VMNames @("WIN-TDB4N5JL0G1", "WIN-29RPC41COL1") | Format-Table