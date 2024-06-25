<#
    .SYNOPSIS
        Qualys Client Health.

    .DESCRIPTION
        The Qualys Client Health Script is designed to maintain the Qualys Cloud Security Agent by 
        making sure it's configured correctly, health, and kept up-to-date.

    .PARAMETER config
        Specifies the .xml Config File Location. 
        This contains all the parameters that this script uses in order to function properly. 

    .EXAMPLE
        PS> .\Qualys_Client_Health.ps1 -config C:\QualysClientHealth\Config.xml

    .EXAMPLE
        PS> .\Qualys_Client_Health.ps1 -config C:\QualysClientHealth\Config.xml -Verbose

    .NOTES
        Name: Qualys_Client_Health.ps1
        Version: 1.1
        Author: Aneurin Weale - VAR
        Date Created: 24/06/2024
        Last Updated: 25/06/2024
        URL: https://github.com/AnimatedAneurin/PowerShell/blob/PowerShell/Scripts/Qualys/Qualys%20Client%20Health/Windows/Qualys_Client_Health.ps1
#>

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

function cleanup_programDataPath {
    # Path to the registry key containing the products
    $programDataPath = "$Env:ProgramData\Qualys\QualysAgent"

    # Get all subkeys under the base registry path
    If (Test-Path $programDataPath) {
        Remove-Item $programDataPath
        If (!(Test-Path $programDataPath)) {
            Write-Host "cleanup_programDataPath successfull!"
        } else {
            Write-Host "cleanup_programDataPath Failed."
        }
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
            if (!(Test-Path "$regkeyHKCUInstallerProducts\$lastKey")) {
                Write-Host "cleanup_regkeyHKCUInstallerProducts successfull!"
            } else {
                Write-Host "cleanup_regkeyHKCUInstallerProducts failed."
            }
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

                if (!(Test-Path $installPropertiesPath)) {
                    Write-Host "cleanup_regkeyUserData Successfull!"
                } else {
                    Write-Host "cleanup_regkeyUserData failed."
                }
            }
        }
    }
}

function cleanup_registryQualys {
    # Define the registry path
    $registryQualys = "HKLM:\SOFTWARE\Qualys"

    If (!(Test-Path $registryQualys)) {
        Write-Host "RegKey does not exist."
    } else {
        # Delete the registry key
        Remove-Item -Path $registryQualys -Recurse -Force
        write-host "Deleted registry key: $registryQualys"

        If (!(Test-Path $registryQualys)) {
            Write-Host "cleanup_registryQualys successfull!"
        } else {
            Write-Host "cleanup_registryQualys failed."
        }
    }
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

            # Delete the registry key
            Remove-Item -Path $Key.PSPath -Recurse -Force
            write-host "Deleted registry key: $($Key.PSPath)"

            if (Test-Path "$registryPathx64\$($key.PSChildName)") {
                Write-Host "cleanup_registryPathx64 successfull!"
            } else {
                Write-host "cleanup_registryPathx64 failed."
            }
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

            # Delete the registry key
            Remove-Item -Path $Key.PSPath -Recurse -Force
            write-host "Deleted registry key: $($Key.PSPath)"

            if (Test-Path "$registryPathx86\$($key.PSChildName)") {
                Write-Host "cleanup_registryPathx86 successfull!"
            } else {
                Write-host "cleanup_registryPathx86 failed."
            }
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

function Install-Agent {
    write-host "Installing Qualys Agent version: $qualysCloudAgentPackagedVersion..."
    start-process -FilePath $PSScriptRoot\QualysCloudAgent.exe -ArgumentList "CustomerID=$customerID ActivationID=$activationID WebServiceUri=$webServiceUri" -wait
    If (($proxyPAC -ne "") -and ($proxyURL -eq "")) {
        Start-Sleep 5
        New-Item $regkeyProxy -Force
        New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxy -PropertyType "String" -Force
        Net stop "Qualys Cloud Agent"
        Net start "Qualys Cloud Agent"
    } if (($proxyPAC -eq "") -and ($proxyURL -ne "")) {
        Start-Sleep 5
        New-Item $regkeyProxy -Force
        New-ItemProperty $regkeyProxy -Name "URL" -Value $proxy -PropertyType "String" -Force
        Net stop "Qualys Cloud Agent"
        Net start "Qualys Cloud Agent"
    } if (($proxyPAC -ne "") -and ($proxyURL -ne "")) {
        Start-Sleep 5
        New-Item $regkeyProxy -Force
        New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxy -PropertyType "String" -Force
        New-ItemProperty $regkeyProxy -Name "URL" -Value $proxy -PropertyType "String" -Force
        Net stop "Qualys Cloud Agent"
        Net start "Qualys Cloud Agent"
    } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
        write-host "Proxy not specified."
    }
}

#$install = "C:\QualysClientHealth\installer\QualysCloudAgent.exe"

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
} else {
    # List of registry keys to check and potentially delete
    $regKeys = @(
        "HKLM:\Software\Test1",
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
        foreach ($key in $regKeys) {
            if (Test-RegKey -key $key) {
                Remove-Item -Path $key -Recurse -Force
                Write-Output "Deleted: $key"
            } else {
                Write-Output "Key not found, nothing to delete: $key"
            }
        }
    } else {
        Write-Output "All keys exist. No action taken."
    }
    if ($cleanUninstall -eq "y") {
        if ($whatIF -eq "") {
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
    } if (($cleanUninstall -eq "n") -or ($cleanUninstall -eq "")) {
        if ($whatIF -eq "") {
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
    } else {
        Write-Host "Please confirm if a Clean Uninstall is required."
    }
}

Install-Agent
write-host "Script Complete."