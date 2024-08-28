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

    .NOTES
        Name: Qualys_Client_Health.ps1
        Version: 1.5.1
        Author: Aneurin Weale - VAR
        Date Created: 24/06/2024
        Last Updated: 28/08/2024
        URL: https://github.com/AnimatedAneurin/PowerShell/blob/PowerShell/Scripts/Qualys/Qualys%20Client%20Health/Windows/Qualys_Client_Health.ps1
#>

## SCRIPT START ##
## PARAMETERS, LOGGING SYSTEM, & XML CONFIG - START REGION ##
# PARAMETERS #
Param (
    [Parameter(Mandatory=$True)] [String]$config,
    [Parameter(Mandatory=$False)] [String]$cleanUninstall,
    [Parameter(Mandatory=$False)] [String]$customerID,
    [Parameter(Mandatory=$False)] [String]$activationID,
    [Parameter(Mandatory=$False)] [String]$webServiceUri,
    [Parameter(Mandatory=$False)] [String]$proxyPAC,
    [Parameter(Mandatory=$False)] [String]$proxyURL,
    [Parameter(Mandatory=$False)] [String]$serverShare,
    [Parameter(Mandatory=$False)] [String]$serverInstaller,
    [Parameter(Mandatory=$False)] [String]$serverLogs,
    [Parameter(Mandatory=$False)] [String]$whatIF
)

# CREATE LOCAL DIRECTORIES #
If (!(Test-Path "C:\QualysClientHealth")) {
    New-Item -ItemType Directory -Force -Path "C:\QualysClientHealth"
}
If (!(Test-Path "C:\QualysClientHealth\Installer")) {
    New-Item -ItemType Directory -Force -Path "C:\QualysClientHealth\Installer"
}
If (!(Test-Path "C:\QualysClientHealth\Logs")) {
    New-Item -ItemType Directory -Force -Path "C:\QualysClientHealth\Logs"
}

# LOGGING SYSTEM #
$EUD = $env:computername
$log = "C:\QualysClientHealth\Logs\$EUD-QualysClientHealth.log"
Function LogWrite { #This function allows us to replace all 'Write-Host' commands to 'LogWrite' commands. This means instead of outputting text to the terminal, it'll output to a log file instead.
    #Function to create a log file in the current directory.
    Param ([string]$logstring)
    Add-Content $log -value "$(Get-Date -UFormat %Y%m%d-%H:%M:%S) - $($logstring)"
    #20190717-12:07:40 - Example
}

LogWrite -logstring "--------------------------------- START ----------------------------------"

