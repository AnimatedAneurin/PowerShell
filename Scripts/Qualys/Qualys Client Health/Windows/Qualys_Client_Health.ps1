<#
    .SYNOPSIS
        Qualys Client Health.

    .DESCRIPTION
        The Qualys Client Health Script is designed to maintain the Qualys Cloud Security Agent by 
        making sure it's configured correctly, health, and kept up-to-date.

    .PARAMETER qualysCloudAgentPackagedVersion
        Specifies the Qualys Cloud Security Agent that's packaged within SCCM.

    .PARAMETER cleanUninstall
        DO NOT USE for deployment, only use this for troubleshooting. cleanUninstall will remove all traces of Qualys
        from the local device, this means it will lose all its historic scan data.

    .PARAMETER customerID
        This is the CustomerID prvoided by Qualys. This is to be used when installing the Qualys Agent.

    .PARAMETER activationID
        This is the ActivationID prvoided by Qualys. This is to be used when installing the Qualys Agent.

    .PARAMETER webServiceUri
        This is the WebServiceUri prvoided by Qualys. This is to be used when installing the Qualys Agent.

    .PARAMETER proxyPAC
        Specifying a string for the Proxy PAC File. This is to be used when installing the Qualys Agent.

    .PARAMETER proxyURL
        Specifying a string for the Proxy URL. This is to be used when installing the Qualys Agent.

    .PARAMETER whatIf
        To be used when running the script as a test to avoid making changes to the device and used for troubleshooting.

    .EXAMPLE
        PS> .\QQualys_Client_Health.ps1 -qualysCloudAgentPackagedVersion 5.6.0.20

    .EXAMPLE
        PS> .\Qualys_Client_Health.ps1 -qualysCloudAgentPackagedVersion 5.6.0.20 -Verbose

    .EXAMPLE
        PS> .\Qualys_Client_Health.ps1 -qualysCloudAgentPackagedVersion 5.6.0.20 -cleanUninstall y -Verbose

    .NOTES
        Name: Qualys_Client_Health.ps1
        Version: 1.0
        Author: Aneurin Weale - VAR
        Date Created: 24/06/2024
        Last Updated: 24/06/2024
        URL: 
#>

Param (
    [Parameter(Mandatory=$True)] [Version]$qualysCloudAgentPackagedVersion,
    [Parameter(Mandatory=$False)] [String]$cleanUninstall = "n",
    [Parameter(Mandatory=$True)] [String]$customerID,
    [Parameter(Mandatory=$True)] [String]$activationID,
    [Parameter(Mandatory=$True)] [String]$webServiceUri,
    [Parameter(Mandatory=$False)] [String]$proxyPAC,
    [Parameter(Mandatory=$False)] [String]$proxyURL,
    [Parameter(Mandatory=$False)] [String]$whatIF
)

function cleanup_programDataPath {
    # Path to the registry key containing the products
    $programDataPath = "$Env:ProgramData\Qualys\QualysAgent"

    # Get all subkeys under the base registry path
    If (Test-Path $programDataPath) {
        Remove-Item $programDataPath
    } Else {
        write-host "$programDataPath does not exist."
    }
}

function cleanup_regkeyHKCUInstallerProducts {
    # Path to the registry key containing the products
    $regkeyHKCUInstallerProducts = "Registry::HKEY_CLASSES_ROOT\Installer\Products"

    # Get all subkeys under the base registry path
    $subKeys = Get-ChildItem -Path $regkeyHKCUInstallerProducts

    # Iterate through each subkey
    foreach ($subKey in $subKeys) {
        # Full path to the subkey
        $fullSubKeyPath = $subKey.PSPath

        # Check if the subkey has a 'ProductName' value
        $productName = (Get-ItemProperty -Path $fullSubKeyPath -Name "ProductName" -ErrorAction SilentlyContinue).ProductName

        if ($productName -and $productName -like "*Qualys*") {
            # Extract only the last part of the registry key path
            $lastKey = $subKey.PSChildName
            write-host "Product Name: $productName"
            write-host "Registry Key: $lastKey"

            # Delete the registry key
            Remove-Item -Path "$regkeyHKCUInstallerProducts\$lastKey" -Recurse -Force
            write-host "Deleted Registry Key: $lastKey"
        }
    }
}

