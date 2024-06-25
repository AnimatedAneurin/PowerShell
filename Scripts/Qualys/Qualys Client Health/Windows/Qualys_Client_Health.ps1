<#
    .SYNOPSIS
        Qualys Client Health.

    .DESCRIPTION
        The Qualys Client Health Script is designed to maintain the Qualys Cloud Security Agent by 
        making sure it's configured correctly, healthy, and up-to-date.

    .PARAMETER config
        Specifies the .xml Config File Location. 
        This contains all the parameters that this script uses in order to function properly. 

    .EXAMPLE
        PS> .\Qualys_Client_Health.ps1 -config C:\QualysClientHealth\Config.xml

    .EXAMPLE
        PS> .\Qualys_Client_Health.ps1 -config C:\QualysClientHealth\Config.xml -Verbose

    .NOTES
        Name: Qualys_Client_Health.ps1
        Version: 1.11
        Author: Aneurin Weale - VAR
        Date Created: 24/06/2024
        Last Updated: 26/06/2024
        URL: https://github.com/AnimatedAneurin/PowerShell/blob/PowerShell/Scripts/Qualys/Qualys%20Client%20Health/Windows/Qualys_Client_Health.ps1
#>

<# To-Do:
    1. Add Logging System.
    2. Finish WhatIF System.
#>

## SCRIPT START ##
## PARAMETERS & XML CONFIG - START REGION ##
Param (
    [Parameter(Mandatory=$True)] [String]$config,
    [Parameter(Mandatory=$False)] [Version]$qualysCloudAgentPackagedVersion,
    [Parameter(Mandatory=$False)] [String]$cleanUninstall,
    [Parameter(Mandatory=$False)] [String]$customerID,
    [Parameter(Mandatory=$False)] [String]$activationID,
    [Parameter(Mandatory=$False)] [String]$webServiceUri,
    [Parameter(Mandatory=$False)] [String]$proxyPAC,
    [Parameter(Mandatory=$False)] [String]$proxyURL,
    [Parameter(Mandatory=$False)] [String]$whatIF
)

# Load the XML file
if (Test-Path $Config) {
    [xml]$xmlContent = Get-Content -Path $Config
} else {
    Write-Error "Config file not found: $Config"
    exit 1
}

# Helper function to check if a parameter is bound
function IsParameterBound {
    param (
        [string]$paramName
    )
    return $PSCmdlet.MyInvocation.BoundParameters.ContainsKey($paramName)
}

# Assign the values from the XML to the script parameters if they are not provided
if (-not (IsParameterBound 'qualysCloudAgentPackagedVersion')) {
    $qualysCloudAgentPackagedVersion = [Version]$xmlContent.Parameters.qualysCloudAgentPackagedVersion
}
if (-not (IsParameterBound 'cleanUninstall')) {
    $cleanUninstall = $xmlContent.Parameters.cleanUninstall
}
if (-not (IsParameterBound 'customerID')) {
    $customerID = $xmlContent.Parameters.customerID
}
if (-not (IsParameterBound 'activationID')) {
    $activationID = $xmlContent.Parameters.activationID
}
if (-not (IsParameterBound 'webServiceUri')) {
    $webServiceUri = $xmlContent.Parameters.webServiceUri
}
if (-not (IsParameterBound 'proxyPAC')) {
    $proxyPAC = $xmlContent.Parameters.proxyPAC
}
if (-not (IsParameterBound 'proxyURL')) {
    $proxyURL = $xmlContent.Parameters.proxyURL
}
if (-not (IsParameterBound 'whatIF')) {
    $whatIF = $xmlContent.Parameters.whatIF
}
## PARAMETERS & XML CONFIG - END REGION ##


## FUNCTIONS - START REGION ##
function Clear_RegistryHKCUInstallerProducts {
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
            if (!(Test-Path "$regkeyHKCUInstallerProducts\$lastKey")) {
                Write-Host "Clear_RegistryHKCUInstallerProducts successfull!"
            } else {
                Write-Host "Clear_RegistryHKCUInstallerProducts failed."
            }
        }
    }
}