# XML CONFIG #
# Load the XML file
if (Test-Path $Config) {
    [xml]$xmlContent = Get-Content -Path $Config
} else {
    LogWrite -logstring "Config file not found: $Config"
    LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
    # UPLOAD LOCAL LOGFILE TO SERVER
    Copy-Item $log -Destination "$serverLogs" -Force
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
if (-not (IsParameterBound 'serverShare')) {
    $serverShare = $xmlContent.Parameters.serverShare
}
if (-not (IsParameterBound 'serverInstaller')) {
    $serverInstaller = $xmlContent.Parameters.serverInstaller
}
if (-not (IsParameterBound 'serverLogs')) {
    $serverLogs = $xmlContent.Parameters.serverLogs
}
if (-not (IsParameterBound 'whatIF')) {
    $whatIF = $xmlContent.Parameters.whatIF
}
## PARAMETERS & XML CONFIG - END REGION ##


## FUNCTIONS - START REGION ##

function Clear_RegistryHKCUInstallerProducts {
    param (
        [string]$DeleteRegValue
    )
    # Path to the registry key containing the products
    $regkeyHKCUInstallerProducts = "Registry::HKEY_CLASSES_ROOT\Installer\Products"
    # Get all subkeys under the base registry path
    $subKeys = Get-ChildItem -Path $regkeyHKCUInstallerProducts
    # Initialize an array to store deleted registry keys
    $deletedKeysHKCUInstallerProducts = @()
    # Iterate through each subkey
    foreach ($subKey in $subKeys) {
        # Full path to the subkey
        $fullSubKeyPath = $subKey.PSPath
        # Check if the subkey has a 'ProductName' value
        $productName = (Get-ItemProperty -Path $fullSubKeyPath -Name "ProductName" -ErrorAction SilentlyContinue).ProductName
        if ($productName -and $productName -like "*Qualys*") {
            # Extract only the last part of the registry key path
            $lastKey = $subKey.PSChildName
            #LogWrite -logstring "Product Name: $productName"
            #LogWrite -logstring "Registry Key: $lastKey"
            # Assign the key path to a variable before deletion
            $regkeyToDelete = "$regkeyHKCUInstallerProducts\$lastKey"
            # Add the key to the deletedKeys array
            $deletedKeysHKCUInstallerProducts += $regkeyToDelete
            # Delete the registry key
            if ($DeleteRegValue -eq $TRUE) {
                Remove-Item -Path $regkeyToDelete -Recurse -Force
                LogWrite -logstring "Deleted Registry Key: $lastKey"
                if (!(Test-Path $regkeyToDelete)) {
                    LogWrite -logstring "Clear_RegistryHKCUInstallerProducts successfull!"
                } else {
                    LogWrite -logstring "Clear_RegistryHKCUInstallerProducts failed."
                }
            }
        }
    }
    if (($deletedKeysHKCUInstallerProducts.count -eq 0) -and ($DeleteRegValue -eq $FALSE)) {
        LogWrite -logstring "No Qualys Registry key(s) exists under: HKCR:\Installer\Products"
    }
    # Return the deleted keys for use outside the function
    return $deletedKeysHKCUInstallerProducts
}

function Clear_RegistryUserData {
    param (
        [string]$DeleteRegValue
    )
    # Define the base registry path
    $regkeyUserData = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products"
    # Get all subkeys under the Products key
    $productKeys = Get-ChildItem -Path $regkeyUserData
    # Initialize an array to store deleted registry keys
    $deletedKeysUserData = @()
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
                #LogWrite -logstring "Key: $($productKey.PSChildName)"
                #LogWrite -logstring "DisplayName: $($displayName.DisplayName)"
                # Assign the key path to a variable before deletion
                $regkeyToDelete = $productKey.PSPath
                # Add the key to the deletedKeys array
                $deletedKeysUserData += $regkeyToDelete
                # Delete the registry key
                if ($DeleteRegValue -eq $TRUE) {
                    Remove-Item -Path $regkeyToDelete -Recurse -Force
                    LogWrite -logstring "Deleted registry key: $($regkeyToDelete)"
                    if (!(Test-Path $installPropertiesPath)) {
                        LogWrite -logstring "Clear_RegistryUserData Successfull!"
                    } else {
                        LogWrite -logstring "Clear_RegistryUserData failed."
                    }
                }
            }
        }
    } if (($deletedKeysUserData.count -eq 0) -and ($DeleteRegValue -eq $FALSE)) {
        LogWrite -logstring "No Qualys Registry key(s) exists under: HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products"
    }
    # Return the deleted keys for use outside the function
    return $deletedKeysUserData
}

function Clear_RegistryQualys {
    param (
        [string]$DeleteRegValue
    )
    $missingRegKey = $FALSE
    # Define the registry path
    $registryQualys = "HKLM:\SOFTWARE\Qualys"
    If (Test-Path $registryQualys) {
        # Delete the registry key
        return $registryQualys
        if ($DeleteRegValue -eq $TRUE) {
            Remove-Item -Path $registryQualys -Recurse -Force
            If (!(Test-Path $registryQualys)) {
                LogWrite -logstring "Registry cleanup successful!"
            } else {
                LogWrite -logstring "Registry cleanup failed."
            }
        }
    } else {
        $missingRegKey = $TRUE
    } if (($missingRegKey -eq $TRUE) -and ($DeleteRegValue -eq $FALSE)) {
        LogWrite -logstring "Registry key does not exist: HKLM:\SOFTWARE\Qualys"
    }
}

