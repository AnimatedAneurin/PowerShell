<#
    .SYNOPSIS
        Patch VLC via SCCM Application Package.

    .DESCRIPTION
        This is to be used as an Install Script within your Application Package to install VLC.
        DO NOT ENABLE SUPERCEDENCE WITHIN YOUR APPLICATION PACKAGE.

    .NOTES
        Name: Install-VLC
        Version: 1.1.0
        Author: Aneurin Weale - VAR
        Date Created: 16/06/2025
        Last Updated: 16/06/2025
        URL: https://github.com/AnimatedAneurin/PowerShell/blob/PowerShell/Scripts/App-Specific/VLC/install-VLC.ps1
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
        Write-Host "VLC Media Player currently not installed"
        Write-Host "Attempting to install VLC Media Player..."
        $vlcInstall = Start-Process msiexec -ArgumentList '/i "vlc-3.0.20-win64.msi"', "/quiet", "/norestart", '/log "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\install.log"' -PassThru; Wait-Process $vlcInstall.Id -ErrorAction SilentlyContinue
        return $vlcInstall.Exitcode
    }
    # If VLC is installed, then...
    Write-Host "Detected a version of VLC Media Player already installed."
    Write-Host "Proceeding with VLC Media Player removal..."
    # Create variables
    $registryVLC64 = ""
    $registryVLC32 = ""
    # Check if VLC is running
    $vlcProcess = Get-Process -Name "*vlc*" -ErrorAction SilentlyContinue
    # If VLC is running, then...
    if ($vlcProcess) {
        # Terminate VLC Process
        Write-Host "VLC is running. Attempting to terminate it..."
        $terminateVLC = Stop-Process -Name "*vlc*" -Force -PassThru; Wait-Process $terminateVLC.Id -ErrorAction SilentlyContinue
        # Confirm VLC has been terminated
        $vlcProcess = Get-Process -Name "*vlc*" -ErrorAction SilentlyContinue
        # If VLC has been terminated...
        if ($vlcProcess -eq $null) {
            Write-Host "VLC has been terminated."
            # Uninstall VLC based on Architecture
            if (($Architecture -eq "x64") -or ($Architecture -eq "Both")) {
                Write-Host "Uninstalling VLC Media Player x64..."
                $argumentsUninstall = @("/x", $guid64, "/Quiet", "/Norestart", '/log "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\removeEarlierVersions64.log"')
                $vlcUninstall = Start-Process msiexec -ArgumentList $argumentsUninstall -PassThru; Wait-Process $vlcUninstall.Id -ErrorAction SilentlyContinue
                Write-Host "Please see Uninstallation Logs Here: 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\removeEarlierVersions64.log'"
                $registryVLC64 = Get-ItemProperty $registry64 | Where-Object { $_.DisplayName -like "*VLC*" }
            }
            if (($Architecture -eq "x32") -or ($Architecture -eq "Both")) {
                Write-Host "Uninstalling VLC Media Player x32..."
                $argumentsUninstall = @("/x", $guid32, "/Quiet", "/Norestart", '/log "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\removeEarlierVersions32.log"')
                $vlcUninstall = Start-Process msiexec -ArgumentList $argumentsUninstall -PassThru; Wait-Process $vlcUninstall.Id -ErrorAction SilentlyContinue
                Write-Host "Please see Uninstallation Logs Here: 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\removeEarlierVersions32.log'"
                $registryVLC32 = Get-ItemProperty $registry32 | Where-Object { $_.DisplayName -like "*VLC*" }
            }
            # Install VLC
            if (!($registryVLC64) -and (!($registryVLC32))) {
                Write-Host "All instances of VLC Media Player removed."
                Write-Host "Attempting to install VLC Media Player..."
                $vlcInstall = Start-Process msiexec -ArgumentList '/i "vlc-3.0.20-win64.msi"', "/quiet", "/norestart", '/log "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\install.log"' -PassThru; Wait-Process $vlcInstall.Id -ErrorAction SilentlyContinue
                return $vlcInstall.ExitCode
            } else {
                return 1
            }
        # If VLC failed to terminate...
        } else {
            Write-Host "Failed to terminate VLC Media Player."
            Write-Host "Exiting Script..."
            return 1
        }
    # If VLC is NOT running then...
    } else {
        Write-Host "VLC is not running."
        # Uninstall VLC based on Architecture
        if (($Architecture -eq "x64") -or ($Architecture -eq "Both")) {
            Write-Host "Uninstalling VLC Media Player x64..."
            $argumentsUninstall = @("/x", $guid64, "/Quiet", "/Norestart", '/log "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\removeEarlierVersions64.log"')
            $vlcUninstall = Start-Process msiexec -ArgumentList $argumentsUninstall -PassThru; Wait-Process $vlcUninstall.Id -ErrorAction SilentlyContinue
            Write-Host "Please see Uninstallation Logs Here: 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\removeEarlierVersions64.log'"
            $registryVLC64 = Get-ItemProperty $registry64 | Where-Object { $_.DisplayName -like "*VLC*" }
        }
        if (($Architecture -eq "x32") -or ($Architecture -eq "Both")) {
            Write-Host "Uninstalling VLC Media Player x32..."
            $argumentsUninstall = @("/x", $guid32, "/Quiet", "/Norestart", '/log "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\removeEarlierVersions32.log"')
            $vlcUninstall = Start-Process msiexec -ArgumentList $argumentsUninstall -PassThru; Wait-Process $vlcUninstall.Id -ErrorAction SilentlyContinue
            Write-Host "Please see Uninstallation Logs Here: 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\removeEarlierVersions32.log'"
            $registryVLC32 = Get-ItemProperty $registry32 | Where-Object { $_.DisplayName -like "*VLC*" }
        }
        # Install VLC
        if (!($registryVLC64) -and (!($registryVLC32))) {
            Write-Host "All instances of VLC Media Player removed."
            Write-Host "Attempting to install VLC Media Player..."
            $vlcInstall = Start-Process msiexec -ArgumentList '/i "vlc-3.0.20-win64.msi"', "/quiet", "/norestart", '/log "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\install.log"' -PassThru; Wait-Process $vlcInstall.Id -ErrorAction SilentlyContinue
            return $vlcInstall.ExitCode
        } else {
            return 1
        }
    }
}