function cleanup_regkeyUserData {
    # Define the base registry path
    $regkeyUserData = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products"

    # Get all subkeys under the Products key
    $productKeys = Get-ChildItem -Path $regkeyUserData

    # Iterate through each subkey
    foreach ($productKey in $productKeys) {
        # Define the path to the InstallProperties key
        $installPropertiesPath = "$($productKey.PSPath)\InstallProperties"
    
        # Check if the InstallProperties key exists
        if (Test-Path -Path $installPropertiesPath) {
            # Get the DisplayName value
            $displayName = Get-ItemProperty -Path $installPropertiesPath -Name DisplayName -ErrorAction SilentlyContinue

            # Check if the DisplayName contains "Qualys"
            if ($displayName.DisplayName -like "*Qualys*") {
                # Output the key name after Products and the DisplayName
                write-host "Key: $($productKey.PSChildName)"
                write-host "DisplayName: $($displayName.DisplayName)"

                # Delete the registry key
                Remove-Item -Path $productKey.PSPath -Recurse -Force
                write-host "Deleted registry key: $($productKey.PSPath)"
            }
        }
    }
}

function cleanup_registryQualys {
    # Define the registry path
    $registryQualys = "HKLM:\SOFTWARE\Qualys"

    # Delete the registry key
    Remove-Item -Path $registryQualys -Recurse -Force
    write-host "Deleted registry key: $registryQualys"
}

function cleanup_registryPathx64 {
    # Define the registry path
    $registryPathx64 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

    # Get all subkeys under the Uninstall key
    $uninstallKeys = Get-ChildItem -Path $registryPathx64

    # Iterate through each subkey
    foreach ($key in $uninstallKeys) {
        # Get the DisplayName value
        $displayName = Get-ItemProperty -Path $key.PSPath -Name DisplayName -ErrorAction SilentlyContinue

        # Check if the DisplayName property exists and contains "Qualys"
        if ($displayName -and $displayName.DisplayName -like "*Qualys*") {
            # Output the key name and DisplayName
            write-host "Key: $($key.PSChildName)"
            write-host "DisplayName: $($displayName.DisplayName)"
            write-host "---"

            # Delete the registry key
            Remove-Item -Path $Key.PSPath -Recurse -Force
            write-host "Deleted registry key: $($Key.PSPath)"
        }
    }
}

function cleanup_registryPathx86 {
    # Define the registry path
    $registryPathx86 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

    # Get all subkeys under the Uninstall key
    $uninstallKeys = Get-ChildItem -Path $registryPathx86

    # Iterate through each subkey
    foreach ($key in $uninstallKeys) {
        # Get the DisplayName value
        $displayName = Get-ItemProperty -Path $key.PSPath -Name DisplayName -ErrorAction SilentlyContinue

        # Check if the DisplayName property exists and contains "Qualys"
        if ($displayName -and $displayName.DisplayName -like "*Qualys*") {
            # Output the key name and DisplayName
            write-host "Key: $($key.PSChildName)"
            write-host "DisplayName: $($displayName.DisplayName)"
            write-host "---"

            # Delete the registry key
            Remove-Item -Path $Key.PSPath -Recurse -Force
            write-host "Deleted registry key: $($Key.PSPath)"
        }
    }
}