function Clear-RegistryPath {
    param (
        [string]$RegistryPath,
        [string]$DeleteRegValue,
        [string]$DisplayNameFilter = "*Qualys*"
    )
    # Get all subkeys under the Uninstall key
    $subKeys = Get-ChildItem -Path $RegistryPath -ErrorAction SilentlyContinue
    # Initialize an array to store deleted registry keys
    $deletedKeysRegistryPath = @()
    # Iterate through each subkey
    foreach ($subKey in $subKeys) {
        $fullSubKeyPath = $subkey.PSPath
        # Get the DisplayName value
        $productName = (Get-ItemProperty -Path $fullSubKeyPath -Name "DisplayName" -ErrorAction SilentlyContinue).DisplayName
        # Check if the DisplayName property exists and contains "Qualys"
        if ($productName -like $DisplayNameFilter) {
            # Output the key name and DisplayName
            #LogWrite -logstring "Key: $($key.PSChildName)"
            #LogWrite -logstring "DisplayName: $($productName.DisplayName)"
            # Assign the key path to a variable before deletion
            $regkeyToDelete = $fullSubKeyPath
            # Add the key to the deletedKeys array
            $deletedKeysRegistryPath += $regkeyToDelete
            # Delete the registry key
            if ($DeleteRegValue -eq $TRUE) {
                Remove-Item -Path $fullSubKeyPath -Recurse -Force
                if (Test-Path "$RegistryPath\$($key.PSChildName)") {
                    LogWrite -logstring "Successfully removed: $fullSubKeyPath"
                } else {
                    LogWrite -logstring "Failed to remove: $fullSubKeyPath"
                }
            }
        }
    }
    # Return the deleted keys for use outside the function
    return $deletedKeysRegistryPath
}

function Clear_ServiceName {
    # Define the name of the service you want to uninstall
    $serviceName = "QualysAgent"
    # Confirm Service exists
    try {
        $serviceNameCatch = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    } catch [Microsoft.PowerShell.Commands.GetServiceCommand] {
        LogWrite -logstring "Service Does Not Exist."
    } catch {
        LogWrite -logstring "Unknown Error Occured."
    }
    if ($null -ne $serviceNameCatch) {
        # Stop the service first (if it's running)
        Stop-Service -Name $serviceName -Force
        # Uninstall the service using sc.exe
        & sc.exe delete $serviceName
        # Check if the service was successfully deleted
        if (!(Get-Service -Name $serviceName -ErrorAction SilentlyContinue)) {
            LogWrite -logstring "Service '$serviceName' deleted successfully."
        } else {
            LogWrite -logstring "Failed to delete service '$serviceName'."
        }
    } else {
        LogWrite -logstring "Service '$serviceName' does not exist."
    }
}

function Clear_ProgramData {
    # Path to the registry key containing the products
    $programDataPath = "$Env:ProgramData\Qualys\QualysAgent"
    # Get all subkeys under the base registry path
    If (Test-Path $programDataPath) {
        Remove-Item $programDataPath -Recurse -Force
        If (!(Test-Path $programDataPath)) {
            LogWrite -logstring "ProgramData cleanup successful!"
        } else {
            LogWrite -logstring "ProgramData cleanup failed."
        }
    } Else {
        LogWrite -logstring "$programDataPath does not exist."
    }
}

function Uninstall-Agent {
    param (
        [string]$UninstallPath,
        [string]$CleanUninstall
    )
    LogWrite -logstring "Uninstalling Qualys Agent..."
    if ($cleanUninstall -eq "y") {
        start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True Force=True" -Wait
    }
    if (($cleanUninstall -eq "n") -or ($cleanUninstall -eq "")) {
        start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True" -Wait
    }
    Start-Sleep 5
    if (Test-Path $UninstallPath) {
        LogWrite -logstring "ERROR: Uninstallation failed. Performing Deep Clean..."
        LogWrite -logstring "Cleansing Qualys from Registry..."
        Clear_RegistryQualys -DeleteRegValue $True
        Clear_RegistryHKCUInstallerProducts -DeleteRegValue $True
        Clear_RegistryUserData -DeleteRegValue $True
        Clear-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $True
        Clear-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $True
        LogWrite -logstring "Cleansing Qualys from Services..."
        Clear_ServiceName
        LogWrite -logstring "Cleansing Qualys from ProgramData..."
        Clear_ProgramData
        LogWrite -logstring "Cleansing Qualys from ProgramFiles..."
        Remove-Item "$Env:ProgramFiles\Qualys\QualysAgent" -Recurse -Force
        LogWrite -logstring "Cleanup complete."
        LogWrite -logstring "All traces of Qualys have been removed."
        if (Test-Path $UninstallPath) {
            LogWrite -logstring "ERROR: Uninstallation failed. Manual investigation recommended."
            LogWrite -logstring "INFORMATION: Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured."
            LogWrite -logstring "Please re-run the script again once manual investigation is done."
            LogWrite -logstring "Exiting script..."
            LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
            # UPLOAD LOCAL LOGFILE TO SERVER
            Copy-Item $log -Destination "$serverLogs" -Force
            Exit 1
        }
    } else {
        LogWrite -logstring "Uninstallation successful."
    }
}