#==========================================================================#
# MAIN LOGIC                                                               #
#==========================================================================#

# VARIABLES #
$logDirectory = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\"
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
    Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\log.log"
    $Architecture = "Neither"
    $exitCode = Install-VLC -Architecture $Architecture
}

# IF VLC 64-BIT IS INSTALLED #  
elseif ($vlc64Bit -and !($vlc32Bit)) {
    New-LogDirectory
    Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\log.log"
    $Architecture = "x64"
    $exitCode = Install-VLC -Architecture $Architecture
}

# IF VLC 32-BIT IS INSTALLED #  
elseif ($vlc32Bit -and !($vlc64Bit)) {
    New-LogDirectory
    Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\log.log"
    $Architecture = "x32"
    $exitCode = Install-VLC -Architecture $Architecture
}

# IF VLC 64-BIT & 32-BIT ARE INSTALLED #  
elseif (($vlc64Bit) -and ($vlc32Bit)) {
    New-LogDirectory
    Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\log.log"
    $Architecture = "Both"
    $exitCode = Install-VLC -Architecture $Architecture
}

if ($exitCode -eq 0){
    Write-Host "VLC Media Player installed successfully"
    Write-Host "Please see Installation Logs Here: 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\install.log'"
} else {
    Write-Host "VLC Media Player installation failed with exit code $($exitCode)"
    Write-Host "Please see Installation Logs Here: 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\VLC\3.0.20\install.log'"
    
}

Stop-Transcript

Exit $exitCode