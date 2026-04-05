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