function Update-Agent {
    param (
        [string]$UninstallPath,
        [string]$CleanUninstall
    )
    $AgentUpdated = 0
    LogWrite -logstring "Comparing Locally Installed Qualys Agent with Remote Qualys Agent Installer..."
    $installedVersion = (Get-Item $UninstallPath).VersionInfo.FileVersionRaw # This detects the currently installed version on the local device under Program Files.
    $serverVersion = (Get-Item $serverInstaller).VersionInfo.FileVersionRaw # This detects the remote installer version.
    # Used for troubleshooting. Good way to confirm what versions have been detected.
    LogWrite -logstring "Installed Version: $installedVersion"
    LogWrite -logstring "Remote Version: $serverVersion"
    if ($installedVersion -lt $serverVersion) {
        LogWrite -logstring "Qualys Agent on local device is an older version than the packaged Qualys Agent."
        LogWrite -logstring "Uninstalling older version..."
        if ($cleanUninstall -eq "y") {
            start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True Force=True" -Wait
        }
        if (($cleanUninstall -eq "n") -or ($cleanUninstall -eq "")) {
            start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True" -Wait
        }
        Start-Sleep 5
        if (Test-Path $UninstallPath) {
            LogWrite -logstring "ERROR: Uninstallation failed. Manual investigation recommended."
            LogWrite -logstring "INFORMATION: Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured."
            LogWrite -logstring "Please re-run the script again once manual investigation is done."
            LogWrite -logstring "Exiting script..."
            LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
            # UPLOAD LOCAL LOGFILE TO SERVER
            Copy-Item $log -Destination "$serverLogs" -Force
            Exit 1
        } else {
            LogWrite -logstring "Uninstallation successful."
            LogWrite -logstring "Downloading Qualys Agent to local directory..."
            Copy-Item $serverInstaller -Destination "C:\QualysClientHealth\Installer" -Force
            LogWrite -logstring "Installing Qualys Agent version: $serverVersion..."
            start-process -FilePath "C:\QualysClientHealth\Installer\QualysCloudAgent.exe" -ArgumentList "CustomerID=$customerID ActivationID=$activationID WebServiceUri=$webServiceUri" -wait
            Start-Sleep 5
            if ((Test-Path $uninstallx64) -or (Test-Path $uninstallx86)) {
                LogWrite -logstring "Qualys Agent Successfully installed!"
                LogWrite -logstring "Configuring Proxy..."
                If ($proxyPAC -ne "") {
                    New-Item $regkeyProxy -Force
                    New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxyPAC -PropertyType "String" -Force
                    Restart-Service -Name "Qualys Cloud Agent"
                    LogWrite -logstring "Proxy Configured."
                } if ($proxyURL -ne "") {
                    New-Item $regkeyProxy -Force
                    New-ItemProperty $regkeyProxy -Name "URL" -Value $proxyURL -PropertyType "String" -Force
                    Restart-Service -Name "Qualys Cloud Agent"
                    LogWrite -logstring "Proxy Configured."
                } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
                    LogWrite -logstring "Proxy not specified."
                }
                $AgentUpdated = 1
            } else {
                LogWrite -logstring "Qualys Agent installation failed."
                $AgentUpdated = 0
            }
        }
    } else {
        LogWrite -logstring "Installed version is up-to-date or newer. No action taken."
        $AgentUpdated = 0
    }
    return $AgentUpdated
}