function Clear_RegistryUserData {
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
                if (!(Test-Path $installPropertiesPath)) {
                    Write-Host "Clear_RegistryUserData Successfull!"
                } else {
                    Write-Host "Clear_RegistryUserData failed."
                }
            }
        }
    }
}

function Clear_RegistryQualys {
    # Define the registry path
    $registryQualys = "HKLM:\SOFTWARE\Qualys"
    If (Test-Path $registryQualys) {
        # Delete the registry key
        Remove-Item -Path $registryQualys -Recurse -Force
        If (!(Test-Path $registryQualys)) {
            Write-Host "Registry cleanup successful!"
        } else {
            Write-Host "Registry cleanup failed."
        }
    } else {
        Write-Host "Registry key does not exist."
    }
}

function Clear-RegistryPath {
    param (
        [string]$RegistryPath,
        [string]$DisplayNameFilter = "*Qualys*"
    )
    # Get all subkeys under the Uninstall key
    $subKeys = Get-ChildItem -Path $RegistryPath -ErrorAction SilentlyContinue
    # Iterate through each subkey
    foreach ($subKey in $subKeys) {
        $fullSubKeyPath = $subkey.PSPath
        # Get the DisplayName value
        $productName = (Get-ItemProperty -Path $fullSubKeyPath -Name "DisplayName" -ErrorAction SilentlyContinue).DisplayName
        # Check if the DisplayName property exists and contains "Qualys"
        if ($productName -like $DisplayNameFilter) {
            # Output the key name and DisplayName
            write-host "Key: $($key.PSChildName)"
            write-host "DisplayName: $($productName.DisplayName)"
            # Delete the registry key
            Remove-Item -Path $fullSubKeyPath -Recurse -Force
            if (Test-Path "$RegistryPath\$($key.PSChildName)") {
                Write-Host "Successfully removed: $fullSubKeyPath"
            } else {
                Write-Host "Failed to remove: $fullSubKeyPath"
            }
        }
    }
}

function Clear_ServiceName {
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
        if (!(Get-Service -Name $serviceName -ErrorAction SilentlyContinue)) {
            write-host "Service '$serviceName' deleted successfully."
        } else {
            write-host "Failed to delete service '$serviceName'."
        }
    } else {
        write-host "Service '$serviceName' does not exist."
    }
}

function Clear_ProgramData {
    # Path to the registry key containing the products
    $programDataPath = "$Env:ProgramData\Qualys\QualysAgent"
    # Get all subkeys under the base registry path
    If (Test-Path $programDataPath) {
        Remove-Item $programDataPath -Recurse -Force
        If (!(Test-Path $programDataPath)) {
            Write-Host "ProgramData cleanup successful!"
        } else {
            Write-Host "ProgramData cleanup failed."
        }
    } Else {
        write-host "$programDataPath does not exist."
    }
}

function Uninstall-AgentClean {
    param (
        [string]$UninstallPath,
        [Version]$PackagedVersion
    )
    write-host "Comparing Installed file with Packaged file..."
    $installedVersion = (Get-Item $UninstallPath).VersionInfo.FileVersionRaw # This detects the currently installed version on the local device under Program Files.
    # Used for troubleshooting. Good way to confirm what versions have been detected.
    write-host "Installed Version: $installedVersion"
    write-host "Version Specified for package: $packagedVersion"
    if ($installedVersion -lt $packagedVersion) {
        write-host "Qualys Agent on local device is an older version than the packaged Qualys Agent."
        Write-Host "Uninstalling older version..."
        start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True Force=True" -Wait
        Start-Sleep 5
        if (Test-Path $UninstallPath) {
            write-host "ERROR: Uninstallation failed. Manual investigation recommended." -ForegroundColor Red
            write-host "INFORMATION: Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured." -ForegroundColor Yellow
            write-host "Please re-run the script again once manual investigation is done."
            write-host "Exiting script..."
            Exit 1
        } else {
            write-host "Uninstallation successful."
        }
    } else {
        write-host "Installed version is up-to-date or newer. No action taken."
        write-host "Exiting Script..."
        Exit 0
    }
}

