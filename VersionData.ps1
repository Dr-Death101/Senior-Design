#Author Corey S. Pollock
#Version Data script - pulls version data from programs on system and compares the data to a baseline file, outputs to console.

function Get-VersionData{

    [CmdletBinding()]
    param (
            
            )
	
    Begin{}

	Process{
		gwmi win32_product | Format-Table name, version* | out-file C:\Project6\data.txt
		#Pulls a composite key of product info (name version, ID#) on system
		#Converts to table in shell but can be modified to convert to html file or simply 'out-file' to any other file format
		#UPDATE: converts to a table that is exported to a text file

		Compare-Object -ReferenceObject (Get-Content C:\Project6\baseline.txt) -DifferenceObject (Get-Content C:\Project6\data.txt)
		# Compares the two text files for any dif and returns any found dif in the 'SideIndicator' 
	}

	End{}
}

#Get-VersionData