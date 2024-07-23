param(
    [string]$DefaultUserProfilePath = "C:\Users\Default",
    [string]$HiveName = "DefaultUser"
)

# Load the Default User NTUSER.DAT file
$HivePath = "$DefaultUserProfilePath\NTUSER.DAT"
$TempHiveKey = "HKU\$HiveName"

Write-Host "Loading hive from $HivePath to $TempHiveKey"
reg.exe load $TempHiveKey $HivePath

# Confirm loading Default User NTUSER.DAT file has been successful
Test-Path "Registry::HKEY_USERS\$HiveName"

# Add registry keys to the loaded hive
$RegistryPath = "$TempHiveKey\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
#$ValueName = "OemPreInstalledAppsEnabled"
$ValueName = @(
    "OemPreInstalledAppsEnabled"
    "FeatureManagementEnabled"
    "OEMPreInstalledAppsEnabled"
    "PreInstalledAppsEnabled"
    "PreInstalledAppsEverEnabled"
    "SilentInstalledAppsEnabled"
    "SoftLandingEnabled"
    "SubscribedContentEnabled"
    "SubscribedContent-310093Enabled"
    "SubscribedContent-338387Enabled"
    "SubscribedContent-338388Enabled"
    "SubscribedContent-338389Enabled"
    "SubscribedContent-338393Enabled"
    "SubscribedContent-88000326Enabled"
    "SystemPaneSuggestionsEnabled"
)
$ValueData = "0"

$ValueName | foreach-object {
    $Name = $PSItem
    Write-Host "Adding registry key $RegistryPath\$Name with value $ValueData"
    reg.exe add $RegistryPath /v $Name /t REG_DWORD /d $ValueData /f
}
#New-Item -Path $RegistryPath -Force
#New-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -PropertyType String -Force

# Unload the hive
Write-Host "Unloading hive $TempHiveKey"
reg.exe unload $TempHiveKey

# Confirm unloading Default User NTUSER.DAT file has been successful
Test-Path "Registry::HKEY_USERS\$HiveName"

Write-Host "Registry key(s) added successfully to the Default User profile."