function cleanup_serviceName {
    # Define the name of the service you want to uninstall
    $serviceName = "QualysAgent"

    # Confirm Service exists
    try {
        $serviceNameCatch = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    } catch [Microsoft.PowerShell.Commands.GetServiceCommand] {
        Write-host "Service Does Not Exist."
    } catch {
        Write-Host "Unknown Error Occured."
    }

    if ($null -ne $serviceNameCatch) {
        # Stop the service first (if it's running)
        Stop-Service -Name $serviceName -Force

        # Uninstall the service using sc.exe
        & sc.exe delete $serviceName

        # Check if the service was successfully deleted
        if (-not (Get-Service -Name $serviceName -ErrorAction SilentlyContinue)) {
            write-host "Service '$serviceName' deleted successfully."
        } else {
            write-host "Failed to delete service '$serviceName'."
        }
    } else {
        write-host "Service Does Not Exist."
    }
}

function cleanUninstallx64 {
    write-host "Comparing Installed file with Packaged file..."
    $qualysCloudAgentInstalledVersionx64 = (Get-Item $uninstallx64).VersionInfo.FileVersionRaw # This detects the currently installed version on the local device under Program Files.
    # Used for troubleshooting. Good way to confirm what versions have been detected.
    write-host "Version Detected on Local Device: $qualysCloudAgentInstalledVersionx64"
    write-host "Version Specified for package: $qualysCloudAgentPackagedVersion"
    if ($qualysCloudAgentInstalledVersionx64 -lt $qualysCloudAgentPackagedVersion) {
        write-host "Qualys Agent on local device is an older version than the packaged Qualys Agent."
        write-host "Uninstalling Qualys Agent from local device..."
        start-process -FilePath $uninstallx64 -ArgumentList "Uninstall=True Force=True" -Wait
        Start-Sleep 5
        if (Test-Path $uninstallx64) {
            write-host "File exists."
            write-host "ERROR: Qualys Cloud Security Agent is still installed." -ForegroundColor Red
            write-host "INFORMATION: Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured. Manual Investigation Reccommended." -ForegroundColor Yellow
            write-host "Please re-run the script again once manual investigation is done."
            write-host "Exiting script..."
            Exit
        } else {
            write-host "File does not exist."
        }
    } else {
        write-host "Qualys Agent is either the same version or newer than the packaged version."
        write-host "The agent will not be uninstalled and the script will be terminated, due to the assumption that the agent is healthy."
        write-host "Exiting Script..."
        Exit
    }
}

function cleanUninstallx86 {
    write-host "Comparing Installed file with Packaged file..."
    $qualysCloudAgentInstalledVersionx86 = (Get-Item $uninstallx86).VersionInfo.FileVersionRaw # This detects the currently installed version on the local device under Program Files(x86).
    # Used for troubleshooting. Good way to confirm what versions have been detected.
    write-host "Version Detected on Local Device: $qualysCloudAgentInstalledVersionx86"
    write-host "Version Specified for package: $qualysCloudAgentPackagedVersion"
    if ($qualysCloudAgentInstalledVersionx86 -lt $qualysCloudAgentPackagedVersion) {
        write-host "Qualys Agent on local device is an older version than the packaged Qualys Agent."
        write-host "Uninstalling Qualys Agent from local device..."
        start-process -FilePath $uninstallx86 -ArgumentList "Uninstall=True Force=True" -Wait
        Start-Sleep 5
        if (Test-Path $uninstallx86) {
            write-host "File exists."
            write-host "ERROR: Qualys Cloud Security Agent is still installed." -ForegroundColor Red
            write-host "INFORMATION: Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured. Manual Investigation Reccommended." -ForegroundColor Yellow
            write-host "Please re-run the script again once manual investigation is done."
            write-host "Exiting script..."
            Exit
        } else {
            write-host "File does not exist."
        }
    } else {
        write-host "Qualys Agent is either the same version or newer than the packaged version."
        write-host "The agent will not be uninstalled and the script will be terminated, due to the assumption that the agent is healthy."
        write-host "Exiting Script..."
        Exit
    }
}

