function Get-VMComputerNames {
    <#
    .DESCRIPTION
    Gets a list of the computer names of the virtual machines using a reverse DNS lookup
    #>
    [CmdletBinding()]
    param (
    )

    Begin {}

    Process {
        
        #Create the array to return
        $names = @()

        #Get the IP addresses of the VMs
        $vmips = Get-VM | select -ExpandProperty NetworkAdapters | select IPAddresses

        #Run script for all VMs
        $vmips | ForEach-Object {
            #Gets the IPv4 IP address
            $vmip4 = $_.IPAddresses[0]
            #Does a reverse DNS lookup to find the computername based on the IP address
            $names += [System.Net.Dns]::GetHostByAddress("$vmip4").Hostname
        }

        #Return the array of computer names
        return $names

    }
    
    END {}

}

#Get-VMComputerNames | Write-Host