function Uninstall-Agent {
    param (
        [string]$UninstallPath,
        [Version]$PackagedVersion
    )
    write-host "Comparing Installed file with Packaged file..."
    $installedVersion = (Get-Item $UninstallPath).VersionInfo.FileVersionRaw # This detects the currently installed version on the local device under Program Files.
    # Used for troubleshooting. Good way to confirm what versions have been detected.
    write-host "Installed Version: $installedVersion"
    write-host "Version Specified for package: $packagedVersion"
    if ($installedVersion -lt $packagedVersion) {
        write-host "Qualys Agent on local device is an older version than the packaged Qualys Agent."
        Write-Host "Uninstalling older version..."
        start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True" -Wait
        Start-Sleep 5
        if (Test-Path $UninstallPath) {
            write-host "ERROR: Uninstallation failed. Manual investigation recommended." -ForegroundColor Red
            write-host "INFORMATION: Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured." -ForegroundColor Yellow
            write-host "Please re-run the script again once manual investigation is done."
            write-host "Exiting script..."
            Exit 1
        } else {
            write-host "Uninstallation successful."
        }
    } else {
        write-host "Installed version is up-to-date or newer. No action taken."
        write-host "Exiting Script..."
        Exit 0
    }
}

function Install-Agent {
    write-host "Installing Qualys Agent version: $qualysCloudAgentPackagedVersion..."
    start-process -FilePath "C:\QualysClientHealth\Installer\QualysCloudAgent.exe" -ArgumentList "CustomerID=$customerID ActivationID=$activationID WebServiceUri=$webServiceUri" -wait
    If ($proxyPAC -ne "") {
        Start-Sleep 5
        New-Item $regkeyProxy -Force
        New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxy -PropertyType "String" -Force
        Restart-Service -Name "Qualys Cloud Agent"
    } if ($proxyURL -ne "") {
        Start-Sleep 5
        New-Item $regkeyProxy -Force
        New-ItemProperty $regkeyProxy -Name "URL" -Value $proxy -PropertyType "String" -Force
        Restart-Service -Name "Qualys Cloud Agent"
    } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
        write-host "Proxy not specified."
    }
}
## FUNCTIONS - END REGION ##

## MAIN LOGIC - REGION START ##
# VARIABLES #
$uninstallx64 = "$Env:Programfiles\Qualys\QualysAgent\Uninstall.exe"
$uninstallx86 = "${Env:Programfiles(x86)}\Qualys\QualysAgent\Uninstall.exe"

