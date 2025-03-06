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
        Version: 1.6.0
        Author: Aneurin Weale - VAR
        Date Created: 24/06/2024
        Last Updated: 05/03/2025
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

# Function to prune the oldest log run if maximum allowed runs are reached
function Remove-OldestLogRun {
    param(
        [string]$LogFilePath,
        [int]$MaxRuns = 4  # Maximum allowed runs in the log file
    )

    if (Test-Path $LogFilePath) {
        # Read all lines from the log file
        $lines = Get-Content $LogFilePath

        # Define a unique marker that denotes the start of a run
        $marker = "--------------------------------- START ----------------------------------"
        
        # Collect the indices where each run starts
        $runStartIndices = @()
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i].contains($marker)) {
                $runStartIndices += $i
            }
        }

        # If the number of runs is equal to or exceeds the maximum allowed,
        # remove the oldest run (i.e., everything from the first marker up to the second marker)
        if ($runStartIndices.Count -ge $MaxRuns) {
            if ($runStartIndices.Count -ge 2) {
                # The second run's start index marks where we want to keep from onward
                $secondRunIndex = $runStartIndices[1]
                $newContent = $lines[$secondRunIndex..($lines.Count - 1)]
            }
            else {
                # If there is only one marker, simply clear the file (edge-case)
                $newContent = @()
            }
            $newContent | Set-Content $LogFilePath
        }
    }
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

# Append a new run header to the log file
LogWrite -logstring "--------------------------------- START ----------------------------------"
LogWrite -logstring ""
LogWrite -logstring ""

# XML CONFIG #
# Load the XML file
if (Test-Path $Config) {
    [xml]$xmlContent = Get-Content -Path $Config
} else {
    LogWrite -logstring "[Failed] Config file not found: $Config"
    LogWrite -logstring ""
    LogWrite -logstring ""
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

function Remove-RegistryHKCRInstallerProducts {
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
            LogWrite -logstring "[Found] Registry key at: $regkeyToDelete"
            # Add the key to the deletedKeys array
            $deletedKeysHKCUInstallerProducts += $regkeyToDelete
            # Delete the registry key
            if ($DeleteRegValue -eq $TRUE) {
                Remove-Item -Path $regkeyToDelete -Recurse -Force
                if (!(Test-Path $regkeyToDelete)) {
                    LogWrite -logstring "[Deleted] Registry key at: $regkeyToDelete"
                } else {
                    LogWrite -logstring "[Failed To Delete] Registry key at: $regkeyToDelete"
                }
            }
        }
    }
    if (($deletedKeysHKCUInstallerProducts.count -eq 0) -and ($DeleteRegValue -eq $FALSE)) {
        LogWrite -logstring "[Not Found] Registry key at: $regkeyHKCUInstallerProducts"
    }
    # Return the deleted keys for use outside the function
    return $deletedKeysHKCUInstallerProducts
}

function Remove-RegistryHKCRInstallerUpgradeCodes {
    param (
        [string]$DeleteRegValue
    )
    $missingRegKey = $FALSE
    # Define the registry path
    $regkeyHKCRInstallerUpgradeCodes = "Registry::HKEY_CLASSES_ROOT\Installer\UpgradeCodes\E8A28FCD88AEAA347A4FC6F40F349D25"
    If (Test-Path $regkeyHKCRInstallerUpgradeCodes) {
        $deletedKeysHKCRInstallerUpgradeCodes = $regkeyHKCRInstallerUpgradeCodes
        LogWrite -logstring "[Found] Registry key at: $regkeyHKCRInstallerUpgradeCodes"
        # Delete the registry key
        #return $regkeyHKCRInstallerUpgradeCodes
        if ($DeleteRegValue -eq $TRUE) {
            Remove-Item -Path $regkeyHKCRInstallerUpgradeCodes -Recurse -Force
            If (!(Test-Path $regkeyHKCRInstallerUpgradeCodes)) {
                LogWrite -logstring "[Deleted] Registry key at: $regkeyHKCRInstallerUpgradeCodes"
            } else {
                LogWrite -logstring "[Failed to Delete] Registry key at: $regkeyHKCRInstallerUpgradeCodes"
            }
        }
    } else {
        $missingRegKey = $TRUE
    } if (($missingRegKey -eq $TRUE) -and ($DeleteRegValue -eq $FALSE)) {
        LogWrite -logstring "[Not Found] Registry key at: $regkeyHKCRInstallerUpgradeCodes"
    }
    return $deletedKeysHKCRInstallerUpgradeCodes
}

