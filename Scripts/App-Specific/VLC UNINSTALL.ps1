<#
.SYNOPSIS
    VLC Uninstall.
.DESCRIPTION
    A script that uninstalls VLC or with the right modifications an application of your choosing, that also checks to see if the script is being ran as an Administrator, Generates logs and has it's own error code system.
.NOTES
    Name: VLC Uninstall
    Version: 7.0
    Author: Aneurin Weale - DLM
    Date Created: 28/06/2022
    Last Updated: 22/08/2022
#>

## SCRIPT START ##

## REGION LOGGING SYSTEM ##
Function LogWrite { #This function allows us to replace all 'Write-Host' commands to 'LogWrite' commands. This means instead of outputting text to the terminal, it'll output to a log file instead.
    #Function to create a log file in the current directory.
    Param ([string]$logstring)
    Add-Content "C:\DLM\uninstallVLC.log" -value "$(Get-Date -UFormat %Y%m%d-%H:%M:%S) - $($logstring)"
    #20190717-12:07:40 - Example
}
#END REGION

LogWrite -logstring "--------------------------------- START ----------------------------------"

## REGION ADMINISTRATOR CHECK ##
$user = [Security.Principal.WindowsIdentity]::GetCurrent(); #Grabs current PowerShell sessions user identity.
$Role = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) #Checks if current PowerShell session is an Admin.
If ($Role -eq $TRUE) {

    LogWrite "Required Privilages Met."

}
Else {

    LogWrite "Error: Script cannot run correctly without correct privilage escalation."

}
## END REGION ##

## REGION VARIABLES ##
$checkFilePath86 = "C:\Program Files (x86)\VideoLAN\VLC\uninstall.exe"

$checkFilePath = "C:\Program Files\VideoLAN\VLC\uninstall.exe"

$uninstallVLC86 = "C:\Program Files (x86)\VideoLAN\VLC\uninstall.exe"

$uninstallVLC = "C:\Program Files\VideoLAN\VLC\uninstall.exe"

$configManagerCycles = @(
    "{00000000-0000-0000-0000-000000000021}"
    "{00000000-0000-0000-0000-000000000022}"
    "{00000000-0000-0000-0000-000000000121}"
)

$ErrorCode = 0
## END REGION ##

## FUNCTIONS ##
Function 32BitVLC { #If VLC was detected under x86 directory, then the below will run.

    LogWrite "VLC Media Player Exists."
    LogWrite "Checking If VLC is Running..."
    If (Get-Process vlc -ErrorAction SilentlyContinue) {

        LogWrite "Closing VLC Media Player..."
        Get-Process | Where-Object { $_.Name -eq "vlc" } | Stop-Process
        LogWrite "VLC Media Player Process Closed."

    }
    LogWrite "Uninstalling VLC Media Player..."
    Start-Process -FilePath $uninstallVLC86 -ArgumentList '/S' -Wait -NoNewWindow
    If ((Test-Path -Path $checkFilePath86) -eq $TRUE) {
        LogWrite "Uninstall Failed."
        LogWrite "Error Code: 0x1a"
        $global:ErrorCode = $ErrorCode + 1
    }
    ELSEIf ((Test-Path -Path $checkFilePath86) -eq $FALSE) {
        LogWrite "VLC Media Player Uninstalled."
        LogWrite "Running Configuration Manager Cycles..."
        $configManagerCycles | foreach-object {
            Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule  $PSItem #Invoke-CIMMethod does not work.
        }
    }

}

Function 64BitVLC { #If VLC was detected under x64 directory, then the below will run.

    LogWrite "VLC Media Player Exists."
    LogWrite "Checking If VLC is Running..."
    If (Get-Process vlc -ErrorAction SilentlyContinue) {

        LogWrite "Closing VLC Media Player..."
        Get-Process | Where-Object { $_.Name -eq "vlc" } | Stop-Process
        LogWrite "VLC Media Player Process Closed."

    }
    LogWrite "Uninstalling VLC Media Player..."
    Start-Process -FilePath $uninstallVLC -ArgumentList '/S' -Wait -NoNewWindow
    If ((Test-Path -Path $checkFilePath) -eq $TRUE) {
        LogWrite "Uninstall Failed."
        LogWrite "Error Code: 0x01b"
        $global:ErrorCode = $ErrorCode + 1
    }
    ELSEIf ((Test-Path -Path $checkFilePath) -eq $FALSE) {
        LogWrite "VLC Media Player Uninstalled."
        LogWrite "Running Configuration Manager Cycles..."
        $configManagerCycles | foreach-object {
            Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule  $PSItem
        }
    }

}
## END REGION ##

## IF STATEMENTS ##
If (((Test-Path -Path $checkFilePath86) -eq $FALSE) -and ((Test-Path -Path $checkFilePath) -eq $FALSE)) { #If VLC is not installed in either location, then exit/end script.
    LogWrite "VLC Media Player Is Not Installed On The System."
    LogWrite "Exiting Script..."
    LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
    Exit
}

If ((Test-Path -Path $checkFilePath86) -eq $TRUE) { #If VLC exists in x86 directory, then execute 32BitVLC Function.
    LogWrite "Checking If VLC Media Player Is installed under 'Program Files (x86)'..."
    32BitVLC
}

If ((Test-Path -Path $checkFilePath) -eq $TRUE) { #If VLC exists in x64 directory, then execute 64BitVLC Function.
    LogWrite "Checking If VLC Media Player Is installed under 'Program Files'..."
    64BitVLC
}

switch ( $ErrorCode )
{
    0 { LogWrite "Uninistall performed with issues. Script is Exiting with Return Code 0"    } #0 = Uninistall performed with issues.
    1 { LogWrite "Failed to uninstall VLC from one of the locations. Script Exited with Error Code: 0x1"      } #0x1 = Uninstall Failed to uninstall VLC from one of the locations.
    2 { LogWrite "Uninstall Failed to uninstall VLC from both locations. Script Exited with Error Code: 0x2"      } #0x2 = Uninstall Failed to uninstall VLC from both locations.
}
## END REGION ##
Clear-Variable -name ErrorCode

LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
## SCRIPT END ##