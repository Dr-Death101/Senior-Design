[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [int]$freeSpaceMinimum,
    [Parameter(Mandatory=$False, Position=2)]
    [string[]]$vmNames
)

$drives = [System.IO.DriveInfo]::GetDrives()

$output = @()

foreach ($drive in $drives) {
    $total = $drive.TotalSize / 1GB
    if ($total -eq 0) { #Skip drives with zero space
        continue
    }
    $driveTable = [ordered]@{
        Name = $drive.Name
        Used = ($drive.TotalSize - $drive.AvailableFreeSpace) / 1GB
        Free = $drive.AvailableFreeSpace / 1GB
        Total = $total
    }

    if ($driveTable.Free -lt $freeSpaceMinimum) {
        $driveTable["Below Min"] = $True
    } else {
        $driveTable["Below Min"] = $False
    }
    $output += (New-Object psobject –Prop $driveTable)
}

Write-Output -NoEnumerate $output

foreach ($vm in Get-VM) {
    $output = @()

    $i = 1
    foreach ($d in $vm.HardDrives) {
        $drive = Get-VHD -Path $d.Path

        $driveTable = [ordered]@{
            Name = $vm.VMName + " Drive " + $i
            Used = $drive.FileSize / 1GB
            Free = ($drive.Size - $drive.FileSize) / 1GB
            Total = $drive.Size / 1GB
        }

        if ($driveTable.Free -lt $freeSpaceMinimum) {
            $driveTable["Below Min"] = $True
        } else {
            $driveTable["Below Min"] = $False
        }
        $output += (New-Object psobject –Prop $driveTable)
        $i++
    }

    Write-Output -NoEnumerate $output
}