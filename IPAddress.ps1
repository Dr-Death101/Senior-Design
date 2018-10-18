function Get-IPs {
    <#
    .DESCRIPTION
    Displays the computer name and the network IP address which does not have the maximum lifetime value
    .PARAMETER IncludeVM
    Optional Parameter which displays all of the VM IP addresses with the host's IP address
    #>
    [CmdletBinding()]
    param (
        #This parameter allows the use to include the vm ip info if it is set
        [switch]$IncludeVM
    )

    Begin {}

    Process {
        #Get the host's name
        $computername = (Get-WmiObject Win32_ComputerSystem -Property Name).name
        #Get the host's IP address
        $compIPAddress = (Get-NetIPAddress | ? {$_.ValidLifetime -ne [TimeSpan]::MaxValue}).IPAddress

        #Create a new object that will hold the ip info
        $ipaddresses = New-Object psobject
        $ipaddresses | Add-Member noteproperty ComputerName $computername
        $ipaddresses | Add-Member noteproperty IPAddress $compIPAddress

        #print ip info
        write-host ($ipaddresses | Format-Table | Out-String)

        #get and print vm ip info
        if($IncludeVM) {
            Get-VM | select -ExpandProperty networkadapters | select VMName, IPAddresses
        }
    }

    End {}
}