function uninstallx64 {
    write-host "Comparing Installed file with Packaged file..."
    $qualysCloudAgentInstalledVersionx64 = (Get-Item $uninstallx64).VersionInfo.FileVersionRaw # This detects the currently installed version on the local device under Program Files.
    # Used for troubleshooting. Good way to confirm what versions have been detected.
    write-host "Version Detected on Local Device: $qualysCloudAgentInstalledVersionx64"
    write-host "Version Specified for package: $qualysCloudAgentPackagedVersion"
    if ($qualysCloudAgentInstalledVersionx64 -lt $qualysCloudAgentPackagedVersion) {
        write-host "Qualys Agent on local device is an older version than the packaged Qualys Agent."
        write-host "Uninstalling Qualys Agent from local device..."
        start-process -FilePath $uninstallx64 -ArgumentList "Uninstall=True" -Wait
        if (Test-Path $uninstallx64) {
            write-host "File exists."
            write-host "ERROR: Qualys Cloud Security Agent is still installed." -ForegroundColor Red
            write-host "INFORMATION: Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured. Manual Investigation Reccommended." -ForegroundColor Yellow
            write-host "Please re-run the script again once manual investigation is done."
            write-host "Exiting script..."
            Exit
        } else {
            write-host "File does not exist."
        }
    } else {
        write-host "Qualys Agent is either the same version or newer than the packaged version."
        write-host "The agent will not be uninstalled and the script will be terminated, due to the assumption that the agent is healthy."
        write-host "Exiting Script..."
        Exit
    }
}

function uninstallx86 {
    write-host "Comparing Installed file with Packaged file..."
    $qualysCloudAgentInstalledVersionx86 = (Get-Item $uninstallx86).VersionInfo.FileVersionRaw # This detects the currently installed version on the local device under Program Files(x86).
    # Used for troubleshooting. Good way to confirm what versions have been detected.
    write-host "Version Detected on Local Device: $qualysCloudAgentInstalledVersionx86"
    write-host "Version Specified for package: $qualysCloudAgentPackagedVersion"
    if ($qualysCloudAgentInstalledVersionx86 -lt $qualysCloudAgentPackagedVersion) {
        write-host "Qualys Agent on local device is an older version than the packaged Qualys Agent."
        write-host "Uninstalling Qualys Agent from local device..."
        start-process -FilePath $uninstallx86 -ArgumentList "Uninstall=True" -Wait
        if (Test-Path $uninstallx86) {
            write-host "File exists."
            Write-host "ERROR: Qualys Cloud Security Agent is still installed." -ForegroundColor Red
            Write-host "INFORMATION: Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured. Manual Investigation Reccommended." -ForegroundColor Yellow
            write-host "Please re-run the script again once manual investigation is done."
            write-host "Exiting script..."
            Exit
        } else {
            write-host "File does not exist."
        }
    } else {
        write-host "Qualys Agent is either the same version or newer than the packaged version."
        write-host "The agent will not be uninstalled and the script will be terminated, due to the assumption that the agent is healthy."
        write-host "Exiting Script..."
        Exit
    }
}

function installx64 {
    write-host "Installing Qualys Agent version: $qualysCloudAgentPackagedVersion..."
    start-process -FilePath $PSScriptRoot\QualysCloudAgent.exe -ArgumentList "CustomerID=$customerID ActivationID=$activationID WebServiceUri=$webServiceUri" -wait
    If (($null -ne $proxyPAC) -and ($null -eq $proxyURL)) {
        Start-Sleep 5
        New-Item $regkeyProxy -Force
        New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxy -PropertyType "String" -Force
        Net stop "Qualys Cloud Agent"
        Net start "Qualys Cloud Agent"
    } if (($null -eq $proxyPAC) -and ($null -ne $proxyURL)) {
        Start-Sleep 5
        New-Item $regkeyProxy -Force
        New-ItemProperty $regkeyProxy -Name "URL" -Value $proxy -PropertyType "String" -Force
        Net stop "Qualys Cloud Agent"
        Net start "Qualys Cloud Agent"
    } if (($null -ne $proxyPAC) -and ($null -ne $proxyURL)) {
        Start-Sleep 5
        New-Item $regkeyProxy -Force
        New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxy -PropertyType "String" -Force
        New-ItemProperty $regkeyProxy -Name "URL" -Value $proxy -PropertyType "String" -Force
        Net stop "Qualys Cloud Agent"
        Net start "Qualys Cloud Agent"
    } if (($null -eq $proxyPAC) -and ($null -eq $proxyURL)) {
        write-host "Proxy not specified."
    }
}

