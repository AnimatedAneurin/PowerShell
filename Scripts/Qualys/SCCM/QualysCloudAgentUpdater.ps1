#REQUIRES -Version 5.1
#REQUIRES -Modules ConfigurationManager
#REQUIRES -RunAsAdministrator

<#
.SYNOPSIS
    Downloads the latest Qualys Cloud Agent and updates the content source of a Configuration Manager application.
.DESCRIPTION
    Downloads the latest Qualys Cloud Agent installer (QualysCloudAgent.exe),
    then updates the associated Microsoft Configuration Manager application content on its assigned distribution points.

    The application can then be used in task sequences or deployed as Available or Required.
.PARAMETER appModelName
    Specifies the ModelName of the Configuration Manager application.

    The ModelName is a unique identifier that remains unchanged even when the application revision is updated.
    To find the ModelName of an application:

        - Open PowerShell ISE from the Configuration Manager console.
            - A script will automatically be generated to import the ConfigurationManager module.
            - Run the generated script to connect to your Configuration Manager environment.
        - Once connected to your Configuration Manager environment, run the following:
            - Get-CMApplication -Name "[Application Package Name]"
        - The ModelName value will be displayed in the results.
.PARAMETER contentLocation
    Specifies the content source location of the Configuration Manager application.
    UNC paths are supported.
.PARAMETER company
    Specifies the company responsible for supporting and maintaining the Configuration Manager application package.
    A registry key is created locally on the device running this script.
    This is used to track upgrade delay information.
.PARAMETER username
    Specifies the username of the Qualys service account.
    Primarily used to authenticate and download the latest Qualys Cloud Agent installer.
.PARAMETER password
    Specifies the password of the Qualys service account.
    Primarily used to authenticate and download the latest Qualys Cloud Agent installer.
.PARAMETER qualysCloudAgentURL
    Specifies the Qualys API download URL for the Qualys Cloud Agent binaries.
.PARAMETER executableA
    Specifies the path to the existing packaged Qualys Cloud Agent executable.
.PARAMETER executableB
    Specifies the path where the newly downloaded Qualys Cloud Agent executable will be saved.
    This will replace the existing packaged Qualys Cloud Agent.
.EXAMPLE
    PS> QualysCloudAgentUpdater.ps1 -AppModelName ScopeId_45E2DE75-5715-4A99-800D-41D27C288969/Application_ef4d8348-18aa-4a22-a6fb-601d479adafc -ContentLocation "\\server01\sccmsource$\Applications\Qualys Cloud Agent" -company Qualys -username username -password password -qualysCloudAgentURL https:// -executableA "\\server01\sccmsource$\Applications\Qualys Cloud Agent\QualysCloudAgent.exe" -executableB "C:\Temp\QualysCloudAgent.exe"
.INPUTS
    Accepts a Single String for:
    -appModelName
    -contentLocation
    -company
    -username
    -password
    -qualysCloudAgentURL
    -executableA
    -executableB
.OUTPUTS
    This command produces no output.
.NOTES
    Name: QualysCloudAgentUpdater.ps1
    Version: 1.1.0
    Author: Aneurin Weale - VAR
    Date Created: 06/04/2026
    Last Updated: 18/05/2026
.LINK
    https://github.com/AnimatedAneurin/PowerShell/blob/PowerShell/Scripts/Qualys/SCCM/QualysCloudAgentUpdater.ps1
#>

#! It is reccommended that you do not modify the code below as this is designed to be fully automated.

# Define parameters
Param (
    [Parameter(Mandatory = $true)]
    [string]$AppModelName, # Provide the ModelName for the application that is returned from Get-CMApplication. This is the unique value that remains constant even when the application is updated and the revision count goes up
    [Parameter(Mandatory = $true)]
    [string]$ContentLocation,
    [Parameter(Mandatory = $true)]
    [string]$company,
    [Parameter(Mandatory = $true)]
    [string]$username,
    [Parameter(Mandatory = $true)]
    [string]$password,
    [Parameter(Mandatory = $true)]
    [string]$QualysCloudAgentURL, # Define download URLs (taken from Qualys documentation here: https://docs.qualys.com/en/ca/api/agents/agent_binary_download.htm)
    [Parameter(Mandatory = $true)]
    [string]$ExecutableA, # Packaged version
    [Parameter(Mandatory = $true)]
    [string]$ExecutableB # New version
)

# Build Basic Auth header
$pair = "$username`:$password"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$encodedCreds = [Convert]::ToBase64String($bytes)

$headers = @{
    "Authorization"    = "Basic $encodedCreds"
    "X-Requested-With" = "curl"
}

