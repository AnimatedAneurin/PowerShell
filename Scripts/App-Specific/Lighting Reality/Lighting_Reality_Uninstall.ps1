<#
.SYNOPSIS
    Lighting Reality Uninstall.
.DESCRIPTION
    This script is to uninstall Lighting Reality and Lighting Reality Reader by modifying a RegKey Property Value to allow uninstallation to take place,
    to which the uninstaller(s) removes both applications and then the RegKey Property Value is reverted back to it's default value.
    On top of this, the script will remove any cached data containing the License information so that users have to enter the License Key upon reinstallation.
    This script also makes use of Generating logs and it's own error code system.
.NOTES
    Name: Lighting Reality Uninstall
    Version: 1.0
    Author: Aneurin Weale - DLM
    Date Created: 25/05/2023
    Last Updated: 25/05/2023
    URL: https://github.com/AnimatedAneurin/PowerShell/blob/PowerShell/Scripts/App-Specific/Lighting%20Reality/Lighting_Reality_Uninstall.ps1
#>

## SCRIPT START ##

## LOGGING SYSTEM ##
Function LogWrite { #This function allows us to replace all 'Write-Host' commands to 'LogWrite' commands. This means instead of outputting text to the terminal, it'll output to a log file instead.
    #Function to create a log file in the current directory.
    Param ([string]$logstring)
    Add-Content "C:\DLM\uninstallLR.log" -value "$(Get-Date -UFormat %Y%m%d-%H:%M:%S) - $($logstring)"
    #20190717-12:07:40 - Example
}
## LOGGING SYSTEM END ##

LogWrite -logstring "--------------------------------- START ----------------------------------"

## REGION ADMINISTRATOR CHECK ##
$user = [Security.Principal.WindowsIdentity]::GetCurrent(); #Grabs current PowerShell sessions user identity.
$Role = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) #Checks if current PowerShell session is an Admin.
If ($Role -eq $TRUE) {

    LogWrite "Required Privilages Met."

}
Else {

    LogWrite "Error: Script cannot run correctly without correct privilage escalation."
    Logwrite "Exiting Script..."
    LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
    Exit

}
## END REGION ##

## VARIABLES ##
$LightingRealityUninstall = "C:\Program Files (x86)\Lighting Reality\unins000.exe" #The uninstaller for Lighting Reality
$LightingRealityReaderUninstall = "C:\Program Files\Softland\novaPDF 7\unins000.exe" #The Uninstaller for Lighting Reality Reader
$CryptoSignature="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" #The RegKey that prevents Uninstallation.

$configManagerCycles = @(
    "{00000000-0000-0000-0000-000000000021}" #Machine Policy Retrieval Cycle
    "{00000000-0000-0000-0000-000000000022}" #Machine Policy Evaluation Cycle
    "{00000000-0000-0000-0000-000000000121}" #Application Deployment Evaluation Cycle
)

$ErrorCode = 0 #To keep track of Errors
$SuccessfulUninstallCount = 0 #To keep track of Successful Uninstalls
## VARIABLES END ##

## FUNCTIONS ##
function Test-RegistryValue {
    param (
        [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]$Value
    )
    try{
        if( (Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop) -eq 0 ){
            return  $true
        }
        return $false
    }
    catch{
        return  $true
    }
}
function Test-RegistryProperty {
    param (
        [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]$Value
    )
    try{
        if( (Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value) -eq 0 ){
            return  $true
        }
        return $false
    }
    catch{
        return  $true
    }
}

