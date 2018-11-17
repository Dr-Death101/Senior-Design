#Author: Alec Bonnell
function Get-IPs {
    <#
    .DESCRIPTION
    Displays the computer name and the network IP address for the host server and the VMs
    #>
    [CmdletBinding()]
    param (
    )

    Begin {}

    Process {
        #Make sure that Get-NetIPAddress is loaded
        Import-Module NetTCPIP

        #Create the output array
        $output = @()

        #Get the host's name
        $computername = (Get-WmiObject Win32_ComputerSystem -Property Name).name
        #Get the host's IP address
        $compIPAddress = (Get-NetIPAddress | ? {$_.ValidLifetime -ne [TimeSpan]::MaxValue}).IPAddress

        #Create a new array that will hold the ip info for the server
        $iptable = [ordered]@{
            Name = $computername
            IPAddress = $compIPAddress
            IsVM = $false
        }

        #Add the array to the output
        $output += (New-Object psobject -Prop $iptable)

        
        #Run script for each vm
        $vms = Get-VM
        foreach($vm in $vms){
            #Create an array for each VM
            $vmtable = [ordered]@{
                Name = $vm.Name
                IPAddress = $vm.NetworkAdapters.IPAddresses[0]
                IsVM = $true
            }

            #Add to the output
            $output += (New-Object psobject -Prop $vmtable)
        }

        #Retutn the output result
        #Write-Output -NoEnumerate $output
        return $output
    }

    End {}
}

#Get-IPs -IncludeVM