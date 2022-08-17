<#
.SYNOPSIS
    VLC Uninstall.
.DESCRIPTION
    A script that uninstalls VLC or with the right modifications an application of your choosing, that also checks to see if the script is being ran as an Administrator, Generates logs and has it's own error code system.
.NOTES
    Name: VLC Uninstall
    Version: 5.0
    Author: Aneurin Weale - DLM
    Date Created (This incarnation, anyway): 28/06/2022
    Last Updated: 16/08/2022
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

## REGION ADMINISTRATOR CHECK ##
$user = [Security.Principal.WindowsIdentity]::GetCurrent(); #Grabs current PowerShell sessions user identity.
$Role = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) #Checks if current PowerShell session is an Admin.
If ($Role -eq $TRUE) {

    LogWrite "Required Privilages Met."

}
ElseIf ($Role -eq $FALSE) {

    LogWrite "Error: Script cannot run correctly without correct privilage escalation."

}
## END REGION ##

## REGION VARIABLES ##
$checkFilePath86 = "C:\Program Files (x86)\VideoLAN\VLC\uninstall.exe"

$checkFilePath = "C:\Program Files\VideoLAN\VLC\uninstall.exe"

$uninstallVLC86 = "C:\Program Files (x86)\VideoLAN\VLC\uninstall.exe"

$uninstallVLC = "C:\Program Files\VideoLAN\VLC\uninstall.exe"

$ErrorCode = 0
## END REGION ##

## FUNCTIONS ##
Function 32BitVLC { #If VLC was detected under x86 directory, then the below will run.

    LogWrite "VLC Media Player Exists."
    LogWrite "Checking If VLC is Running..."
    If (Get-Process vlc -ErrorAction SilentlyContinue) {

        LogWrite "Closing VLC Media Player..."
        Get-Process | Where-Object { $_.Name -eq "vlc" } | Select-Object -First 1 | Stop-Process
        LogWrite "VLC Media Player Process Closed."

    }
    LogWrite "Uninstalling VLC Media Player..."
    Start-Process -FilePath $uninstallVLC86 -ArgumentList '/S' -Wait -NoNewWindow
    If ((Test-Path -Path $checkFilePath86) -eq $TRUE) {
        LogWrite "Uninstall Failed."
        LogWrite "Error Code: 0x1a"
        $ErrorCode = $ErrorCode + 1
    }
    If ((Test-Path -Path $checkFilePath86) -eq $FALSE) {
        LogWrite "VLC Media Player Uninstalled."
    }

}

Function 64BitVLC { #If VLC was detected under x64 directory, then the below will run.

    LogWrite "VLC Media Player Exists."
    LogWrite "Checking If VLC is Running..."
    If (Get-Process vlc -ErrorAction SilentlyContinue) {

        LogWrite "Closing VLC Media Player..."
        Get-Process | Where-Object { $_.Name -eq "vlc" } | Select-Object -First 1 | Stop-Process
        LogWrite "VLC Media Player Process Closed."

    }
    LogWrite "Uninstalling VLC Media Player..."
    Start-Process -FilePath $uninstallVLC -ArgumentList '/S' -Wait -NoNewWindow
    If ((Test-Path -Path $checkFilePath) -eq $TRUE) {
        LogWrite "Uninstall Failed."
        LogWrite "Error Code: 0x01b"
        $ErrorCode = $ErrorCode + 1
    }
    If ((Test-Path -Path $checkFilePath) -eq $FALSE) {
        LogWrite "VLC Media Player Uninstalled."
    }

}
## END REGION ##

## IF STATEMENTS ##
If (((Test-Path -Path $checkFilePath86) -eq $FALSE) -and ((Test-Path -Path $checkFilePath) -eq $FALSE)) { #If VLC is not installed in either location, then exit/end script.
    LogWrite "VLC Media Player Is Not Installed On The System."
    LogWrite "Exiting Script..."
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

If ($ErrorCode -eq 0) {

    LogWrite "Script is Exiting with Return Code 0" #0 = Uninistall performed with issues.

}

If ($ErrorCode -eq 1) {

    LogWrite "Script Exited with Error Code: 0x1" #0x1 = Uninstall Failed to uninstall VLC from one of the locations.

}

If ($ErrorCode -eq 2) {

    LogWrite "Script Exited with Error Code: 0x2" #0x2 = Uninstall Failed to uninstall VLC from both locations.

}
## END REGION ##
Clear-Variable -name ErrorCode

## SCRIPT END ##