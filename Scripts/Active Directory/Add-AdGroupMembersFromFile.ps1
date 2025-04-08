<#
    .SYNOPSIS
        A PowerShell script that adds members to an Active Directory Security Group from a list containing only users or only computers. Mixed object types are not supported.

    .DESCRIPTION
        This PowerShell script is designed to streamline the process of managing Active Directory security group memberships.
        It reads a list of objects, either users or computers, from an input file (text file) and adds them to a specified AD security group.
        The script ensures object type consistency by requiring that the input list contains only users or only computers.
        It validates the input, checks for existing group membership to avoid duplicates, and logs the results for auditing or troubleshooting purposes.

    .PARAMETER ADMembers
        Specifies the complete path, including the file name, to the .TXT input file.

    .PARAMETER ADSecurityGroup
        Specifies the name of the Active Directory Security Group.

    .PARAMETER Users
        Specifies whether the objects being added to the Active Directory Security Group are Users.

    .PARAMETER Computers
        Specifies whether the objects being added to the Active Directory Security Group are Computers.

    .EXAMPLE
        PS> .\Add-AdGroupMembersFromFile.ps1 -ADMembers C:\Computers.txt -ADSecurityGroup Patching-Phase1 -Computers

    .EXAMPLE
        PS> .\Add-AdGroupMembersFromFile.ps1 -ADMembers C:\Computers.txt -ADSecurityGroup Patching-Phase1 -Computers -Verbose

    .NOTES
        Name: Add-AdGroupMembersFromFile
        Version: 1.0
        Author: Aneurin Weale - VAR
        Date Created: 08/04/2025
        Last Updated: 08/04/2025
        URL: 
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$True)] [String]$ADMembers,
    [Parameter(Mandatory=$True)] [String]$ADSecurityGroup,
    [Parameter(Mandatory=$False)] [switch]$Users,
    [Parameter(Mandatory=$False)] [switch]$Computers
)

$ErrorActionPreference = "Continue"

$MemberList = Get-Content $ADMembers

If ($Users -and -not $Computers) {
    foreach ($Member in $MemberList) {
        try {
            Add-ADGroupMember -Identity $ADSecurityGroup -Members (Get-ADUser $Member)
            Write-Verbose -Message "Added $Member to AD Security Group: $ADSecurityGroup"
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "$Member not found in Active Directory. User was not added to the AD Security group."
        }
    }
}

ElseIf ($Computers -and -not $Users) {
    foreach ($Member in $MemberList) {
        try {
            Add-ADGroupMember -Identity $ADSecurityGroup -Members (Get-ADComputer $Member)
            Write-Verbose -Message "Added $Member to AD Security Group: $ADSecurityGroup"
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "$Member not found in Active Directory. Computer was not added to the AD Security group."
        }
    }
}

ElseIf ($Users -and $Computers) {
    Write-Warning "Only one of the parameters -User or -Computer can be specified at a time."
    Write-Warning "Exiting Script..."
    Exit
}

Else {
    Write-Warning "One of the parameters -User or -Computer must be specified."
    Write-Warning "Exiting Script..."
    Exit
}