function Install-Agent {
    LogWrite -logstring "Checking if Qualys Agent Installer exists locally..."
    if (!(Test-Path "C:\QualysClientHealth\Installer\QualysCloudAgent.exe")) {
        LogWrite -logstring "Qualys Agent Installer Not Detected. Downloading Installer..."
        Copy-Item $serverInstaller -Destination "C:\QualysClientHealth\Installer" -Force
    }
    $serverVersion = (Get-Item $serverInstaller).VersionInfo.FileVersionRaw # This detects the remote installer version.
    LogWrite -logstring "Installing Qualys Agent version: $serverVersion..."
    start-process -FilePath "C:\QualysClientHealth\Installer\QualysCloudAgent.exe" -ArgumentList "CustomerID=$customerID ActivationID=$activationID WebServiceUri=$webServiceUri" -wait
    Start-Sleep 5
    if ((Test-Path $uninstallx64) -or (Test-Path $uninstallx86)) {
        LogWrite -logstring "Qualys Agent Successfully installed!"
        LogWrite -logstring "Configuring Proxy..."
        If ($proxyPAC -ne "") {
            New-Item $regkeyProxy -Force
            New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxyPAC -PropertyType "String" -Force
            Restart-Service -Name "Qualys Cloud Agent"
            LogWrite -logstring "Proxy Configured."
        } if ($proxyURL -ne "") {
            New-Item $regkeyProxy -Force
            New-ItemProperty $regkeyProxy -Name "URL" -Value $proxyURL -PropertyType "String" -Force
            Restart-Service -Name "Qualys Cloud Agent"
            LogWrite -logstring "Proxy Configured."
        } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
            LogWrite -logstring "Proxy not specified."
        }
        LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
        # UPLOAD LOCAL LOGFILE TO SERVER
        Copy-Item $log -Destination "$serverLogs" -Force
        Exit 0
    } else {
        LogWrite -logstring "Qualys Agent installation failed."
        LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
        # UPLOAD LOCAL LOGFILE TO SERVER
        Copy-Item $log -Destination "$serverLogs" -Force
        Exit 1
    }
}
## FUNCTIONS - END REGION ##

## REGION ADMINISTRATOR CHECK ##
$user = [Security.Principal.WindowsIdentity]::GetCurrent(); #Grabs current PowerShell sessions user identity.
$isSystem = ($user).IsSystem #Checks if current PowerShell session is an Admin.
If ($isSystem -eq $TRUE) {

    LogWrite "Required Privilages Met."

}
Else {

    LogWrite "ERROR: Script cannot run correctly without correct privilage escalation."

}
## END REGION ##

## MAIN LOGIC - REGION START ##
# VARIABLES #
$uninstallx64 = "$Env:Programfiles\Qualys\QualysAgent\Uninstall.exe"
$uninstallx86 = "${Env:Programfiles(x86)}\Qualys\QualysAgent\Uninstall.exe"
$regkeyProxy = "HKLM:\SOFTWARE\Qualys\Proxy"

