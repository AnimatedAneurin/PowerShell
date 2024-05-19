<#
.SYNOPSIS
    Test-NetConnection - SoftEther.
.DESCRIPTION
    A script that Tests the Network Connection between the client and the VPN Server. If Test-NetConnection is Successful, it'll then attempt to connect to the server.
.PARAMETER computerName
    Here you can put a Public IP Address or a DDNS. In Summary, this is the VPN Server you're trying to connect to.
.NOTES
    Name: Test-NetConnection - SoftEther
    Version: 3.1
    Author: Aneurin Weale - DLM
    Date Created: 02/09/2022
    Last Updated: 19/05/2024
    URL: https://github.com/AnimatedAneurin/PowerShell/tree/main/Scripts/VPN/SoftEther/Test-NetConnection
#>

Param (
	[Parameter(Mandatory=$True)] [String]$computerName,
	[Parameter(Mandatory=$True)] [String]$port,
    [Parameter(Mandatory=$True)] [String]$vpnName,
    [Parameter(Mandatory=$True)] [String]$shortcutPath,
    [Parameter(Mandatory=$True)] [String]$shortcut,
    [Parameter(Mandatory=$True)] [String]$vpnConnectionName,
    [Parameter(Mandatory=$True)] [String]$IPRegularExpression,
    [Parameter(Mandatory=$True)] [String]$IP
)

## DETECTION METHOD - SCRIPT START ##

## REGION VARIABLES ##
$vpnConnectionName = "WealesIT"
$EUD = hostname

# START NETWORK SCAN
#This section confirms if device is already connected to the CORP Network. If connected, terminate script. If not connected, start remediation script.
Write-host "Checking Current Network Configuration"
$NetworkConfig = & "C:\Windows\System32\ipconfig.exe" /all
$IPv4Address = $null

foreach ($line in $NetworkConfig) {
    if ($line -match "IPv4 Address.*: (10\.0\.0\.\d+)") { # Using regular expression to match lines that contain the IPv4 address. The pattern (\d+\.\d+\.\d+\.\d+) matches any IPv4 address format.
        $IPv4Address = $matches[1]
        break
    }
}

IF ($IPv4Address -eq "XXX.XXX.XXX.") { # Here you want to put a subnet that your VPN uses (Example: 192.168.1.). Detecting this IP doesn't nessassarily mean it's connected to your VPN Network, but it does mean it's found a subnet that's similar. You could go one step further and add a Test-NetConnection step to see if it can contact the DC, but for my purpose I have chosen to avoid this.
    Write-host "IP Subnet Matching",$vpnConnectionName,"VPN Network Detected."
    Write-Host "Detected IP Address on",$EUD,"=",$IPv4Address
    Write-host "Already Connected to",$vpnConnectionName,"Network."
    Write-Host "Exiting Script..."
    #$IPv4Address # Used for troubleshooting. Remove Comment '#' if you wish to know what IP has been stored.
    EXIT
} ELSE {
    Write-Host $EUD,"Not Connected to",$vpnConnectionName,"Network."
}

## SCRIPT END ##

## REMEDIATION METHOD - SCRIPT START ##

## REGION - VARIABLES ##
$computerName = "PUBLIC IP ADDRESS HERE" # Here you can put a Public IP Address or a DDNS. I went down the path of DDNS and ended up using the DuckDNS service, by doing this I assigned a specific device a DDNS and not my entire network. That way I know I'm testing the right device.
$port = "[PORT NUMBER]"
$vpnName = "VPN Client Adapter - VPN"; # Name of VPN Adapter on End User Device.
$vpn = Get-NetAdapter -InterfaceDescription $vpnName; # Find VPN Adapter with the name of $vpnName on End User Device
$shortcutPath = "C:\Program Files\SoftEther VPN Client\WIT\" # Directory of VPN Shortcut
$shortcut = "[SHORTCUT].lnk" # File name of VPN Shortcut
$vpnConnectionName = "[VPN SERVER NAME]!" # Name of your VPN Server.
$WIT = Join-Path -Path $shortcutPath -ChildPath $shortcut # Combine $vpnName and $vpn together to form a single variable

#$ping.PingSucceeded
$Result = "Unknown Error" # Used as troubleshooting. Will confirm if something went wrong.
## END REGION ##

## REGION - IF STATEMENTS ##

$ping = Test-NetConnection -ComputerName $computerName -port $port

start-sleep -Seconds 3

if ($ping.TcpTestSucceeded -eq "true") {

    $Result = $vpnConnectionName + " is contactable!"
    #Write-Host "[VPN SERVER] is Contactable" # This is to test if the Public IP Address/DDNS is active, or in my case, to see if the device that the VPN Server is hosted on is powered on and connected to the internet.
    if($vpn.Status -eq "Disconnected"){
        Write-Host "Response found from",$vpnConnectionName,"Network..."
        Write-Host "Attempting to Establish a Connection..."
        start-process $WIT
        start-sleep -Seconds 5
        Write-host "Checking Current Network Configuration"
        $NetworkConfig = & "C:\Windows\System32\ipconfig.exe" /all
        $IPv4Address = $null
        foreach ($line in $NetworkConfig) {
            if ($line -match "IPv4 Address.*: (10\.0\.0\.\d+)") { # Using regular expression to match lines that contain the IPv4 address. The pattern (\d+\.\d+\.\d+\.\d+) matches any IPv4 address format.
                $IPv4Address = $matches[1]
                break
            }
        }
        IF ($IPv4Address -like "10.0.0.*") { # Here you want to put a subnet that your VPN uses (Example: 192.168.1.). Detecting this IP doesn't nessassarily mean it's connected to your VPN Network, but it does mean it's found a subnet that's similar. You could go one step further and add a Test-NetConnection step to see if it can contact the DC, but for my purpose I have chosen to avoid this.
            Write-host "CORP Subnet Found."
            Write-host "Already connected to CORP Network."
            Write-Host "Exiting Script..."
            #$IPv4Address # Used for troubleshooting. Remove Comment '#' if you wish to know what IP has been stored.
            EXIT
        } ELSE {
            Write-Host "Not Connected to CORP Network."
        }
    }
}
#Write-Host "1st if statement complete"
Elseif ($ping.TcpTestSucceeded -ne "true") {
    Write-Host "Attempting to Establish a Connection..."
    start-sleep -Seconds 3
    $Result = "Unable to Communicate with",$vpnConnectionName,"Network..."
    #Write-Host "[VPN SERVER] is Not Contactable"

}
Write-Host $Result
Write-Host "Exiting Script..."
#Write-Host "2nd if statement complete"
## END REGION ##
#if (Test-Connection -TargetName Server01 -Quiet) { New-PSSession -ComputerName Server01 }

## SCRIPT END ##