function Remove-RegistryUserData {
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
                LogWrite -logstring "[Found] Registry key at: $regkeyToDelete"
                # Add the key to the deletedKeys array
                $deletedKeysUserData += $regkeyToDelete
                # Delete the registry key
                if ($DeleteRegValue -eq $TRUE) {
                    Remove-Item -Path $regkeyToDelete -Recurse -Force
                    #LogWrite -logstring "[Deleted] Registry key at: $($regkeyToDelete)"
                    if (!(Test-Path $installPropertiesPath)) {
                        LogWrite -logstring "[Deleted] Registry key at: $regkeyToDelete"
                    } else {
                        LogWrite -logstring "[Failed To Delete] Registry key at: $regkeyToDelete"
                    }
                }
            }
        }
    } if (($deletedKeysUserData.count -eq 0) -and ($DeleteRegValue -eq $FALSE)) {
        LogWrite -logstring "[Not Found] Registry key at: $regkeyUserData"
    }
    # Return the deleted keys for use outside the function
    return $deletedKeysUserData
}

function Remove-RegistryQualys {
    param (
        [string]$DeleteRegValue
    )
    $missingRegKey = $FALSE
    # Define the registry path
    $registryQualys = "HKLM:\SOFTWARE\Qualys"
    If (Test-Path $registryQualys) {
        $deletedKeysRegistryQualys = $registryQualys
        LogWrite -logstring "[Found] Registry key at: HKLM:\SOFTWARE\Qualys"
        # Delete the registry key
        #return $registryQualys
        if ($DeleteRegValue -eq $TRUE) {
            Remove-Item -Path $registryQualys -Recurse -Force
            If (!(Test-Path $registryQualys)) {
                LogWrite -logstring "[Deleted] Registry key at: HKLM:\SOFTWARE\Qualys"
            } else {
                LogWrite -logstring "[Failed To Delete] Registry key at: HKLM:\SOFTWARE\Qualys"
            }
        }
    } else {
        $missingRegKey = $TRUE
    } if (($missingRegKey -eq $TRUE) -and ($DeleteRegValue -eq $FALSE)) {
        LogWrite -logstring "[Not Found] Registry key at: HKLM:\SOFTWARE\Qualys"
    }
    return $deletedKeysRegistryQualys
}

function Remove-RegistryPath {
    param (
        [string]$RegistryPath,
        [string]$DeleteRegValue,
        [string]$DisplayNameFilter = "*Qualys*"
    )
    $foundQualys = $FALSE
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
            $foundQualys = $TRUE
            # Output the key name and DisplayName
            #LogWrite -logstring "Key: $($key.PSChildName)"
            #LogWrite -logstring "DisplayName: $($productName.DisplayName)"
            # Assign the key path to a variable before deletion
            $regkeyToDelete = $fullSubKeyPath
            LogWrite -logstring "[Found] Registry key at: $regkeyToDelete"
            # Add the key to the deletedKeys array
            $deletedKeysRegistryPath += $regkeyToDelete
            # Delete the registry key
            if ($DeleteRegValue -eq $TRUE) {
                Remove-Item -Path $regkeyToDelete -Recurse -Force
                if (Test-Path "$RegistryPath\$($key.PSChildName)") {
                    LogWrite -logstring "[Deleted] Registry key at: $regkeyToDelete"
                } else {
                    LogWrite -logstring "[Failed To Delete] Registry key at: $regkeyToDelete"
                }
            }
        }
    }
    if ($foundQualys -eq $FALSE) {
        LogWrite -logstring "[Not Found] Registry key at: $RegistryPath"
    }
    # Return the deleted keys for use outside the function
    return $deletedKeysRegistryPath
}

