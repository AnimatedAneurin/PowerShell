<#
    .SYNOPSIS
        Zoom Detection and Remediation

    .DESCRIPTION
        This script will detect and then remove Zoom from the users appdata and the HKEY_USERS Registry.
        This is NOT an Uninstall.

    .NOTES
        Name: Zoom_Detection_and_Remediation.ps1
        Version: 1.1
        Author: Aneurin Weale - VAR
        Date Created: 14/08/2024
        Last Updated: 15/08/2024
        URL: https://github.com/AnimatedAneurin/PowerShell/blob/PowerShell/Scripts/Qualys/Remediation/Zoom_Detection_and_Remediation.ps1
#>

#Region Detection
$applicationDoesNotExist = $TRUE
$userRoot = "C:\Users"
$UserList = Get-ChildItem -Path $userRoot -Directory -Force -ErrorAction SilentlyContinue
foreach ($User in $UserList) {
    #Write-Host "Checking $userRoot\$($User.Name)"
    if (Test-Path -Path "$userRoot\$($User.Name)\AppData\Roaming\Zoom") {
        Write-Host "Application Found Under Username: $($User.Name)"
        $applicationDoesNotExist = $FALSE
    }
    <# Do not uncomment this section. This will break detection for Configuration Items on SCCM.
    else {
        Write-Host "Application Not Found"
    }#>
}
Write-Host $applicationDoesNotExist
#EndRegion

#Region Removal
$userRoot = "C:\Users"
$UserList = Get-ChildItem -Path $userRoot -Directory -Force -ErrorAction SilentlyContinue
$HKUReg = New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
$HKURoot = "HKU:\"
$HKUList = Get-ChildItem -Path $HKURoot -Force -ErrorAction SilentlyContinue
foreach ($User in $UserList) {
    if (Test-Path -Path "$userRoot\$($User.Name)\AppData\Roaming\Zoom") {
        Remove-Item -Recurse -Path "$($User.FullName)\AppData\Roaming\Zoom"
        #Start-Process -FilePath "$userRoot\$($User.Name)\AppData\Roaming\Zoom\uninstall\Installer.exe" -ArgumentList "/Uninstall" -Wait
        if (!(Test-Path -Path "$userRoot\$($User.Name)\AppData\Roaming\Zoom")) {
            Write-Host "Application Removed"
            foreach ($HKU in $HKUList) {
                #Write-Host "Checking $HKURoot\$($HKU.Name)"
                if (Test-Path -Path "$HKURoot\$($HKU.Name)\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ZoomUMX") {
                    #Write-Host "Found $HKURoot\$($HKU.Name)\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ZoomUMX"
                    Remove-Item -Recurse -Path "$HKURoot\$($HKU.Name)\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ZoomUMX"
                    if (!(Test-Path -Path "$HKURoot\$($HKU.Name)\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ZoomUMX")) {
                        Remove-PSDrive -Name HKU
                        Write-Host "Registry Cleaned"
                    } else {
                        Remove-PSDrive -Name HKU
                        Write-Host "Failed to Clean"
                    }
                }
            }
        } else {
            Write-Host "Failed to Uninstall"
        }
    }
}
#EndRegion