# HEALTH CHECK (PART 1 / 4) - IF AGENT DOES NOT ALREADY EXISTS. CLEAN INSTALL #
if ((!(Test-Path $uninstallx64) -and !(Test-Path $uninstallx86))) {
    write-host "QualysAgent.exe not detected."
    write-host "Skipping uninstall..."
    write-host "Running cleanup..."
    write-host "Cleansing Qualys from Registry..."
    Clear_RegistryQualys
    Clear_RegistryHKCUInstallerProducts
    Clear_RegistryUserData
    Cleanup-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    Cleanup-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    write-host "Cleansing Qualys from Services..."
    Clear_ServiceName
    write-host "Cleansing Qualys from ProgramData..."
    Clear_ProgramData
    write-host "Cleanup complete."
    write-host "All traces of Qualys have been removed."
} else {
# HEALTH CHECK (PART 2 / 4) - IF AGENT ALREADY EXISTS, BUT REGISTRY IS UNHEALTHY. CLEAN INSTALL #
    # List of registry keys to check and potentially delete
    $regKeys = @(
        "HKLM:\SOFTWARE\Qualys",
        "HKLM:\Software\Test2",
        "HKLM:\Software\Test3"
    )
    # Flag to determine if any key does not exist
    $anyKeyMissing = $false
    # Check if each registry key exists
    foreach ($key in $regKeys) {
        if (-not (Test-Path $key)) {
            $anyKeyMissing = $true
            break
        }
    }
    # If any key is missing, delete all keys in the list
    if ($anyKeyMissing) {
        if (Test-Path $uninstallx64) {
            # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
            write-host "File exists."
            write-host "Running Uninstall-AgentClean..."
            Uninstall-AgentClean -UninstallPath $uninstallx64 -PackagedVersion $QualysCloudAgentPackagedVersion
            write-host "Uninstall-AgentClean completed."
        }
        # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
        if (Test-Path $uninstallx86) {
            write-host "File exists."
            write-host "Running Uninstall-AgentClean..."
            Uninstall-AgentClean -UninstallPath $uninstallx86 -PackagedVersion $QualysCloudAgentPackagedVersion
            write-host "Uninstall-AgentClean completed."
        }
        foreach ($key in $regKeys) {
            if (Test-RegKey -key $key) {
                Remove-Item -Path $key -Recurse -Force
                Write-Output "Deleted: $key"
            } else {
                Write-Output "Key not found, nothing to delete: $key"
            }
        }
    } else {
# HEALTH CHECK (PART 3 / 4) - IF AGENT ALREADY EXISTS AND REGISTRY IS HEALTHY. CHECK IF UPGRADE IS REQUIRED #
        Write-Output "All keys exist. No action taken."
        if ($cleanUninstall -eq "y") {
            if ($whatIF -eq "") {
                if (Test-Path $uninstallx64) {
                    # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
                    write-host "File exists."
                    write-host "Running Uninstall-AgentClean..."
                    Uninstall-AgentClean -UninstallPath $uninstallx64 -PackagedVersion $QualysCloudAgentPackagedVersion
                    write-host "Uninstall-AgentClean completed."
                }
                # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
                if (Test-Path $uninstallx86) {
                    write-host "File exists."
                    write-host "Running Uninstall-AgentClean..."
                    Uninstall-AgentClean -UninstallPath $uninstallx86 -PackagedVersion $QualysCloudAgentPackagedVersion
                    write-host "Uninstall-AgentClean completed."
                }
                Write-Host "Running additional cleanup..."
                write-host "Cleansing Qualys from Registry..."
                Clear_RegistryQualys
                Clear_RegistryHKCUInstallerProducts
                Clear_RegistryUserData
                Cleanup-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
                Cleanup-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
                write-host "Cleansing Qualys from Services..."
                Clear_ServiceName
                write-host "Cleansing Qualys from ProgramData..."
                Clear_ProgramData
                write-host "Cleanup complete."
                write-host "All traces of Qualys have been removed."
            }
        } if (($cleanUninstall -eq "n") -or ($cleanUninstall -eq "")) {
            if ($whatIF -eq "") {
                # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
                if (Test-Path $uninstallx64) {
                    write-host "File exists."
                    write-host "Running Uninstall-Agent..."
                    Uninstall-Agent -UninstallPath $uninstallx64 -PackagedVersion $QualysCloudAgentPackagedVersion
                    write-host "Uninstall-Agent completed."
                }
                # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
                if (Test-Path $uninstallx86) {
                    write-host "File exists."
                    write-host "Running Uninstall-Agent..."
                    Uninstall-Agent -UninstallPath $uninstallx86 -PackagedVersion $QualysCloudAgentPackagedVersion
                    write-host "Uninstall-Agent completed."
                }
            }
        } else {
            Write-Host "Please confirm if a Clean Uninstall is required."
        }
# HEALTH CHECK (PART 4 / 4) - IF AGENT ALREADY EXISTS, REGISTRY IS HEALTHY AND AGENT IS UP-TO-DATE. RE-ENFORCE CORRECT CONFIGURATION #
        If ($proxyPAC -ne "") {
            Start-Sleep 5
            New-Item $regkeyProxy -Force
            New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxy -PropertyType "String" -Force
            Restart-Service -Name "Qualys Cloud Agent"
        } if ($proxyURL -ne "") {
            Start-Sleep 5
            New-Item $regkeyProxy -Force
            New-ItemProperty $regkeyProxy -Name "URL" -Value $proxy -PropertyType "String" -Force
            Restart-Service -Name "Qualys Cloud Agent"
        } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
            write-host "Proxy not specified."
        }
    }
}

Install-Agent
write-host "Script Complete."
## END REGION ##
## SCRIPT END ##