<#
.SYNOPSIS
    Test-NetConnection - SoftEther.
.DESCRIPTION
    This script automates the SoftEther VPN Client to connect to the SoftEther VPN Server.
.PARAMETER vpnServerName
    Define the Public IP Address or a DDNS of your SoftEther VPN Server.
.PARAMETER port
    This is the port that your SoftEther VPN Server listens on.
.PARAMETER adapterDescription
    This is the SoftEther Adapter on the EUD that connects to your SoftEther VPN Server. Define the network adapter description to look for.
.PARAMETER shortcutPath
    The directory of which your VPN Shortcut.lnk resides on the EUD.
.PARAMETER shortcut
    This is your shortcut.lnk. This will be combined with the shortcutPath Variable to create the full path of the shortcut.lnk.
.PARAMETER virtualHubName
    This is the name of your Virtual Hub within your SoftEther Server.
.PARAMETER subnet
    This is the subnet you're checking against the Network Adapter on the EUD.
.EXAMPLE
	.\Test-NetConnection.ps1 -vpnServerName [DDNS/PUBLIC IP OF VPN SERVER] -port 443 -adapterDescription [VPN ADAPTER] -shortcutPath "C:\VPN" -shortcut "\VPN.lnk" -virtualHubName [VIRTUAL HUB] -subnet "192.168.1.*"
.NOTES
    Name: Test-NetConnection - SoftEther
    Version: 4.1
    Author: Aneurin Weale - DLM
    Date Created: 02/09/2022
    Last Updated: 19/05/2024
    URL: https://github.com/AnimatedAneurin/PowerShell/tree/main/Scripts/VPN/SoftEther/Test-NetConnection
#>

Param (
	[Parameter(Mandatory=$True)] [String]$vpnServerName,
	[Parameter(Mandatory=$True)] [String]$port,
    [Parameter(Mandatory=$True)] [String]$adapterDescription,
    [Parameter(Mandatory=$True)] [String]$shortcutPath,
    [Parameter(Mandatory=$True)] [String]$shortcut,
    [Parameter(Mandatory=$True)] [String]$virtualHubName,
    [Parameter(Mandatory=$True)] [String]$subnet
)

## DETECTION METHOD - SCRIPT START ##

## REGION VARIABLES ##
$EUD = $env:computername

# START NETWORK SCAN
#This section confirms if device is already connected to the CORP Network. If connected, terminate script. If not connected, start remediation script.
Write-host "Checking Current Network Configuration"

# Get the network adapter based on the description
$NetworkAdapter = Get-NetAdapter -InterfaceDescription "*$adapterDescription*"

if(!($NetworkAdapter.Status -eq "Disconnected")){
    if ($NetworkAdapter) {
        # Get the IPv4 address associated with this adapter
        $IPv4Address = Get-NetIPAddress -InterfaceIndex $NetworkAdapter.IfIndex | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.IPAddress -like $subnet } | Select-Object -ExpandProperty IPAddress -First 1

        if ($IPv4Address) {
            Write-host "IP Subnet Matching",$virtualHubName,"VPN Network Detected."
            Write-Host "Detected IP Address on",$EUD,"=",$IPv4Address
            Write-host "Already Connected to",$virtualHubName,"Network."
            Write-Host "Exiting Script..."
            EXIT
        } else {
            Write-Host $EUD,"Not Connected to",$virtualHubName,"Network."
        }
    } else {
        Write-Host "Specified network adapter not found."
        exit
    }
} elseif ($NetworkAdapter.Status -eq "Disconnected") {
    Write-Host $EUD,"Not Connected to",$virtualHubName,"Network."
} else {
    Write-Host "Specified network adapter not found."
    exit
}

## SCRIPT END ##

## REMEDIATION METHOD - SCRIPT START ##

## REGION VARIABLES ##
$NetworkAdapter = Get-NetAdapter -InterfaceDescription "*$adapterDescription*"
$WIT = Join-Path -Path $shortcutPath -ChildPath $shortcut

$Result = "Unknown Error"
## END REGION ##

## REGION IF STATEMENTS #

$ping = Test-NetConnection -ComputerName $vpnServerName -port $port

start-sleep -Seconds 3

if ($ping.TcpTestSucceeded -eq "true") {

    $Result = $virtualHubName + " is contactable!"
    #Write-Host $virtualHubName, " is contactable!" # This is to test if the Public IP Address/DDNS is active, or in my case, to see if the device that the VPN Server is hosted on is powered on and connected to the internet.
    if($NetworkAdapter.Status -eq "Disconnected"){
        Write-Host "Response found from",$virtualHubName,"Network..."
        Write-Host "Attempting to Establish a Connection..."
        start-process $WIT
        start-sleep -Seconds 5 # This pause is needed. If attempting to detect the IP too early before SoftEther Client can make a connection, the script will not work as expected.
        Write-host "Checking Current Network Configuration"
        if(!($NetworkAdapter.Status -eq "Disconnected")){
            if ($NetworkAdapter) {
                # Get the IPv4 address associated with this adapter
                $IPv4Address = Get-NetIPAddress -InterfaceIndex $NetworkAdapter.IfIndex | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.IPAddress -like $subnet } | Select-Object -ExpandProperty IPAddress -First 1
        
                if ($IPv4Address) {
                    Write-host "IP Subnet Matching",$virtualHubName,"VPN Network Detected."
                    Write-Host "Detected IP Address on",$EUD,"=",$IPv4Address
                    Write-host "Already Connected to",$virtualHubName,"Network."
                    Write-Host "Exiting Script..."
                    EXIT
                } else {
                    Write-Host $EUD,"Not Connected to",$virtualHubName,"Network."
                }
            } else {
                Write-Host "Specified network adapter not found."
                exit
            }
        } elseif ($NetworkAdapter.Status -eq "Disconnected") {
            Write-Host $EUD,"Not Connected to",$virtualHubName,"Network."
        } else {
            Write-Host "Specified network adapter not found."
            exit
        }
    }
}

Elseif ($ping.TcpTestSucceeded -ne "true") {
    Write-Host "Attempting to Establish a Connection..."
    start-sleep -Seconds 3
    $Result = "Unable to Communicate with",$virtualHubName,"Network..."
    #Write-Host $virtualHubName,"is Not Contactable"

}
Write-Host $Result
Write-Host "Exiting Script..."
## END REGION ##

## SCRIPT END ##