$uninstallx86 = "${Env:Programfiles(x86)}\Qualys\QualysAgent\Uninstall.exe"
$uninstallx64 = "$Env:Programfiles\Qualys\QualysAgent\Uninstall.exe"
$install = "C:\QualysClientHealth\installer\QualysCloudAgent.exe"
$regkeyServices = "HKLM:\SYSTEM\CurrentControlSet\services\QualysAgent"
$regkeySoftware = "HKLM:\SOFTWARE\Qualys"
$regkeyInstaller = "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer"
$regkeyHKCUInstallerProducts = "Registry::HKEY_CLASSES_ROOT\Installer\Products"
$regkeyUserData = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products"
$regkeyProxy = "HKLM:\SOFTWARE\Qualys\Proxy\"
$serviceName = "QualysAgent"

#$qualysCloudAgentVersion = [Version]Get-ItemProperty 'C:\Program Files\Qualys\QualysAgent\QualysAgent.exe' | Select-Object -expand VersionInfo | Select-Object -expand ProductVersion
#$qualysCloudAgentInstalledVersion = [version]"3.1.0.140"
#$qualysCloudAgentPackagedVersion = [version]"5.6.0.20"

if ((!(Test-Path $uninstallx64) -and !(Test-Path $uninstallx86))) {
    write-host "QualysAgent.exe not detected."
    write-host "Skipping uninstall..."
    write-host "Running cleanup..."
    write-host "Cleansing Qualys from Registry..."
    cleanup_registryQualys
    cleanup_regkeyHKCUInstallerProducts
    cleanup_regkeyUserData
    cleanup_registryPathx64
    cleanup_registryPathx86
    write-host "Cleansing Qualys from Services..."
    cleanup_serviceName
    write-host "Cleansing Qualys from ProgramData..."
    cleanup_programDataPath
    write-host "Cleanup complete."
    write-host "All traces of Qualys have been removed."
}
else {
    if ($cleanUninstall -eq "y") {
        if ($whatIF -eq $null) {
            if (Test-Path $uninstallx64) {
                # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
                write-host "File exists."
                write-host "Running cleanUninstallx64..."
                cleanUninstallx64
                write-host "cleanUninstallx64 completed."
            }
            # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
            if (Test-Path $uninstallx86) {
                write-host "File exists."
                write-host "Running cleanUninstallx86..."
                cleanUninstallx86
                write-host "cleanUninstallx86 completed."
            }
            write-host "Running cleanup..."
            write-host "Cleansing Qualys from Registry..."
            cleanup_registryQualys
            cleanup_regkeyHKCUInstallerProducts
            cleanup_regkeyUserData
            cleanup_registryPathx64
            cleanup_registryPathx86
            write-host "Cleansing Qualys from Services..."
            cleanup_serviceName
            write-host "Cleansing Qualys from ProgramData..."
            cleanup_programDataPath
            write-host "Cleanup complete."
            write-host "All traces of Qualys have been removed."
        }
    } if ($cleanUninstall -eq "n") {
        if ($whatIF -eq $null) {
            # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
            if (Test-Path $uninstallx64) {
                write-host "File exists."
                write-host "Running uninstallx64..."
                uninstallx64
                write-host "uninstallx64 completed."
            }
            # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
            if (Test-Path $uninstallx86) {
                write-host "File exists."
                write-host "Running uninstallx86..."
                uninstallx86
                write-host "uninstallx86 completed."
            }
        }
    }
}

installx64
write-host "Script Complete."