function Remove-ServiceName {
    param (
        [string]$DeleteService
    )
    $serviceName = "QualysAgent" # Define the name of the service you want to uninstall
    $timeoutSeconds = 60 # Maximum time to wait for the service to stop
    # Confirm Service exists
    try {
        $serviceNameCatch = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    } catch [Microsoft.PowerShell.Commands.GetServiceCommand] {
        LogWrite -logstring "[Failed] Service Does Not Exist."
    } catch {
        LogWrite -logstring "[Failed] Unknown Error Occured."
    }
    if ($null -ne $serviceNameCatch) {
        LogWrite -logstring "[Found] Service: $serviceNameCatch"
        # Stop the service first (if it's running)
        LogWrite -logstring "[Verification] Checking if the Qualys Agent Service is running."
        if ($serviceNameCatch.Status -eq "Running") {
            LogWrite -logstring "[Success] Qualys Agent Service is running."
            LogWrite -logstring "[Termination] Stopping the service '$serviceName'..."
            Stop-Service -Name $serviceName -Force
        }
        # Wait for the service to stop with a timeout
        $elapsedTime = 0
        while ($elapsedTime -lt $timeoutSeconds) {
            Start-Sleep -Seconds 1
            $elapsedTime++
            $currentStatus = (Get-Service -Name $serviceName -ErrorAction SilentlyContinue).Status
            if ($currentStatus -ne "Running") {
                break
            }
        }
        # Check if the service successfully stopped
        if ((Get-Service -Name $serviceName -ErrorAction SilentlyContinue).Status -eq "Stopped") {
            LogWrite -logstring "[Success] '$serviceName' has stopped."
            if ($DeleteService -eq $TRUE) {
                LogWrite -logstring "[Action] Proceeding to delete...."
                sc.exe delete $serviceName # Uninstall the service.
                # Check if the service was successfully deleted
                if (!(Get-Service -Name $serviceName -ErrorAction SilentlyContinue)) {
                    LogWrite -logstring "[Deleted] Service: $serviceName"
                } else {
                    LogWrite -logstring "[Failed To Delete] Service: $serviceName"
                }
            }
        } else {
            LogWrite -logstring "[Failed To Terminate] '$serviceName' has failed to terminate."
            LogWrite -logstring "[Action] Exiting Script...'"
            LogWrite -logstring ""
            LogWrite -logstring ""
            LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
            exit
        }
    } else {
        LogWrite -logstring "[Not Found] Service: $serviceNameCatch"
    }
}

function Remove-ProgramFiles {
    param (
        [string]$ProgramFilesPath,
        [string]$DeleteRegValue
    )
    If (Test-Path $ProgramFilesPath) {
        LogWrite -logstring "[Found] Folder: $ProgramFilesPath"
        Remove-Item $ProgramFilesPath -Recurse -Force
        If (!(Test-Path $ProgramFilesPath)) {
            LogWrite -logstring "[Deleted] Folder: $ProgramFilesPath"
        } else {
            LogWrite -logstring "[Failed To Delete] Folder: $ProgramFilesPath"
        }
    } Else {
        LogWrite -logstring "[Not Found] Folder: $ProgramFilesPath"
    }
}

function Remove-ProgramData {
    # Path to the registry key containing the products
    $programDataPath = "$Env:ProgramData\Qualys\"
    # Get all subkeys under the base registry path
    If (Test-Path $programDataPath) {
        LogWrite -logstring "[Found] Folder: $programDataPath"
        Remove-Item $programDataPath -Recurse -Force
        If (!(Test-Path $programDataPath)) {
            LogWrite -logstring "[Deleted] Folder: $programDataPath"
        } else {
            LogWrite -logstring "[Failed To Delete] Folder: $programDataPath"
        }
    } Else {
        LogWrite -logstring "[Not Found] Folder: $programDataPath"
    }
}

