#Authors: Sandino Dos Santos, Alec Bonnell
function Get-Time{

    <#
    .DESCRIPTION
    Displays the computer name and time and timezone for the host server and compare the VM to the host server
    Display format ComputerName   DayofWeek, Month day, Year Hour:minute:second 
    .PARAMETER VMNames
    An array of strings for the VM computer names
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [string[]]$VMNames
    )

    Begin {
     
    }

    Process 
    {
        #This will store the dates in an array
        $dates = @()

        #Get the date/time info for the host server
        $hostDate = Get-Date

        #This is the format of the table
        $dateList = [PSCustomObject][ordered]@{
            ComputerName = $env:COMPUTERNAME
            DateString = $hostDate.DateTime
            DayOfWeek = [string]$hostDate.DayOfWeek
            Day = $hostDate.Day
            Month = $hostDate.Month
            Year = $hostDate.Year
            Hour = $hostDate.Hour
            Minute = $hostDate.Minute
            Second = $hostDate.Second
            UnixTime = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds
            StandardTimeZone = ([System.TimeZone]::CurrentTimeZone).StandardName
            DaylightTimeZone = ([System.TimeZone]::CurrentTimeZone).DaylightName
        }

        #Add the list to the dates array
        $dates += $dateList

        #Loop through the VMNames
        ForEach($vm in $VMNames) {

            #Runs the command on the VM to get the time information
            $vmReturn = Invoke-Command -ComputerName $vm -ScriptBlock {

                #Get the date/time info from the VM
                $vmDate = Get-Date

                #Get the information
                $dateList = [PSCustomObject][ordered]@{
                    ComputerName = $env:COMPUTERNAME
                    DateString = $vmDate.DateTime
                    DayOfWeek = [string]$vmDate.DayOfWeek
                    Day = $vmDate.Day
                    Month = $vmDate.Month
                    Year = $vmDate.Year
                    Hour = $vmDate.Hour
                    Minute = $vmDate.Minute
                    Second = $vmDate.Second
                    UnixTime = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds
                    StandardTimeZone = ([System.TimeZone]::CurrentTimeZone).StandardName
                    DaylightTimeZone = ([System.TimeZone]::CurrentTimeZone).DaylightName
                }

                #return the information to the host server
                return $dateList
            }

            #Adds the VM info object into the results array
            $dates += $vmReturn

        }

        #return all of the info
        return $dates | select ComputerName, DateString, DayOfWeek, Day, Month, Year, Hour, Minute, Second, UnixTime, StandardTimeZone, DaylightTimeZone
      }
    
    End {}
}