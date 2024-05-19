@echo off
color a
powershell -ep bypass -f "[DIRECTORY OF FILE]\SoftEther_VPN_Client_Auto_Connect.ps1" -vpnServerName [DDNS/PUBLIC IP OF VPN SERVER] -vpnServerFQDN [FQDN OF YOUR VPN SERVER] -port 443 -adapterDescription [VPN ADAPTER] -shortcutPath "C:\VPN" -shortcut "\VPN.lnk" -virtualHubName [VIRTUAL HUB] -subnet "192.168.1.*"