function Uninstall-Agent {
    param (
        [string]$UninstallPath,
        [string]$CleanUninstall
    )
    LogWrite -logstring "[Action] Uninstalling Qualys Agent..."
    if ($cleanUninstall -eq "y") {
        start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True Force=True" -Wait
    }
    if (($cleanUninstall -eq "n") -or ($cleanUninstall -eq "")) {
        start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True" -Wait
    }
    Start-Sleep 5
    if (Test-Path $UninstallPath) {
        LogWrite -logstring "[Failed] Uninstallation failed. Performing Deep Clean..."
        LogWrite -logstring "[Action] Cleansing Qualys from Services..."
        Remove-ServiceName -DeleteService $True
        LogWrite -logstring "[Action] Cleansing Qualys from Registry..."
        Remove-RegistryQualys -DeleteRegValue $True
        Remove-RegistryHKCRInstallerProducts -DeleteRegValue $True
        Remove-RegistryHKCRInstallerUpgradeCodes -DeleteRegValue $True
        Remove-RegistryUserData -DeleteRegValue $True
        Remove-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $True
        Remove-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $True
        LogWrite -logstring "[Action] Cleansing Qualys from ProgramFiles..."
        Remove-ProgramFiles -ProgramFilesPath "$Env:ProgramFiles\Qualys"
        Remove-ProgramFiles -ProgramFilesPath "${Env:Programfiles(x86)}\Qualys"
        LogWrite -logstring "[Action] Cleansing Qualys from ProgramData..."
        Remove-ProgramData
        LogWrite -logstring "[Action] Cleanup complete."
        LogWrite -logstring "[Action] All traces of Qualys have been removed."
        if (Test-Path $UninstallPath) {
            LogWrite -logstring "[Failed] Uninstallation failed. Manual investigation recommended."
            LogWrite -logstring "[Information] Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured."
            LogWrite -logstring "[Information] Please re-run the script again once manual investigation is done."
            LogWrite -logstring "[Action] Exiting script..."
            LogWrite -logstring ""
            LogWrite -logstring ""
            LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
            # UPLOAD LOCAL LOGFILE TO SERVER
            Copy-Item $log -Destination "$serverLogs" -Force
            Exit 1
        }
    } else {
        LogWrite -logstring "[Failed] Uninstallation successful."
    }
}

function Update-Agent {
    param (
        [string]$UninstallPath,
        [string]$CleanUninstall
    )
    $AgentUpdated = 0
    LogWrite -logstring "[Verification] Comparing Locally Installed Qualys Agent with Available Qualys Agent Installer..."
    $installedVersion = (Get-Item $UninstallPath).VersionInfo.FileVersionRaw # This detects the currently installed version on the local device under Program Files.
    $serverVersion = (Get-Item $serverInstaller).VersionInfo.FileVersionRaw # This detects the remote installer version.
    # Used for troubleshooting. Good way to confirm what versions have been detected.
    LogWrite -logstring "[Found] Locally Installed Version: $installedVersion"
    LogWrite -logstring "[Found] Available Version: $serverVersion"
    if ($installedVersion -lt $serverVersion) {
        LogWrite -logstring "[Information] Qualys Agent on local device is an older version than the packaged Qualys Agent."
        LogWrite -logstring "[Action] Uninstalling older version..."
        if ($cleanUninstall -eq "y") {
            start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True Force=True" -Wait
        }
        if (($cleanUninstall -eq "n") -or ($cleanUninstall -eq "")) {
            start-process -FilePath $UninstallPath -ArgumentList "Uninstall=True" -Wait
        }
        Start-Sleep 5
        if (Test-Path $UninstallPath) {
            LogWrite -logstring "[Failed] Uninstallation failed. Manual investigation recommended."
            LogWrite -logstring "[Information] Qualys Cloud Security Agent is either in the process of being updated or an unknown issue occured."
            LogWrite -logstring "[Information] Please re-run the script again once manual investigation is done."
            LogWrite -logstring "[Action] Exiting script..."
            LogWrite -logstring ""
            LogWrite -logstring ""
            LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
            # UPLOAD LOCAL LOGFILE TO SERVER
            Copy-Item $log -Destination "$serverLogs" -Force
            Exit 1
        } else {
            LogWrite -logstring "[Failed] Uninstallation successful."
            LogWrite -logstring "[Action] Downloading Qualys Agent to local directory..."
            Copy-Item $serverInstaller -Destination "C:\QualysClientHealth\Installer" -Force
            LogWrite -logstring "[Action] Installing Qualys Agent version: $serverVersion..."
            start-process -FilePath "C:\QualysClientHealth\Installer\QualysCloudAgent.exe" -ArgumentList "CustomerID=$customerID ActivationID=$activationID WebServiceUri=$webServiceUri" -wait
            Start-Sleep 5
            if ((Test-Path $uninstallx64) -or (Test-Path $uninstallx86)) {
                LogWrite -logstring "[Success] Qualys Agent Successfully installed!"
                LogWrite -logstring "[Action] Configuring Proxy..."
                If ($proxyPAC -ne "") {
                    New-Item $regkeyProxy -Force
                    New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxyPAC -PropertyType "String" -Force
                    Restart-Service -Name "Qualys Cloud Agent"
                    LogWrite -logstring "[Success] Proxy Configured."
                } if ($proxyURL -ne "") {
                    New-Item $regkeyProxy -Force
                    New-ItemProperty $regkeyProxy -Name "URL" -Value $proxyURL -PropertyType "String" -Force
                    Restart-Service -Name "Qualys Cloud Agent"
                    LogWrite -logstring "[Success] Proxy Configured."
                } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
                    LogWrite -logstring "[Action] Proxy not specified. No Actions Taken"
                }
                $AgentUpdated = 1
            } else {
                LogWrite -logstring "[Failed] Qualys Agent installation failed."
                $AgentUpdated = 0
            }
        }
    } else {
        LogWrite -logstring "[Action] Locally Installed version already is up-to-date or newer. No action taken."
        $AgentUpdated = 0
    }
    return $AgentUpdated
}

