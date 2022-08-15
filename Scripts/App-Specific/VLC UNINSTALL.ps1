## VLC UNINSTALL ##

#Create own log system and find VLC process ID and kill it

## SCRIPT START ##

#Start-Transcript -Path C:\DLM\uninstallVLC.log -Append

## REGION LOGGING SYSTEM ##
Function LogWrite {
    #Function to create a log file in the current directory
    Param ([string]$logstring)
    Add-Content "C:\DLM\uninstallVLC.log" -value "$(Get-Date -UFormat %Y%m%d-%H:%M:%S) - $($logstring)"
    #20190717-12:07:40 - Example
}
#END REGION

## REGION ADMINISTRATOR CHECK ##
$user = [Security.Principal.WindowsIdentity]::GetCurrent();
$Role = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
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

#$Test = "C:\DLM\test.txt"

$uninstallVLC86 = "C:\Program Files (x86)\VideoLAN\VLC\uninstall.exe"

$uninstallVLC = "C:\Program Files\VideoLAN\VLC\uninstall.exe"

#$VLCUninstall = "C:\Users\aneurin.weale\Downloads\vlc-3.0.17.4-win32.exe"

#$VLCUninstall = "C:\WINDOWS\system32\Notepad.exe"

$ErrorCode = 0
## END REGION ##

## FUNCTIONS ##
Function 32BitVLC {

    LogWrite "VLC Media Player Exists."
    LogWrite "Checking If VLC is Running..."
    If (Get-Process vlc -ErrorAction SilentlyContinue) {

        LogWrite "Closing VLC Media Player..."
        Get-Process | Where-Object { $_.Name -eq "vlc" } | Select-Object -First 1 | Stop-Process
        LogWrite "VLC Media Player Process Closed."

    }
    LogWrite "Uninstalling VLC Media Player..."
    #Start-Sleep -s 2
    Start-Process -FilePath $uninstallVLC86 -ArgumentList '/S' -Wait -NoNewWindow
    #Start-Sleep -s 10
    If ((Test-Path -Path $checkFilePath86) -eq $TRUE) {
        LogWrite "Uninstall Failed."
        LogWrite "Error Code: 0x1a"
        $ErrorCode = $ErrorCode + 1
        Start-Sleep -s 1
    }
    If ((Test-Path -Path $checkFilePath86) -eq $FALSE) {
        LogWrite "VLC Media Player Uninstalled."
        Start-Sleep -s 1
    }
    #Start-Process -FilePath $VLCUninstall
    Start-Sleep -s 1
    #LogWrite "VLC Media Player Uninstalled."
    #LogWrite "Exiting Script..."
    #Start-Process -FilePath $VLCUninstall -ArgumentList '/L=1033 /S'

}

Function 64BitVLC {

    LogWrite "VLC Media Player Exists."
    LogWrite "Checking If VLC is Running..."
    If (Get-Process vlc -ErrorAction SilentlyContinue) {

        LogWrite "Closing VLC Media Player..."
        Get-Process | Where-Object { $_.Name -eq "vlc" } | Select-Object -First 1 | Stop-Process
        LogWrite "VLC Media Player Process Closed."

    }
    LogWrite "Uninstalling VLC Media Player..."
    Start-Sleep -s 2
    Start-Process -FilePath $uninstallVLC -ArgumentList '/S' -Wait -NoNewWindow
    Start-Sleep -s 10
    If ((Test-Path -Path $checkFilePath) -eq $TRUE) {
        LogWrite "Uninstall Failed."
        LogWrite "Error Code: 0x01b"
        $ErrorCode = $ErrorCode + 1
        Start-Sleep -s 1
    }
    If ((Test-Path -Path $checkFilePath) -eq $FALSE) {
        LogWrite "VLC Media Player Uninstalled."
        Start-Sleep -s 1
    }
    #Start-Process -FilePath $uninstallVLC
    Start-Sleep -s 1
    #LogWrite "VLC Media Player Uninstalled."
    #LogWrite "Exiting Script..."
    #Start-Process -FilePath $VLCUninstall -ArgumentList '/L=1033 /S'

}
## END REGION ##

## IF STATEMENTS ##
If (((Test-Path -Path $checkFilePath86) -eq $FALSE) -and ((Test-Path -Path $checkFilePath) -eq $FALSE)) {
    LogWrite "VLC Media Player Is Not Installed On The System."
    LogWrite "Exiting Script..."
    Exit
}

If ((Test-Path -Path $checkFilePath86) -eq $TRUE) {
    LogWrite "Checking If VLC Media Player Is installed under 'Program Files (x86)'..."
    Start-Sleep -s 1
    32BitVLC
}

If ((Test-Path -Path $checkFilePath) -eq $TRUE) {
    LogWrite "Checking If VLC Media Player Is installed under 'Program Files'..."
    Start-Sleep -s 1
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
#$ErrorCode = 0

#Stop-Transcript

## SCRIPT END ##