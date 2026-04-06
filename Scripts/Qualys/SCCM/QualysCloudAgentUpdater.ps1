<#
.SYNOPSIS
    Script to download the latest Qualys Cloud Agent, then update a Configuration Manager application source.
.DESCRIPTION
    Downloads the latest Qualys Cloud Agent (QualysCloudAgent.exe) and saves to a provided location, then updates the content of a provided Configuration Manager application on the distribution points it's assigned to. This application can be added to a task sequence, or deployed as available or required.
#>

#Requires -Version 5.1
#Requires -Modules ConfigurationManager
#Requires -RunAsAdministrator

# Define parameters
Param (
    [Parameter(Mandatory = $true)]
    [string]$ContentLocation,
    [Parameter(Mandatory = $true)]
    [string]$AppModelName # Provide the ModelName for the application that is returned from Get-CMApplication. This is the unique value that remains constant even when the application is updated and the revision count goes up
)

$username = ""
$password = ""

# Build Basic Auth header
$pair = "$username`:$password"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$encodedCreds = [Convert]::ToBase64String($bytes)

$headers = @{
    "Authorization"    = "Basic $encodedCreds"
    "X-Requested-With" = "curl"
}

# Define download URLs (taken from Qualys documentation here: https://docs.qualys.com/en/ca/api/agents/agent_binary_download.htm)
$QualysCloudAgentURL = ""

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
$company = ""
$RegPath = "HKLM:\SOFTWARE\$company\QualysCloudAgentUpdater"

# Paths to executables (UPDATE THESE)
$ExecutablePathA = "E:\ExamplePathA\"  # Packaged version
$ExecutablePathB = "C:\ExamplePathB\"  # New version

# Executables
$Executable = "QualysCloudAgent.exe"

# executables (UPDATE THESE)
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

# Case 1: New version is NOT newer → do nothing
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

# Case 3: Already pending → decrement defer
if ($PendingUpgrade -eq 1) {

    if ($DeferUpgrade -gt 0) {
        $DeferUpgrade--
        Write-Host "Deferring upgrade. Remaining cycles: $DeferUpgrade"

        Set-RegValue -Name "DeferUpgrade" -Value $DeferUpgrade
        exit 0
    }

    # Case 4: Defer reached 0 → perform upgrade
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
        # 🔧 PLACE YOUR SCCM UPGRADE LOGIC HERE
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