function Install-Agent {
    LogWrite -logstring "[Verification] Checking if Qualys Agent Installer exists locally..."
    if (!(Test-Path "C:\QualysClientHealth\Installer\QualysCloudAgent.exe")) {
        LogWrite -logstring "[Action] Qualys Agent Installer Not Detected. Downloading Installer..."
        Copy-Item $serverInstaller -Destination "C:\QualysClientHealth\Installer" -Force
    }
    $serverVersion = (Get-Item $serverInstaller).VersionInfo.FileVersionRaw # This detects the remote installer version.
    LogWrite -logstring "[Installation] Installing Qualys Agent version: $serverVersion..."
    start-process -FilePath "C:\QualysClientHealth\Installer\QualysCloudAgent.exe" -ArgumentList "CustomerID=$customerID ActivationID=$activationID WebServiceUri=$webServiceUri" -wait
    Start-Sleep 5
    if ((Test-Path $uninstallx64) -or (Test-Path $uninstallx86)) {
        LogWrite -logstring "[Installed] Qualys Agent Successfully installed!"
        LogWrite -logstring "[Configuration] Configuring Proxy..."
        If ($proxyPAC -ne "") {
            New-Item $regkeyProxy -Force
            New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxyPAC -PropertyType "String" -Force
            Restart-Service -Name "Qualys Cloud Agent"
            LogWrite -logstring "[Configured] Proxy Configured."
        } if ($proxyURL -ne "") {
            New-Item $regkeyProxy -Force
            New-ItemProperty $regkeyProxy -Name "URL" -Value $proxyURL -PropertyType "String" -Force
            Restart-Service -Name "Qualys Cloud Agent"
            LogWrite -logstring "[Configured] Proxy Configured."
        } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
            LogWrite -logstring "[Action] Proxy not specified. No Actions Taken"
        }
        LogWrite -logstring ""
        LogWrite -logstring ""
        LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
        # UPLOAD LOCAL LOGFILE TO SERVER
        Copy-Item $log -Destination "$serverLogs" -Force
        Exit 0
    } else {
        LogWrite -logstring "[Failed To Install] Failed to install Qualys Agent."
        LogWrite -logstring ""
        LogWrite -logstring ""
        LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
        # UPLOAD LOCAL LOGFILE TO SERVER
        Copy-Item $log -Destination "$serverLogs" -Force
        Exit 1
    }
}
## FUNCTIONS - END REGION ##

## REGION SYSTEM ADMINISTRATOR CHECK ##
LogWrite -logstring "[HEALTH CHECK (PART 0 / 4)] PRE-REQUISITES."
LogWrite -logstring "[Verification] Checking user identity."
$user = [Security.Principal.WindowsIdentity]::GetCurrent(); #Grabs current PowerShell sessions user identity.
$isSystem = ($user).IsSystem #Checks if current PowerShell session is SYSTEM Admin.

If ($isSystem -eq $TRUE) {

    LogWrite -logstring "[Success] Required Privilages Met."

}
Else {

    LogWrite -logstring "[Failed] Script cannot run properly without the correct user identity."

}
## END REGION ##