# Create C:\Temp directory if it doesn't exist
If (-not (Test-Path -Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null
}

# Download the files to C:\Temp first to confirm the downloads complete successfully
$xmlPath = "C:\Temp\binaries.xml"
$body = Get-Content $xmlPath -Raw
$TempQualysCloudAgentPath = Join-Path -Path "C:\Temp" -ChildPath "QualysCloudAgent.exe"
Try {
    Invoke-WebRequest -Uri $QualysCloudAgentURL -Method POST -Headers $headers -Body $body -ContentType "text/xml" -OutFile $TempQualysCloudAgentPath -UseBasicParsing -ErrorAction Stop
} Catch {
    # If this fails try adding TLS 1.2 support and try again, as the Microsoft CDN may require this
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Try {
        Invoke-WebRequest -Uri $QualysCloudAgentURL -Method POST -Headers $headers -Body $body -ContentType "text/xml" -OutFile $TempQualysCloudAgentPath -UseBasicParsing -ErrorAction Stop
    } Catch {
        Write-Verbose -Message "Error downloading files with TLS 1.2 enabled: $_"
        Exit 1
    }
}

# Config
$RegPath = "HKLM:\SOFTWARE\$company\QualysCloudAgentUpdater"

# Executables
$Executable = "QualysCloudAgent.exe"

# executables
$ExecutableA = "$ExecutablePathA$Executable"  # Packaged version
$ExecutableB = "$ExecutablePathB$Executable"  # New version

#endregion

#region: Ensure Registry Path Exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}
#endregion

#region: Helper Functions
function Get-FileVersion {
    param ($Path)

    if (Test-Path $Path) {
        return [version](Get-Item $Path).VersionInfo.FileVersion
    } else {
        Write-Host "File not found: $Path"
        return $null
    }
}

function Get-RegValue {
    param ($Name)

    try {
        return Get-ItemProperty -Path $RegPath -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    } catch {
        return $null
    }
}

function Set-RegValue {
    param ($Name, $Value)

    New-ItemProperty -Path $RegPath -Name $Name -Value $Value -PropertyType String -Force | Out-Null
}
#endregion

#region: Get Versions
$PackagedVersion = Get-FileVersion -Path $ExecutableA
$NewVersion      = Get-FileVersion -Path $ExecutableB

if (-not $PackagedVersion -or -not $NewVersion) {
    Write-Host "Version check failed. Exiting."
    exit 1
}

# Store versions in registry
Set-RegValue -Name "PackagedVersion" -Value $PackagedVersion.ToString()
Set-RegValue -Name "NewVersion" -Value $NewVersion.ToString()
#endregion

#region: Get Existing State
$PendingUpgrade = Get-RegValue -Name "PendingUpgrade"
$DeferUpgrade   = Get-RegValue -Name "DeferUpgrade"

if ($null -eq $PendingUpgrade) { $PendingUpgrade = 0 }
if ($null -eq $DeferUpgrade)   { $DeferUpgrade   = 0 }

$PendingUpgrade = [int]$PendingUpgrade
$DeferUpgrade   = [int]$DeferUpgrade
#endregion

#region: Logic

# Case 1: New version is NOT newer > do nothing
if ($NewVersion -le $PackagedVersion) {
    Write-Host "No upgrade required."
    exit 0
}

# Case 2: New version detected for first time
if ($PendingUpgrade -eq 0) {
    Write-Host "New version detected. Starting defer cycle."

    Set-RegValue -Name "PendingUpgrade" -Value 1
    Set-RegValue -Name "DeferUpgrade" -Value 3

    exit 0
}

# Case 3: Already pending > decrement defer
if ($PendingUpgrade -eq 1) {

    if ($DeferUpgrade -gt 0) {
        $DeferUpgrade--
        Write-Host "Deferring upgrade. Remaining cycles: $DeferUpgrade"

        Set-RegValue -Name "DeferUpgrade" -Value $DeferUpgrade
        exit 0
    }

    # Case 4: Defer reached 0 > perform upgrade
    if ($DeferUpgrade -le 0) {
        Write-Host "Defer expired. Performing upgrade..."

        # Copy the downloaded files to the Configuration Manager source folder, overwriting existing files
        $DestinationQualysCloudAgentPath = Join-Path -Path $ContentLocation -ChildPath "QualysCloudAgent.exe"
        Try {
            Copy-Item -Path $TempQualysCloudAgentPath -Destination $DestinationQualysCloudAgentPath -Force -ErrorAction Stop
        } Catch {
            Write-Verbose -Message "Error copying files to Configuration Manager source folder: $_"
            Exit 1
        }

        # Get file version for later
        $QualysCloudAgentVersion = (Get-Item $DestinationQualysCloudAgentPath).VersionInfo.FileVersion

        # Clean up temporary files from C:\Temp
        Remove-Item -Path $TempQualysCloudAgentPath -Force -ErrorAction SilentlyContinue

        # Connect to the Configuration Manager site
        Try {
            Import-Module "$($env:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" -ErrorAction Stop
            $SiteCode = (Get-PSDrive -PSProvider CMSite).Name
            Set-Location "$SiteCode`:"
        } Catch {
            Write-Verbose -Message "Error connecting to Configuration Manager site: $_"
            Exit 1
        }

        # Check the provided application ID exists in Configuration Manager
        $App = Get-CMApplication -ModelName $AppModelName
        If ($null -eq $App) {
            Write-Verbose -Message "Configuration Manager application '$AppModelName' not found."
            Exit 1
        }

        # Update the application with the new version number
        Set-CMApplication -InputObject $App -SoftwareVersion $QualysCloudAgentVersion -NewName "Qualys_Cloud_Agent_x64_$QualysCloudAgentVersion" -Description "$(Get-Date -Format 'yyyy-MM-dd') - Updated by VAR automation script. Qualys Cloud Agent has been updated to version $QualysCloudAgentVersion."

        # Create a File Detection Type
        $detectionFileName = "QualysAgent.exe"
        $DetectionFilePath = "C:\Program Files\Qualys\QualysAgent\"
        $DetectionTypeUpdate = New-CMDetectionClauseFile -FileName $detectionFileName -Path $DetectionFilePath -PropertyType Version -ExpressionOperator GreaterEquals -ExpectedValue $QualysCloudAgentVersion -Value

        # Get existing Detection Method from App (This was hard)
        # This requires you know the Logical Name of the App (Which the only way I could find was burried in XML)
        $CMDeploymentType = get-CMDeploymentType -ApplicationName $app.LocalizedDisplayName
        [XML]$AppDTXML = $CMDeploymentType.SDMPackageXML
        [XML]$AppDTDXML = $AppDTXML.AppMgmtDigest.DeploymentType.Installer.DetectAction.args.Arg[1].'#text'
        $DetectionMethods = $AppDTDXML.EnhancedDetectionMethod.Settings.File
        $ExistingLogicalNames = ($DetectionMethods | Where-Object {$_.Filter -eq $detectionFileName}).LogicalName

        $Rules = $AppDTDXML.EnhancedDetectionMethod.Rule

        $MatchedRule = $Rules | Where-Object {
            $_.Expression.Operands.SettingReference.SettingLogicalName -in $ExistingLogicalNames
        }

        $Operator = $MatchedRule.Expression.Operator

        $Value = $MatchedRule.Expression.Operands.ConstantValue.Value

        if ($QualysCloudAgentVersion -ne $Value) {
            # Add Detection Method to AppDT
            Get-CMDeploymentType -ApplicationName $app.LocalizedDisplayName | Set-CMScriptDeploymentType -AddDetectionClause $DetectionTypeUpdate

            # Remove previous Detection Method(s) from AppDT
            Get-CMDeploymentType -ApplicationName $app.LocalizedDisplayName | Set-CMScriptDeploymentType -RemoveDetectionClause $ExistingLogicalNames
        }

        if ("GreaterEquals" -ne $Operator) {
            # Add Detection Method to AppDT
            Get-CMDeploymentType -ApplicationName $app.LocalizedDisplayName | Set-CMScriptDeploymentType -AddDetectionClause $DetectionTypeUpdate

            # Remove previous Detection Method(s) from AppDT
            Get-CMDeploymentType -ApplicationName $app.LocalizedDisplayName | Set-CMScriptDeploymentType -RemoveDetectionClause $ExistingLogicalNames
        }

        # Update the Configuration Manager application content, first getting the app object again to ensure it's up to date and then using this with Update-CMDistributionPoint
        Try {
            $App = Get-CMApplication -ModelName $AppModelName
            $DeploymentType = $App | Get-CMDeploymentType
            Update-CMDistributionPoint -ApplicationName $App.LocalizedDisplayName -DeploymentTypeName $DeploymentType.LocalizedDisplayName
        } Catch {
            Write-Verbose -Message "Error updating Configuration Manager distribution points: $_"
            Exit 1
        }
        # PLACE YOUR SCCM UPGRADE LOGIC HERE
        # Example:
        # Start-Process -FilePath "C:\Path\To\Installer.exe" -ArgumentList "/silent" -Wait

        # After successful upgrade:
        Set-RegValue -Name "PendingUpgrade" -Value 0
        Set-RegValue -Name "PackagedVersion" -Value $NewVersion.ToString()
        Set-RegValue -Name "DeferUpgrade" -Value 0

        Write-Host "Upgrade completed successfully."
        exit 0
    }
}

#endregion