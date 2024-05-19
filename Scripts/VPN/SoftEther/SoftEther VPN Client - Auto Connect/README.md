# SoftEther VPN Client - Auto Connect

## PRE-REQUISITES

Must have SoftEther Client installed on a Windows End User Device(EUD).

### INSTRUCTIONS:

To use this script, you will need all the files in this folder.

First download all required files and place them in a directory on the End User Device(EUD).

Once downloaded, Launch Task Scheduler as admin and import **"SoftEther_VPN_Client_Auto_Connect.xml"** - Adjust the command within the Task Actions to your needs.

A shortcut of your SoftEther VPN Connection will need to be created in the same directory as the PowerShell script.
This can be done by launching the SoftEther client, right click the VPN Connection and click on **"Create VPN Connection shortcut"**.

Below is an explanation of each parameter for the PowerShell Script:

**PARAMETER vpnServerName**
    Define the Public IP Address or a DDNS of your SoftEther VPN Server.
**PARAMETER vpnServerFQDN**
    Define the FQDN of your SoftEther VPN Server.
**PARAMETER port**
    This is the port that your SoftEther VPN Server listens on.
**PARAMETER adapterDescription**
    This is the SoftEther Adapter on the EUD that connects to your SoftEther VPN Server. Define the network adapter description to look for.
**PARAMETER shortcutPath**
    The directory of which your VPN Shortcut.lnk resides on the EUD.
**PARAMETER shortcut**
    This is your shortcut.lnk. This will be combined with the shortcutPath Variable to create the full path of the shortcut.lnk.
**PARAMETER virtualHubName**
    This is the name of your Virtual Hub within your SoftEther Server.
**PARAMETER subnet**
    This is the subnet you're checking against the Network Adapter on the EUD.
**EXAMPLE**
	.\SoftEther_VPN_Client_Auto_Connect.ps1 -vpnServerName [DDNS/PUBLIC IP OF VPN SERVER] -vpnServerFQDN [FQDN OF YOUR VPN SERVER] -port 443 -adapterDescription [VPN ADAPTER] -shortcutPath "C:\VPN" -shortcut "\VPN.lnk" -virtualHubName [VIRTUAL HUB] -subnet "192.168.1.*"

Owned by Aneurin Weale.