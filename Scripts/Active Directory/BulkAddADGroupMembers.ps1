<#
    .SYNOPSIS
        Adds a list of devices to an AD Security Group.

    .DESCRIPTION
        Adds a list of devices to an AD Security Group.

    .PARAMETER ADComputers
        Specifies the path to the TXT-based input file.

    .PARAMETER SecurityGroupName
        Specifies the name of the AD Security Group.

    .EXAMPLE
        PS> .\BulkAddADGroupMembers.ps1 -ADComputers C:\DLM\Computers.txt -SecurityGroupName DLM-Patching-Phase1

    .EXAMPLE
        PS> .\BulkAddADGroupMembers.ps1 -ADComputers C:\DLM\Computers.txt -SecurityGroupName DLM-Patching-Phase1 -Verbose

    .NOTES
        Name: BulkAddADGroupMembers
        Version: 1.0
        Author: Aneurin Weale - VAR
        Date Created: 03/06/2024
        Last Updated: 03/06/2024
        URL: 
#>


#ADD-ADGroupMember -identity DLM-GPO-Win10-PowerPolicy-CommunityNurses -members <SAMAccount name $>

Param (
    [Parameter(Mandatory=$True)] [String]$ADComputers,
    [Parameter(Mandatory=$True)] [String]$SecurityGroupName
)

$ErrorActionPreference = "Continue"
$VerbosePreference = "Continue"

#$SecurityGroupname = "W10_APPD_7-Zip_24.05_x64"

#$ComputerList = Get-Content "C:\DLM\devices.txt"
$ComputerList = Get-Content $ADComputers

foreach ($Computer in $ComputerList)
    {
        try {
            Add-AdGroupmember -Identity $SecurityGroupname  -Members (Get-ADComputer $computer)
            Write-Verbose -Message "$Computer Added to AD Security Group: $SecurityGroupName" -Verbose
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "$Computer Not Found in AD. Asset was not Added to AD Group."
        }
    }