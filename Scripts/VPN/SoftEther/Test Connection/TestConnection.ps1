<#
.SYNOPSIS
    Test-NetConnection - SoftEther.
.DESCRIPTION
    A script that Tests the Network Connection between the client and the VPN Server. If Test-NetConnection is Successful, it'll then attempt to connect to the server.
.NOTES
    Name: Test-NetConnection - SoftEther
    Version: 1.0
    Author: Aneurin Weale - DLM
    Date Created: 02/09/2022
    Last Updated: 02/09/2022
    URL: 
#>

## SCRIPT START ##

## REGION VARIABLES ##
$ping = Test-NetConnection -ComputerName "wealesit.duckdns.org"
$vpnName = "VPN Client Adapter - VPN";
$vpn = Get-NetAdapter -InterfaceDescription $vpnName;
$WIT = "C:\Program Files\SoftEther VPN Client\WIT\WealesIT.lnk"
#$ping.PingSucceeded
$Result = "Unknown Error"
## END REGION ##

## REGION IF STATEMENTS ##
start-sleep -Seconds 3

if ($ping.PingSucceeded -eq "true") {

    $Result = "Connected to WealesIT!"
    #Write-Host "WealesIT is Contactable"
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