if (!($whatIF -eq "y")) {
# HEALTH CHECK (PART 1 / 4) - IF AGENT DOES NOT ALREADY EXISTS. CLEAN INSTALL #
    LogWrite -logstring "HEALTH CHECK (PART 1 / 4): Checking if Qualys Agent is already installed..."
    if ((!(Test-Path $uninstallx64) -and !(Test-Path $uninstallx86))) {
        LogWrite -logstring "QualysAgent.exe not detected."
        LogWrite -logstring "Skipping uninstall..."
        LogWrite -logstring "Running cleanup..."
        LogWrite -logstring "Cleansing Qualys from Registry..."
        Clear_RegistryQualys -DeleteRegValue $True
        Clear_RegistryHKCUInstallerProducts -DeleteRegValue $True
        Clear_RegistryUserData -DeleteRegValue $True
        Clear-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $True
        Clear-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $True
        LogWrite -logstring "Cleansing Qualys from Services..."
        Clear_ServiceName
        LogWrite -logstring "Cleansing Qualys from ProgramData..."
        Clear_ProgramData
        LogWrite -logstring "Cleanup complete."
        LogWrite -logstring "All traces of Qualys have been removed."
        LogWrite -logstring "Running Install-Agent..."
        Install-Agent
    } else {
# HEALTH CHECK (PART 2 / 4) - IF AGENT ALREADY EXISTS, BUT REGISTRY IS UNHEALTHY. CLEAN INSTALL #
        LogWrite -logstring "Qualys Agent Already Installed. Initiating Next Health Check."
        LogWrite -logstring "HEALTH CHECK (PART 2 / 4): Checking Registry Health..."
        # Flag to determine if any key does not exist
        $anyKeyMissing = $false
        # List of registry keys to check and potentially delete
        $regKeys = @(
            
        )
        LogWrite -logstring "Running Clear_RegistryQualys DelRegValue False..."
        $deletedKeysRegistryQualys = Clear_RegistryQualys -DeleteRegValue $False
        if ($deletedKeysRegistryQualys) {
            $regKeys += $deletedKeysRegistryQualys
        } else {
            $anyKeyMissing = $True
        }
        LogWrite -logstring "Running Clear_RegistryHKCUInstallerProducts DelRegValue False..."
        $deletedKeysHKCUInstallerProducts = Clear_RegistryHKCUInstallerProducts -DeleteRegValue $False
        if ($deletedKeysHKCUInstallerProducts) {
            $regKeys += $deletedKeysHKCUInstallerProducts
        } else {
            $anyKeyMissing = $True
        }
        LogWrite -logstring "Running Clear_RegistryUserData DelRegValue False..."
        $deletedKeysUserData = Clear_RegistryUserData -DeleteRegValue $False
        if ($deletedKeysUserData) {
            $regKeys += $deletedKeysUserData
        } else {
            $anyKeyMissing = $True
        }
        $x = 0
        LogWrite -logstring "Running Clear-RegistryPathx64 DelRegValue False..."
        $deletedKeysRegistryPath = Clear-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $False
        if ($deletedKeysRegistryPath) {
            $regKeys += $deletedKeysRegistryPath
        } else {
            LogWrite -logstring "No Qualys Registry key(s) exists under: HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
            $x += 1
        }
        LogWrite -logstring "Running Clear-RegistryPathx86 DelRegValue False..."
        $deletedKeysRegistryPath = Clear-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $False
        if ($deletedKeysRegistryPath) {
            $regKeys += $deletedKeysRegistryPath
        } else {
            if ($x -eq 1) {
                LogWrite -logstring "No Qualys Registry key(s) exists under: HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
                $x += 1
            }
        }
        if ($x -eq 2) {
            $anyKeyMissing = $True
        }
        # Check if each registry key exists
        if (!($anyKeyMissing)) {
            foreach ($key in $regKeys) {
                if (!(Test-Path $key)) {
                    $anyKeyMissing = $true
                    break
                }
            }
        }
        # If any key is missing, delete all keys in the list
        if ($anyKeyMissing) {
            if (Test-Path $uninstallx64) {
                # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
                LogWrite -logstring "Detected that QualysAgent.exe is already installed, but Registry is unhealthy."
                LogWrite -logstring "QualysAgent.exe must be reinstalled to fix Registry issues."
                LogWrite -logstring "Running Uninstall-Agent..."
                Uninstall-Agent -UninstallPath $uninstallx64 -CleanUninstall "y"
                LogWrite -logstring "Uninstall-Agent completed."
            }
            # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
            if (Test-Path $uninstallx86) {
                LogWrite -logstring "Detected that QualysAgent.exe is already installed, but Registry is unhealthy."
                LogWrite -logstring "QualysAgent.exe must be reinstalled to fix Registry issues."
                LogWrite -logstring "Running Uninstall-Agent..."
                Uninstall-Agent -UninstallPath $uninstallx86 -CleanUninstall "y"
                LogWrite -logstring "Uninstall-Agent completed."
            }
            LogWrite -logstring "Running Install-Agent..."
            Install-Agent
        } else {
# HEALTH CHECK (PART 3 / 4) - IF AGENT ALREADY EXISTS AND REGISTRY IS HEALTHY. CHECK IF UPGRADE IS REQUIRED #
            LogWrite -logstring "Qualys Agent already installed and Registry is Healthy. Initiating Next Health Check."
            LogWrite -logstring "HEALTH CHECK (PART 3 / 4): Checking if Qualys Agent Update is required..."
            if (Test-Path $uninstallx64) {
                # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
                LogWrite -logstring "Running Update-Agent..."
                $AgentUpdated = Update-Agent -UninstallPath $uninstallx64 -CleanUninstall $cleanUninstall
                LogWrite -logstring "Update-Agent completed."
            }
            # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
            if (Test-Path $uninstallx86) {
                LogWrite -logstring "Running Update-Agent..."
                $AgentUpdated = Update-Agent -UninstallPath $uninstallx86 -CleanUninstall $cleanUninstall
                LogWrite -logstring "Update-Agent completed."
            }
# HEALTH CHECK (PART 4 / 4) - IF AGENT ALREADY EXISTS, REGISTRY IS HEALTHY AND AGENT IS UP-TO-DATE. RE-ENFORCE CORRECT CONFIGURATION #
            LogWrite -logstring "Qualys Agent already installed, Registry is Healthy, and Qualys Agent is up-to-date. Initiating Next Health Check."
            LogWrite -logstring "HEALTH CHECK (PART 4 / 4): Checking Proxy Configuration..."
            If ($AgentUpdated -eq 0) {
                LogWrite -logstring "Checking Proxy Configuration..."
                If ($proxyPAC -ne "") {
                    Start-Sleep 5
                    New-Item $regkeyProxy -Force
                    New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxyPAC -PropertyType "String" -Force
                    Restart-Service -Name "Qualys Cloud Agent"
                    LogWrite -logstring "Proxy Configured."
                } if ($proxyURL -ne "") {
                    Start-Sleep 5
                    New-Item $regkeyProxy -Force
                    New-ItemProperty $regkeyProxy -Name "URL" -Value $proxyURL -PropertyType "String" -Force
                    Restart-Service -Name "Qualys Cloud Agent"
                    LogWrite -logstring "Proxy Configured."
                } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
                    LogWrite -logstring "Proxy not specified."
                }
            }
        }
    }
}

