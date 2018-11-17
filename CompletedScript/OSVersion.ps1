#Author: Alec Bonnell
function Get-OS {
    <#
    .DESCRIPTION
    Gets the System information and displays the computer name, the name of the OS, the OS architecture, the OS version, and the OS build number for the server and VMs
    .PARAMETER VMNames
    An array of strings for the VM computer names
    #>
    [CmdletBinding()]
    param (
        #VM computer names parameter
        [Parameter(Mandatory=$True)]
        [string[]]$VMNames
    )

    Begin {}

    Process {
        #The results array that will store the OS information as PS objects
        $results = @()
        
        #Gets the host info
        $osInfo = Get-WmiObject -Class Win32_OperatingSystem

        #Stores the relevant host info into a custom object
        $osList = [PSCustomObject]@{
            Name = $osInfo.PSComputerName
            OSName = $osInfo.Caption
            OSArchitecture = $osInfo.OSArchitecture
            OSVersion = $osInfo.Version
            OSBuildNumber = $osInfo.BuildNumber
        }

        #Adds the host info object into the results array
        $results += $osList
        
        #Loop through the VMNames
        ForEach($vm in $VMNames) {
            #Runs the command on the VM to get the system information
            $vmReturn = Invoke-Command -ComputerName $vm -ScriptBlock {
                $vmWmi = Get-WmiObject -Class Win32_OperatingSystem
                return $vmWmi
            }

            #Stores the relevant VM info into a custom object
            $vmList = [PSCustomObject]@{
                Name = $vmReturn.PSComputerName
                OSName = $vmReturn.Caption
                OSArchitecture = $vmReturn.OSArchitecture
                OSVersion = $vmReturn.Version
                OSBuildNumber = $vmReturn.BuildNumber
            }

            #Adds the VM info object into the results array
            $results += $vmList
        }

        #Return the results array of objects
        return $results

    }

    End {}
}

#How to run the function
#Get-OS -VMNames @("WIN-TDB4N5JL0G1", "WIN-29RPC41COL1")