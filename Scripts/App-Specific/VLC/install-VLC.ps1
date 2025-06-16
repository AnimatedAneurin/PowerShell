<#
    .SYNOPSIS
        Patch VLC via SCCM Application Package.

    .DESCRIPTION
        This is to be used as an Install Script within your Application Package to install VLC.
        DO NOT ENABLE SUPERCEDENCE WITHIN YOUR APPLICATION PACKAGE.

    .NOTES
        Name: Install-VLC
        Version: 1.0
        Author: Aneurin Weale - VAR
        Date Created: 16/06/2025
        Last Updated: 16/06/2025
        URL: 
#>

#==========================================================================#
# FUNCTIONS                                                                #
#==========================================================================#
function New-LogDirectory {
    if (-not($logDirectoryExist)) {
        New-Item -Path $logDirectory -ItemType Directory
    }
}
function Install-VLC {
    param(
        [string]$Architecture
    )
    # If VLC is NOT installed, then install VLC and exit with install exit code.
    if ($Architecture -eq "Neither") {
        $vlcInstall = Start-Process msiexec -ArgumentList '/i "vlc-3.0.20-win64.msi"', "/quiet", "/norestart", '/log "C:\DLM\VLC\Install.log"' -PassThru; Wait-Process $vlcInstall.Id -ErrorAction SilentlyContinue
        Exit $vlcInstall.ExitCode
    }
    # If VLC is installed, then...
    # Create variables
    $registryVLC64 = ""
    $registryVLC32 = ""
    # Check if VLC is running
    $vlcProcess = Get-Process -Name "*vlc*" -ErrorAction SilentlyContinue
    # If VLC is running, then...
    if ($vlcProcess) {
        # Terminate VLC Process
        Write-Output "VLC is running. Attempting to terminate it..."
        $terminateVLC = Stop-Process -Name "*vlc*" -Force -PassThru; Wait-Process $terminateVLC.Id -ErrorAction SilentlyContinue
        # Confirm VLC has been terminated
        $vlcProcess = Get-Process -Name "*vlc*" -ErrorAction SilentlyContinue
        # If VLC has been terminated...
        if ($vlcProcess -eq $null) {
            Write-Output "VLC has been terminated."
            # Uninstall VLC based on Architecture
            if (($Architecture -eq "x64") -or ($Architecture -eq "Both")) {
                $argumentsUninstall = @("/x", $guid64, "/Quiet", "/Norestart", '/log "C:\DLM\VLC\Uninstall.log"')
                $vlcUninstall = Start-Process msiexec -ArgumentList $argumentsUninstall -PassThru; Wait-Process $vlcUninstall.Id -ErrorAction SilentlyContinue
                $registryVLC64 = Get-ItemProperty $registry64 | Where-Object { $_.DisplayName -like "*VLC*" }
            }
            if (($Architecture -eq "x32") -or ($Architecture -eq "Both")) {
                $argumentsUninstall = @("/x", $guid32, "/Quiet", "/Norestart", '/log "C:\DLM\VLC\Uninstall.log"')
                $vlcUninstall = Start-Process msiexec -ArgumentList $argumentsUninstall -PassThru; Wait-Process $vlcUninstall.Id -ErrorAction SilentlyContinue
                $registryVLC32 = Get-ItemProperty $registry32 | Where-Object { $_.DisplayName -like "*VLC*" }
            }
            # Install VLC
            if (!($registryVLC64) -and (!($registryVLC32))) {
                $vlcInstall = Start-Process msiexec -ArgumentList '/i "vlc-3.0.20-win64.msi"', "/quiet", "/norestart", '/log "C:\DLM\VLC\Install.log"' -PassThru; Wait-Process $vlcInstall.Id -ErrorAction SilentlyContinue
                Exit $vlcInstall.ExitCode
            } else {
                Exit 1
            }
        # If VLC failed to terminate...
        } else {
            Exit 1
        }
    # If VLC is NOT running then...
    } else {
        Write-Output "VLC is not running."
        # Uninstall VLC based on Architecture
        if (($Architecture -eq "x64") -or ($Architecture -eq "Both")) {
            $argumentsUninstall = @("/x", $guid64, "/Quiet", "/Norestart", '/log "C:\DLM\VLC\Uninstall.log"')
            $vlcUninstall = Start-Process msiexec -ArgumentList $argumentsUninstall -PassThru; Wait-Process $vlcUninstall.Id -ErrorAction SilentlyContinue
            $registryVLC64 = Get-ItemProperty $registry64 | Where-Object { $_.DisplayName -like "*VLC*" }
        }
        if (($Architecture -eq "x32") -or ($Architecture -eq "Both")) {
            $argumentsUninstall = @("/x", $guid32, "/Quiet", "/Norestart", '/log "C:\DLM\VLC\Uninstall.log"')
            $vlcUninstall = Start-Process msiexec -ArgumentList $argumentsUninstall -PassThru; Wait-Process $vlcUninstall.Id -ErrorAction SilentlyContinue
            $registryVLC32 = Get-ItemProperty $registry32 | Where-Object { $_.DisplayName -like "*VLC*" }
        }
        # Install VLC
        if (!($registryVLC64) -and (!($registryVLC32))) {
            $vlcInstall = Start-Process msiexec -ArgumentList '/i "vlc-3.0.20-win64.msi"', "/quiet", "/norestart", '/log "C:\DLM\VLC\Install.log"' -PassThru; Wait-Process $vlcInstall.Id -ErrorAction SilentlyContinue
            Exit $vlcInstall.ExitCode
        } else {
            Exit 1
        }
    }
}

#==========================================================================#
# MAIN LOGIC                                                               #
#==========================================================================#

# VARIABLES #
$logDirectory = "C:\DLM\VLC"
$logDirectoryExist = Test-Path -Path $logDirectory
$registry64 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
$registry32 = "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"

# DATA GATHERING #
# Check if VLC is already installed
$vlc64Bit = Get-ItemProperty $registry64 | Where-Object { $_.DisplayName -like "*VLC*" }
$vlc32Bit = Get-ItemProperty $registry32 | Where-Object { $_.DisplayName -like "*VLC*" }
# Assign VLC GUID to a variable
$guid64 = $vlc64Bit.PSChildName
$guid32 = $vlc32Bit.PSChildName

# IF VLC IS NOT INSTALLED #
if (!($vlc64Bit) -and !($vlc32Bit)) {
    New-LogDirectory
    $Architecture = "Neither"
    Install-VLC -Architecture $Architecture
}

# IF VLC 64-BIT IS INSTALLED #  
elseif ($vlc64Bit -and !($vlc32Bit)) {
    New-LogDirectory
    $Architecture = "x64"
    Install-VLC -Architecture $Architecture
}

# IF VLC 32-BIT IS INSTALLED #  
elseif ($vlc32Bit -and !($vlc64Bit)) {
    New-LogDirectory
    $Architecture = "x32"
    Install-VLC -Architecture $Architecture
}

# IF VLC 64-BIT & 32-BIT ARE INSTALLED #  
elseif (($vlc64Bit) -and ($vlc32Bit)) {
    New-LogDirectory
    $Architecture = "Both"
    Install-VLC -Architecture $Architecture
}

$vlcInstall.ExitCode