## MAIN LOGIC - REGION START ##
# VARIABLES #
$qualysCloudAgent = "QualysAgent.exe"
$uninstaller = "Uninstall.exe"
$programFilesx64 = "$Env:Programfiles\Qualys\QualysAgent"
$programFilesx86 = "${Env:Programfiles(x86)}\Qualys\QualysAgent"
$uninstallx64 = "$programFilesx64\$uninstaller"
$uninstallx86 = "$programFilesx86\$uninstaller"
$qualysCloudAgentx64 = "$programFilesx64\$qualysCloudAgent"
$qualysCloudAgentx86 = "$programFilesx86\$qualysCloudAgent"
$regkeyProxy = "HKLM:\SOFTWARE\Qualys\Proxy"

if (!($whatIF -eq "y")) {
# HEALTH CHECK (PART 1 / 4) - IF AGENT DOES NOT ALREADY EXISTS. CLEAN INSTALL #
    LogWrite -logstring ""
    LogWrite -logstring "[HEALTH CHECK (PART 1 / 4)] Application Discovery."
    LogWrite -logstring "[Verification] Checking if Qualys Agent is already installed..."
    if ((!(Test-Path $qualysCloudAgentx64) -and !(Test-Path $qualysCloudAgentx86))) {
        LogWrite -logstring "[Information] QualysAgent.exe not detected."
        LogWrite -logstring "[Action] Skipping uninstall..."
        LogWrite -logstring "[Action] Running cleanup..."
        LogWrite -logstring "[Action] Cleansing Qualys from Services..."
        Remove-ServiceName -DeleteService $True
        LogWrite -logstring "[Action] Cleansing Qualys from Registry..."
        Remove-RegistryQualys -DeleteRegValue $True
        Remove-RegistryHKCRInstallerProducts -DeleteRegValue $True
        Remove-RegistryHKCRInstallerUpgradeCodes -DeleteRegValue $True
        Remove-RegistryUserData -DeleteRegValue $True
        Remove-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $True
        Remove-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $True
        LogWrite -logstring "[Action] Cleansing Qualys from ProgramData..."
        Remove-ProgramData
        LogWrite -logstring "[Success] Cleanup complete."
        LogWrite -logstring "[Success] All traces of Qualys have been removed."
        LogWrite -logstring "[Action] Running Install-Agent..."
        Install-Agent
    } else {
# HEALTH CHECK (PART 2 / 4) - IF AGENT ALREADY EXISTS, BUT REGISTRY IS UNHEALTHY. CLEAN INSTALL #
        LogWrite -logstring "[Action] Qualys Agent Already Installed. Initiating Next Health Check."
        LogWrite -logstring ""
        LogWrite -logstring "[HEALTH CHECK (PART 2 / 4)] Application Health."
        LogWrite -logstring "[Verification] Checking Registry Health..."
        # Flag to determine if any key does not exist
        $anyKeyMissing = $false
        # List of registry keys to check and potentially delete
        $regKeys = @(
        )
        $deletedKeysRegistryQualys = Remove-RegistryQualys -DeleteRegValue $False # Run Function to obtain a value
        if ($deletedKeysRegistryQualys) { # If value returns, proceed with next steps
            $regKeys += $deletedKeysRegistryQualys # Add value to array. This suggests a regkey is found.
        } else { # If value is null, proceed with next steps
            $anyKeyMissing = $True # As no value returned, this suggests a regkey is missing. So update $anyKeyMissing to True.
        }
        $deletedKeysHKCRInstallerProducts = Remove-RegistryHKCRInstallerProducts -DeleteRegValue $False
        if ($deletedKeysHKCRInstallerProducts) {
            $regKeys += $deletedKeysHKCRInstallerProducts
        } else {
            $anyKeyMissing = $True
        }
        $deletedKeysHKCRInstallerUpgradeCodes = Remove-RegistryHKCRInstallerUpgradeCodes -DeleteRegValue $False
        if ($deletedKeysHKCRInstallerUpgradeCodes) {
            $regKeys += $deletedKeysHKCRInstallerUpgradeCodes
        } else {
            $anyKeyMissing = $True
        }
        $deletedKeysUserData = Remove-RegistryUserData -DeleteRegValue $False
        if ($deletedKeysUserData) {
            $regKeys += $deletedKeysUserData
        } else {
            $anyKeyMissing = $True
        }
        # Next couple of checks needs to be handled differently.
        # If both regkeys are missing, then $anyKeyMissing is True. If at least one of these have been found, then ignore.
        # This is to be changed in a future patch to address the possibility of Both RegKeys existing at the same time.
        $x = 0
        $deletedKeysRegistryPath = Remove-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $False
        if ($deletedKeysRegistryPath) {
            $regKeys += $deletedKeysRegistryPath
        } else {
            LogWrite -logstring "[Information] No Qualys Registry key(s) exists under: HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
            $x += 1
        }
        $deletedKeysRegistryPath = Remove-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $False
        if ($deletedKeysRegistryPath) {
            $regKeys += $deletedKeysRegistryPath
        } else {
            if ($x -eq 1) {
                LogWrite -logstring "[Information] No Qualys Registry key(s) exists under: HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
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
                    $anyKeyMissing = $True
                    break
                }
            }
        }
        # If any key is missing, delete all keys in the list
        if ($anyKeyMissing) {
            if (Test-Path $uninstallx64) {
                # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
                LogWrite -logstring "[Information] Detected that QualysAgent.exe is already installed, but Registry is unhealthy."
                LogWrite -logstring "[Information] QualysAgent.exe must be reinstalled to fix Registry issues."
                LogWrite -logstring "[Action] Running Uninstall-Agent..."
                Uninstall-Agent -UninstallPath $uninstallx64 -CleanUninstall "y"
                LogWrite -logstring "[Success] Uninstall-Agent completed."
            }
            # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
            if (Test-Path $uninstallx86) {
                LogWrite -logstring "[Information] Detected that QualysAgent.exe is already installed, but Registry is unhealthy."
                LogWrite -logstring "[Information] QualysAgent.exe must be reinstalled to fix Registry issues."
                LogWrite -logstring "[Action] Running Uninstall-Agent..."
                Uninstall-Agent -UninstallPath $uninstallx86 -CleanUninstall "y"
                LogWrite -logstring "[Success] Uninstall-Agent completed."
            }
            LogWrite -logstring "[Action] Running Install-Agent..."
            Install-Agent
        } else {
# HEALTH CHECK (PART 3 / 4) - IF AGENT ALREADY EXISTS AND REGISTRY IS HEALTHY. CHECK IF UPGRADE IS REQUIRED #
            LogWrite -logstring "[Action] Qualys Agent already installed and Registry is Healthy. Initiating Next Health Check."
            LogWrite -logstring ""
            LogWrite -logstring "[HEALTH CHECK (PART 3 / 4)] Updates."
            LogWrite -logstring "[Verification] Checking if Qualys Agent Update is required..."
            if (Test-Path $uninstallx64) {
                # Checks to see if Qualys Agent Exists in Program Files. If detected then uninstall.
                LogWrite -logstring "[Action] Running Update-Agent..."
                $AgentUpdated = Update-Agent -UninstallPath $uninstallx64 -CleanUninstall $cleanUninstall
                LogWrite -logstring "[Action] Update-Agent completed."
            }
            # Checks to see if Qualys Agent Exists in Program Files(x86). If detected then uninstall.
            if (Test-Path $uninstallx86) {
                LogWrite -logstring "[Action] Running Update-Agent..."
                $AgentUpdated = Update-Agent -UninstallPath $uninstallx86 -CleanUninstall $cleanUninstall
                LogWrite -logstring "[Action] Update-Agent completed."
            }
# HEALTH CHECK (PART 4 / 4) - IF AGENT ALREADY EXISTS, REGISTRY IS HEALTHY AND AGENT IS UP-TO-DATE. RE-ENFORCE CORRECT CONFIGURATION #
            LogWrite -logstring "[Action] Qualys Agent already installed, Registry is Healthy, and Qualys Agent is up-to-date. Initiating Next Health Check."
            LogWrite -logstring ""
            LogWrite -logstring "[HEALTH CHECK (PART 4 / 4)] Proxy Configuration."
            If ($AgentUpdated -eq 0) {
                LogWrite -logstring "[Verification] Checking Proxy Configuration..."
                If ($proxyPAC -ne "") {
                    Start-Sleep 5
                    New-Item $regkeyProxy -Force
                    New-ItemProperty $regkeyProxy -Name "PACFileURL" -Value $proxyPAC -PropertyType "String" -Force
                    Restart-Service -Name "Qualys Cloud Agent"
                    LogWrite -logstring "[Success] Proxy Configured."
                } if ($proxyURL -ne "") {
                    Start-Sleep 5
                    New-Item $regkeyProxy -Force
                    New-ItemProperty $regkeyProxy -Name "URL" -Value $proxyURL -PropertyType "String" -Force
                    Restart-Service -Name "Qualys Cloud Agent"
                    LogWrite -logstring "[Success] Proxy Configured."
                } if (($proxyPAC -eq "") -and ($proxyURL -eq "")) {
                    LogWrite -logstring "[Action] Proxy not specified. No Actions Taken."
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
        LogWrite -logstring "WHATIF: Function 'Remove-RegistryQualys' would run here"
        LogWrite -logstring "WHATIF: Function 'Remove-RegistryHKCRInstallerProducts' would run here"
        LogWrite -logstring "WHATIF: Function 'Remove-RegistryHKCRInstallerUpgradeCodes' would run here"
        LogWrite -logstring "WHATIF: Function 'Remove-RegistryUserData' would run here"
        LogWrite -logstring "WHATIF: Function 'Remove-RegistryPath' would run here"
        LogWrite -logstring "WHATIF: Function 'Remove-RegistryPath' would run here"
        LogWrite -logstring "Cleansing Qualys from Services..."
        LogWrite -logstring "WHATIF: Function 'Remove-ServiceName' would run here"
        LogWrite -logstring "Cleansing Qualys from ProgramData..."
        LogWrite -logstring "WHATIF: Function 'Remove-ProgramData' would run here"
        LogWrite -logstring "Cleanup complete."
        LogWrite -logstring "All traces of Qualys have been removed."
        LogWrite -logstring "Installing Qualys Agent..."
        LogWrite -logstring "WHATIF: Function 'Install-Agent' would run here"
        LogWrite -logstring ""
        LogWrite -logstring ""
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
        $deletedKeysHKCRInstallerProducts = Remove-RegistryHKCRInstallerProducts -DeleteRegValue $False
        $regKeys += $deletedKeysHKCRInstallerProducts
        $deletedKeysHKCRInstallerUpgradeCodes = Remove-RegistryHKCRInstallerUpgradeCodes -DeleteRegValue $False
        $regKeys += $deletedKeysHKCRInstallerUpgradeCodes
        $deletedKeysUserData = Remove-RegistryUserData -DeleteRegValue $False
        $regKeys += $deletedKeysUserData
        $deletedKeysRegistryPath = Remove-RegistryPath -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $False
        $regKeys += $deletedKeysRegistryPath
        $deletedKeysRegistryPath = Remove-RegistryPath -RegistryPath "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DeleteRegValue $False
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
                LogWrite -logstring ""
                LogWrite -logstring ""
                LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
                # UPLOAD LOCAL LOGFILE TO SERVER
                Copy-Item $log -Destination "$serverLogs" -Force
                Exit 0
            } else {
                LogWrite -logstring "Qualys Agent installation failed."
                LogWrite -logstring ""
                LogWrite -logstring ""
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
                LogWrite -logstring ""
                LogWrite -logstring ""
                LogWrite -logstring "--------------------------------- ENDED ----------------------------------"
                # UPLOAD LOCAL LOGFILE TO SERVER
                Copy-Item $log -Destination "$serverLogs" -Force
                Exit 0
            } else {
                LogWrite -logstring "Qualys Agent installation failed."
                LogWrite -logstring ""
                LogWrite -logstring ""
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

LogWrite -logstring ""
LogWrite -logstring ""
LogWrite -logstring "--------------------------------- ENDED ----------------------------------"

$logDir = Split-Path $log
if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Prune the log file if maximum runs are already present
Remove-OldestLogRun -LogFilePath $log -MaxRuns 5

# UPLOAD LOCAL LOGFILE TO SERVER
Copy-Item $log -Destination "$serverLogs" -Force

## END REGION ##
## SCRIPT END ##