Function LightingReality { #If App(s) was detected, then the below will run.

    LogWrite "Application Detected."
    #Create RegKey using $CryptoSignature (A RegKey is a folder within the registry)
    $testkey = Test-path $CryptoSignature
    if(!$testkey){
        LogWrite "Creating RegKey."
        New-Item -Path $CryptoSignature -Force | Out-Null
    }

    #Create The RegKey property "ValidateAdminCodeSignatures" with value 0
    $testentry= Test-RegistryValue -Path $CryptoSignature -Value "ValidateAdminCodeSignatures"
    if(!$testentry){
        LogWrite "Creating RegKey Property."
        New-ItemProperty -PropertyType DWORD -Path $CryptoSignature -Name "ValidateAdminCodeSignatures" -Value 0  -Force | Out-Null
    }
    #If RegKey Property already exists this will modify the value instead of creating another RegKey Property.
    if($testentry){
        LogWrite "Updating RegKey Property Value to 0."
        Set-Itemproperty -path $CryptoSignature -Name "ValidateAdminCodeSignatures" -Value 0  -Force | Out-Null
    }

    If ((Test-Path -Path $LightingRealityUninstall) -eq $TRUE) {
        LogWrite "Checking If Lighting Reality is Running..."
        If (Get-Process realarea -ErrorAction SilentlyContinue) {

            LogWrite "Closing Reality Outdoor..."
            Get-Process | Where-Object { $_.Name -eq "realarea" } | Stop-Process
            LogWrite "Reality Outdoor Process Closed."

        }
        If (Get-Process 'reality reader' -ErrorAction SilentlyContinue) {

            LogWrite "Closing Reality Reader..."
            Get-Process | Where-Object { $_.Name -eq "reality reader" } | Stop-Process
            LogWrite "Reality Reader Process Closed."

        }
        If (Get-Process realroad -ErrorAction SilentlyContinue) {

            LogWrite "Closing Reality Roadway..."
            Get-Process | Where-Object { $_.Name -eq "realroad" } | Stop-Process
            LogWrite "Reality Roadway Process Closed."

        }
        #Uninstalls take place here.
        #LIGHTING REALITY
        LogWrite "Uninstalling Lighting Reality..."
        try { Start-Process -FilePath $LightingRealityUninstall  -ArgumentList '/SILENT /VERYSILENT' -Wait -NoNewWindow -ErrorAction Stop
        
        }
        catch [System.InvalidOperationException] {
            LogWrite "Cannot find: Lighting Reality"
        }
        If ((Test-Path -Path $LightingRealityUninstall) -eq $TRUE) {
            LogWrite "Failed to Uninstall Lighting Reality."
            LogWrite "Error Code: 0x01a"
            $global:ErrorCode = $ErrorCode + 1
        }ELSE{
            LogWrite "Lighting Reality Uninstalled."
            $global:SuccessfulUninstallCount = $SuccessfulUninstallCount + 1
        }
    }
    #------------------------------------------------------------------------
    #LIGHTING REALITY READER
    If ((Test-Path -Path $LightingRealityReaderUninstall) -eq $TRUE) {
        LogWrite "Uninstalling Lighting Reality Reader..."
        try { Start-Process -FilePath $LightingRealityReaderUninstall  -ArgumentList '/SILENT /VERYSILENT' -Wait -NoNewWindow -ErrorAction Stop
    
        }
        catch [System.InvalidOperationException] {
            LogWrite "Cannot find: Lighting Reality Reader"
        }
        If ((Test-Path -Path $LightingRealityReaderUninstall) -eq $TRUE) {
            LogWrite "Failed to Uninstall Lighting Reality Reader."
            LogWrite "Error Code: 0x01b"
            $global:ErrorCode = $ErrorCode + 1
        }ELSE{
            LogWrite "Lighting Reality Reader Uninstalled."
            $global:SuccessfulUninstallCount = $SuccessfulUninstallCount + 1
        }
    }
    #Deletes cached data containing the License of the application. So if the application gets reinstalled, the user will be required to enter the Licnese Key.
    LogWrite "Removing Cached Data."
    try { Remove-Item -Path "C:\Users\*\AppData\Roaming\Lighting Reality" -Force -Recurse -ErrorAction Stop

    }
    catch [System.Management.Automation.ItemNotFoundException] {
        LogWrite "Cannot find: 'C:\Users\*\AppData\Roaming\Lighting Reality'"
        LogWrite "This may be because the License Key was never activated." #This error occurs because it cannot see/find the object that you specified to delete.
    }
    try { Remove-Item -Path "C:\ProgramData\Lighting Reality" -Force -Recurse -ErrorAction Stop

    }
    catch [System.Management.Automation.ItemNotFoundException] {
        LogWrite "Cannot find: 'C:\ProgramData\Lighting Reality'"
        LogWrite "This may be because the License Key was never activated." #This error occurs because it cannot see/find the object that you specified to delete.
    }
    try { Remove-Item -Path "C:\Users\*\AppData\Local\Temp\Lighting reality" -Force -Recurse -ErrorAction Stop

    }
    catch [System.Management.Automation.ItemNotFoundException] {
        LogWrite "Cannot find: 'C:\Users\*\AppData\Local\Temp\Lighting reality'"
        LogWrite "This may be because the License Key was never activated." #This error occurs because it cannot see/find the object that you specified to delete.
    }

    #Reverts modifications of RegKey Value back to it's default value.
    if($testentry){
        LogWrite "Updating RegKey Property Value to 1."
        Set-Itemproperty -path $CryptoSignature -Name "ValidateAdminCodeSignatures" -Value 1  -Force | Out-Null
    }
    #END REGION
    #CONFIG CYCLES
    IF ($SuccessfulUninstallCount -gt 0) {
        LogWrite "Running Configuration Manager Cycles..."
        $configManagerCycles | foreach-object {
            Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule  $PSItem
        }
    }
}
## FUNCTIONS END ##

#REGION CLEANUP
If (((Test-Path -Path $LightingRealityUninstall) -eq $TRUE) -or ((Test-Path -Path $LightingRealityReaderUninstall) -eq $TRUE)) { #If App exists, then execute Lighting Reality Function.
    LogWrite "Checking if Lighting Reality or Lighting Reality Reader is installed..."
    LightingReality
}

#REGION SWITCH
switch ( $ErrorCode )
{
    0 { LogWrite "Uninistall performed without issues. Script is Exiting with Return Code 0"    } #0 = Uninistall performed without issues.
    1 { LogWrite "Failed to uninstall either Lighting Reality or Lighting Reality Reader. Script Exited with Error Code: 0x1"      } #0x1 = Failed to uninstall either Lighting Reality or Lighting Reality Reader.
    2 { LogWrite "Uninstall Failed to uninstall Lighting Reality & Lighting Reality Reader. Script Exited with Error Code: 0x2"      } #0x2 = Failed to uninstall Lighting Reality and Lighting Reality Reader.
}

#END REGION
Clear-Variable -name ErrorCode
Clear-Variable -name SuccessfulUninstallCount

LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
## SCRIPT END ##