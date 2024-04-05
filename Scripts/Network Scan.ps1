# START NETWORK SCAN
Write-host "Checking Current Network Configuration"
$NetworkConfig = & "C:\Windows\System32\ipconfig.exe" /all
$NetworkConfigResult = $NetworkConfig | ForEach-Object {If ($_ -like "*10.0.0.*") {$_}}
#$ScanResult = $Scan | % {If ($_ -like "*No component store corruption detected.*") {$_}}

if (!($ScanResult -eq "10.0.0.")) {
    Write-host "CORP Subnet Found"
    $NetworkConfigResult
} ELSE {
    Write-Host "Not Connected"
}