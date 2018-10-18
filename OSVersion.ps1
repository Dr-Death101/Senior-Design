function Get-OS {
    <#
    .DESCRIPTION
    Gets the System information and displays the computer name, the name of the OS, the OS architecture, the OS version, and the OS build number
    #>
    [CmdletBinding()]
    param (
        #none
    )

    Begin {}

    Process {
        Get-WmiObject -Class Win32_OperatingSystem | Select-Object PSComputerName, Caption, OSArchitecture, Version, BuildNumber
    }

    End {}
}