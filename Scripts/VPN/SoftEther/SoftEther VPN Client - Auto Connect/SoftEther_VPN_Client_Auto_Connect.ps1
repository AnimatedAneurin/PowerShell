<#
.SYNOPSIS
    SoftEther VPN Client - Auto Connect.
.DESCRIPTION
    This script automates the SoftEther VPN Client to connect to the SoftEther VPN Server.
.PARAMETER vpnServerName
    Define the Public IP Address or a DDNS of your SoftEther VPN Server.
.PARAMETER vpnServerFQDN
    Define the FQDN of your SoftEther VPN Server.
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
    Name: SoftEther VPN Client - Auto Connect
    Version: 4.2
    Author: Aneurin Weale - DLM
    Date Created: 02/09/2022
    Last Updated: 19/05/2024
    URL: https://github.com/AnimatedAneurin/PowerShell/tree/main/Scripts/VPN/SoftEther/Test-NetConnection
#>

Param (
    [Parameter(Mandatory=$True)] [String]$vpnServerName,
    [Parameter(Mandatory=$True)] [String]$vpnServerFQDN,
    [Parameter(Mandatory=$True)] [String]$port,
    [Parameter(Mandatory=$True)] [String]$adapterDescription,
    [Parameter(Mandatory=$True)] [String]$shortcutPath,
    [Parameter(Mandatory=$True)] [String]$shortcut,
    [Parameter(Mandatory=$True)] [String]$virtualHubName,
    [Parameter(Mandatory=$True)] [String]$subnet
)

## DETECTION METHOD - SCRIPT START ##

## LOGGING SYSTEM - START REGION ##
$logPath = Join-Path -Path $shortcutPath -ChildPath "\SE-VPN-Connect.log"
Function LogWrite { #This function allows us to replace all 'Write-Host' commands to 'LogWrite' commands. This means instead of outputting text to the terminal, it'll output to a log file instead.
    #Function to create a log file in the current directory.
    Param ([string]$logstring)
    Add-Content $logPath -value "$(Get-Date -UFormat %Y%m%d-%H:%M:%S) - $($logstring)"
    #20190717-12:07:40 - Example
}
## LOGGING SYSTEM - END REGION ##

LogWrite -logstring "--------------------------------- START ----------------------------------"

## VARIABLES - START REGION ##
$EUD = $env:computername
## VARIABLES - END REGION ##

## NETWORK CHECK - START REGION ##
#This region confirms if the EUD is already connected to the CORP Network by pinging one of the servers. This part is needed just in case EUD is in the office rather than remotely. If EUD is already connected, then terminate script.
LogWrite "Checking Current Network Configuration"
Clear-DnsClientCache
$ping = Test-NetConnection -computername $vpnServerFQDN -informationlevel detailed
if ($ping.PingSucceeded -eq "true") {
    LogWrite "Already Connected to",$virtualHubName,"Network."
    LogWrite "Exiting Script..."
    LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
    exit
}
## NETWORK CHECK - END REGION ##

## VPN ADAPTER NETWORK CHECK - START REGION ##
# Get the network adapter based on the description
$NetworkAdapter = Get-NetAdapter -InterfaceDescription "*$adapterDescription*"

if(!($NetworkAdapter.Status -eq "Disconnected")){
    if ($NetworkAdapter) {
        # Get the IPv4 address associated with this adapter
        $IPv4Address = Get-NetIPAddress -InterfaceIndex $NetworkAdapter.IfIndex | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.IPAddress -like $subnet } | Select-Object -ExpandProperty IPAddress -First 1
        if ($IPv4Address) {
            LogWrite "IP Subnet Matching",$virtualHubName,"VPN Network Detected."
            LogWrite "Detected IP Address on",$EUD,"=",$IPv4Address
            LogWrite "Already Connected to",$virtualHubName,"Network."
            LogWrite "Exiting Script..."
            LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
            EXIT
        } else {
            LogWrite $EUD,"Not Connected to",$virtualHubName,"Network."
        }
    } else {
        LogWrite "Specified network adapter not found."
        LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
        exit
    }
} elseif ($NetworkAdapter.Status -eq "Disconnected") {
    LogWrite $EUD,"Not Connected to",$virtualHubName,"Network."
} else {
    LogWrite "Specified network adapter not found."
    LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
    exit
}
## VPN ADAPTER NETWORK CHECK - END REGION ##

## DETECTION METHOD - SCRIPT END ##

## REMEDIATION METHOD - SCRIPT START ##

## VARIABLES - START REGION ##
$NetworkAdapter = Get-NetAdapter -InterfaceDescription "*$adapterDescription*"
$WIT = Join-Path -Path $shortcutPath -ChildPath $shortcut
$Result = "Unknown Error"
## VARIABLES - END REGION ##

## VPN CONNECT - START REGION ##
$portForward = Test-NetConnection -ComputerName $vpnServerName -port $port -InformationLevel Detailed

start-sleep -Seconds 3

if ($portForward.TcpTestSucceeded -eq "true") {

    $Result = $virtualHubName + " is contactable!"
    #LogWrite $virtualHubName, " is contactable!" # This is to test if the Public IP Address/DDNS is active, or in my case, to see if the device that the VPN Server is hosted on is powered on and connected to the internet.
    if($NetworkAdapter.Status -eq "Disconnected"){
        LogWrite "Response found from",$virtualHubName,"Network..."
        LogWrite "Attempting to Establish a Connection..."
        start-process $WIT
        start-sleep -Seconds 5 # This pause is needed. If attempting to detect the IP too early before SoftEther Client can make a connection, the script will not work as expected.
        LogWrite "Checking Current Network Configuration"
        if(!($NetworkAdapter.Status -eq "Disconnected")){
            if ($NetworkAdapter) {
                # Get the IPv4 address associated with this adapter
                $IPv4Address = Get-NetIPAddress -InterfaceIndex $NetworkAdapter.IfIndex | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.IPAddress -like $subnet } | Select-Object -ExpandProperty IPAddress -First 1
                if ($IPv4Address) {
                    LogWrite "IP Subnet Matching",$virtualHubName,"VPN Network Detected."
                    LogWrite "Detected IP Address on",$EUD,"=",$IPv4Address
                    LogWrite "Already Connected to",$virtualHubName,"Network."
                    LogWrite "Exiting Script..."
                    LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
                    EXIT
                } else {
                    LogWrite $EUD,"Not Connected to",$virtualHubName,"Network."
                }
            } else {
                LogWrite "Specified network adapter not found."
                LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
                exit
            }
        } elseif ($NetworkAdapter.Status -eq "Disconnected") {
            LogWrite $EUD,"Not Connected to",$virtualHubName,"Network."
        } else {
            LogWrite "Specified network adapter not found."
            LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
            exit
        }
    }
}

Elseif ($portForward.TcpTestSucceeded -ne "true") {
    LogWrite "Attempting to Establish a Connection..."
    start-sleep -Seconds 3
    $Result = "Unable to Communicate with",$virtualHubName,"Network..."
    #LogWrite $virtualHubName,"is Not Contactable"

}
LogWrite $Result
LogWrite "Exiting Script..."
LogWrite  -logstring "--------------------------------- ENDED ----------------------------------"
## VPN CONNECT - END REGION ##
## SCRIPT END ##