if ($whatIF -eq "y") {
# HEALTH CHECK (PART 1 / 4) - IF AGENT DOES NOT ALREADY EXISTS. CLEAN INSTALL #
    if ((!(Test-Path $uninstallx64) -and !(Test-Path $uninstallx86))) {
        LogWrite -logstring "QualysAgent.exe not detected."
        LogWrite -logstring "Skipping uninstall..."
        LogWrite -logstring "Running cleanup..."
        LogWrite -logstring "Cleansing Qualys from Registry..."
        LogWrite -logstring "WHATIF: Function 'Clear_RegistryQualys' would run here"
        LogWrite -logstring "WHATIF: Function 'Clear_RegistryHKCUInstallerProducts' would run here"
        LogWrite -logstring "WHATIF: Function 'Clear_RegistryUserData' would run here"
        LogWrite -logstring "WHATIF: Function 'Clear-RegistryPath' would run here"
        LogWrite -logstring "WHATIF: Function 'Clear-RegistryPath' would run here"
        LogWrite -logstring "Cleansing Qualys from Services..."
        LogWrite -logstring "WHATIF: Function 'Clear_ServiceName' would run here"
        LogWrite -logstring "Cleansing Qualys from ProgramData..."
        LogWrite -logstring "WHATIF: Function 'Clear_ProgramData' would run here"
        LogWrite -logstring "Cleanup complete."
        LogWrite -logstring "All traces of Qualys have been removed."
        LogWrite -logstring "Installing Qualys Agent..."
        LogWrite -logstring "WHATIF: Function 'Install-Agent' would run here"
        LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
        # UPLOAD LOCAL LOGFILE TO SERVER
        Copy-Item $log -Destination "$serverLogs" -Force
        Exit 0
    } else {
# HEALTH CHECK (PART 2 / 4) - IF AGENT ALREADY EXISTS, BUT REGISTRY IS UNHEALTHY. CLEAN INSTALL #
        # List of registry keys to check and potentially delete
        $regKeys = @(
            "HKLM:\SOFTWARE\Qualys"
        )
        $deletedKeysHKCUInstallerProducts = Clear_RegistryHKCUInstallerProducts -DeleteRegValue $False
        $regKeys += $deletedKeysHKCUInstallerProducts
        $deletedKeysUserData = Clear_RegistryUserData -DeleteRegValue $False
        $regKeys += $deletedKeysUserData
        $deletedKeysRegistryPath = Clear-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $False
        $regKeys += $deletedKeysRegistryPath
        $deletedKeysRegistryPath = Clear-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $False
        $regKeys += $deletedKeysRegistryPath
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
                LogWrite -logstring "Detected that QualysAgent.exe is already installed, but Registry is unhealthy."
                LogWrite -logstring "QualysAgent.exe must be reinstalled to fix Registry issues."
                LogWrite -logstring "Running Uninstall-Agent..."
                LogWrite -logstring "WHATIF: Uninstall(x64) would take place here."
                LogWrite -logstring "Uninstall-Agent completed."
            }
            # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
            if (Test-Path $uninstallx86) {
                LogWrite -logstring "Detected that QualysAgent.exe is already installed, but Registry is unhealthy."
                LogWrite -logstring "QualysAgent.exe must be reinstalled to fix Registry issues."
                LogWrite -logstring "Running Uninstall-Agent..."
                LogWrite -logstring "WHATIF: Uninstall(x86) would take place here."
                LogWrite -logstring "Uninstall-Agent completed."
            }
            foreach ($key in $regKeys) {
                if (Test-Path $key) {
                    LogWrite -logstring "WHATIF: RegKey Deletion would take place here."
                    LogWrite -logstring "Deleted: $key"
                } else {
                    LogWrite -logstring "Key not found, nothing to delete: $key"
                }
            }
            LogWrite -logstring "Installing Qualys Agent..."
            LogWrite -logstring "WHATIF: Function 'Install-Agent' would run here"
            if ((Test-Path $uninstallx64) -or (Test-Path $uninstallx86)) {
                LogWrite -logstring "Qualys Agent Successfully installed!"
                LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
                # UPLOAD LOCAL LOGFILE TO SERVER
                Copy-Item $log -Destination "$serverLogs" -Force
                Exit 0
            } else {
                LogWrite -logstring "Qualys Agent installation failed."
                LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
                # UPLOAD LOCAL LOGFILE TO SERVER
                Copy-Item $log -Destination "$serverLogs" -Force
                Exit 1
            }
        } else {
# HEALTH CHECK (PART 3 / 4) - IF AGENT ALREADY EXISTS AND REGISTRY IS HEALTHY. CHECK IF UPGRADE IS REQUIRED #
            LogWrite -logstring "All keys exist. No action taken."
            if (Test-Path $uninstallx64) {
                # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
                LogWrite -logstring "Detected that QualysAgent.exe is already installed, but is out-dated."
                LogWrite -logstring "QualysAgent.exe must be updated to the latest version."
                LogWrite -logstring "Running Update-Agent..."
                LogWrite -logstring "WHATIF: Uninstall(x64) would take place here."
                LogWrite -logstring "Update-Agent completed."
            }
            # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
            if (Test-Path $uninstallx86) {
                LogWrite -logstring "Detected that QualysAgent.exe is already installed, but is out-dated."
                LogWrite -logstring "QualysAgent.exe must be updated to the latest version."
                LogWrite -logstring "Running Update-Agent..."
                LogWrite -logstring "WHATIF: Uninstall(x86) would take place here."
                LogWrite -logstring "Update-Agent completed."
            }
            if ((Test-Path $uninstallx64) -or (Test-Path $uninstallx86)) {
                LogWrite -logstring "Qualys Agent Successfully installed!"
                LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
                # UPLOAD LOCAL LOGFILE TO SERVER
                Copy-Item $log -Destination "$serverLogs" -Force
                Exit 0
            } else {
                LogWrite -logstring "Qualys Agent installation failed."
                LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
                # UPLOAD LOCAL LOGFILE TO SERVER
                Copy-Item $log -Destination "$serverLogs" -Force
                Exit 1
            }
        }
# HEALTH CHECK (PART 4 / 4) - IF AGENT ALREADY EXISTS, REGISTRY IS HEALTHY AND AGENT IS UP-TO-DATE. RE-ENFORCE CORRECT CONFIGURATION #
        If ($proxyPAC -ne "") {
            Start-Sleep 5
            LogWrite -logstring "WHATIF: Create RegKey Path Here."
            LogWrite -logstring "WHATIF: Create Proxy PAC RegKeyValue Here."
            LogWrite -logstring "WHATIF: Restart Services Here."
        } if ($proxyURL -ne "") {
            LogWrite -logstring "WHATIF: Create RegKey Path Here."
            LogWrite -logstring "WHATIF: Create Proxy URL RegKeyValue Here."
            LogWrite -logstring "WHATIF: Restart Services Here."
        } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
            LogWrite -logstring "Proxy not specified."
        }
    }
}

LogWrite -logstring "--------------------------------- ENDED ----------------------------------"

# UPLOAD LOCAL LOGFILE TO SERVER
Copy-Item $log -Destination "$serverLogs" -Force

## END REGION ##
## SCRIPT END ##