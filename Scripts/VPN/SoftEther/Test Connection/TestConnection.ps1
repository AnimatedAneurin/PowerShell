<#
.SYNOPSIS
    Test-NetConnection - SoftEther.
.DESCRIPTION
    A script that Tests the Network Connection between the client and the VPN Server. If Test-NetConnection is Successful, it'll then attempt to connect to the server.
.NOTES
    Name: Test-NetConnection - SoftEther
    Version: 2.0
    Author: Aneurin Weale - DLM
    Date Created: 02/09/2022
    Last Updated: 02/09/2022
    URL: https://github.com/AnimatedAneurin/PowerShell/tree/main/Scripts/VPN/SoftEther/Test%20Connection
#>

## SCRIPT START ##

## REGION VARIABLES ##
$computerName = "PUBLIC IP ADDRESS HERE" # Here you can put a Public IP Address or a DDNS. I went down the path of DDNS and ended up using the DuckDNS service, by doing this I assigned a specific device a DDNS and not my entire network. That way I know I'm testing the right device.
$ping = Test-NetConnection -ComputerName $computerName
$vpnName = "VPN Client Adapter - VPN";
$vpn = Get-NetAdapter -InterfaceDescription $vpnName;
$shortcutPath = "C:\Program Files\SoftEther VPN Client\WIT\"
$shortcut = "WealesIT.lnk"
$vpnConnectionName = "WealesIT!"
$WIT = Join-Path -Path $shortcutPath -ChildPath $shortcut
#$ping.PingSucceeded
$Result = "Unknown Error"
## END REGION ##

## REGION IF STATEMENTS ##
start-sleep -Seconds 3

if ($ping.PingSucceeded -eq "true") {

    $Result = "Connected to", $vpnConnectionName
    #Write-Host "WealesIT is Contactable" # This is to test if the Public IP Address/DDNS is active, or in my case, to see if the device that the VPN Server is hosted on is powered on and connected to the internet.
    if($vpn.Status -eq "Disconnected"){
        Write-Host "Response found from WealesIT Network..."
        Write-Host "Attempting to Establish a Connection..."
        start-process $WIT
    }

}
#Write-Host "1st if statement complete"
Elseif ($ping.PingSucceeded -ne "true") {
    
    Write-Host "Attempting to Establish a Connection..."
    start-sleep -Seconds 3
    $Result = "Unable to Communicate with WealesIT Network..."
    #Write-Host "WealesIT is Not Contactable"

}
Write-Host $Result
Write-Host "Exiting Script..."
#Write-Host "2nd if statement complete"
## END REGION ##
#if (Test-Connection -TargetName Server01 -Quiet) { New-PSSession -ComputerName Server01 }

## SCRIPT END ##