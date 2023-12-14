<#
.SYNOPSIS
    Test-NetConnection - SoftEther.
.DESCRIPTION
    A script that Tests the Network Connection between the client and the VPN Server. If Test-NetConnection is Successful, it'll then attempt to connect to the server.
.NOTES
    Name: Test-NetConnection - SoftEther
    Version: 3.0
    Author: Aneurin Weale - DLM
    Date Created: 02/09/2022
    Last Updated: 14/12/2023
    URL: https://github.com/AnimatedAneurin/PowerShell/tree/main/Scripts/VPN/SoftEther/Test-NetConnection
#>

# START NETWORK SCAN
#This section confirms if device is already connected to the CORP Network. If connected, terminate script. If not connected, start script.
Write-host "Checking Current Network Configuration"
$NetworkConfig = & "C:\Windows\System32\ipconfig.exe" /all
$NetworkConfigResult = $NetworkConfig | ForEach-Object {If ($_ -like "*XXX.XXX.XXX.*") {$_}} # Here you want to put a subnet that your VPN uses (Example: 192.168.1.). Detecting this IP doesn't nessassarily mean it's connected to your VPN Network, but it does mean it's found a subnet that's similar. You could go one step further and add a Test-NetConnection step to see if it can contact the DC, but for my purpose I have chosen to avoid this.
#$ScanResult = $Scan | % {If ($_ -like "*No component store corruption detected.*") {$_}}

IF (!($ScanResult -eq "XXX.XXX.XXX.")) {
    Write-host "CORP Subnet Found."
    Write-host "Already connected to CORP Network."
    Write-Host "Exiting Script..."
    #$NetworkConfigResult
    EXIT
} ELSE {
    Write-Host "Not Connected to CORP Network."
}

## SCRIPT START ##

## REGION VARIABLES ##
$computerName = "PUBLIC IP ADDRESS HERE" # Here you can put a Public IP Address or a DDNS. I went down the path of DDNS and ended up using the DuckDNS service, by doing this I assigned a specific device a DDNS and not my entire network. That way I know I'm testing the right device.
$ping = Test-NetConnection -ComputerName $computerName
$vpnName = "VPN Client Adapter - VPN"; # Name of VPN Adapter on End User Device.
$vpn = Get-NetAdapter -InterfaceDescription $vpnName; # Find VPN Adapter with the name of $vpnName on End User Device
$shortcutPath = "C:\Program Files\SoftEther VPN Client\WIT\" # Directory of VPN Shortcut
$shortcut = "[SHORTCUT].lnk" # File name of VPN Shortcut
$vpnConnectionName = "[VPN SERVER NAME]!" # Name of your VPN Server.
$WIT = Join-Path -Path $shortcutPath -ChildPath $shortcut # Combine $vpnName and $vpn together to form a single variable
#$ping.PingSucceeded
$Result = "Unknown Error" # Used as troubleshooting. Will confirm if something went wrong.
## END REGION ##

## REGION IF STATEMENTS ##

start-sleep -Seconds 3

if ($ping.PingSucceeded -eq "true") {

    $Result = "Connected to", $vpnConnectionName
    #Write-Host "[VPN SERVER] is Contactable" # This is to test if the Public IP Address/DDNS is active, or in my case, to see if the device that the VPN Server is hosted on is powered on and connected to the internet.
    if($vpn.Status -eq "Disconnected"){
        Write-Host "Response found from [VPN SERVER] Network..."
        Write-Host "Attempting to Establish a Connection..."
        start-process $WIT
    }

}
#Write-Host "1st if statement complete"
Elseif ($ping.PingSucceeded -ne "true") {
    
    Write-Host "Attempting to Establish a Connection..."
    start-sleep -Seconds 3
    $Result = "Unable to Communicate with [VPN SERVER] Network..."
    #Write-Host "[VPN SERVER] is Not Contactable"

}
Write-Host $Result
Write-Host "Exiting Script..."
#Write-Host "2nd if statement complete"
## END REGION ##
#if (Test-Connection -TargetName Server01 -Quiet) { New-PSSession -ComputerName Server01 }

## SCRIPT END ##