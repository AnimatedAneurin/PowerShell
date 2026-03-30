<#
.SYNOPSIS
    A Script that downloads QualysCloudAgent.exe
.DESCRIPTION
    A Script that downloads QualysCloudAgent.exe by leveraging the Qualys API and using Invoke-WebRequest.
.EXAMPLE
    .\Start-QualysCloudAgentDownload.ps1
.NOTES
    Name: Start-QualysCloudAgentDownload
    Version: 1.0
    Author: Aneurin Weale - VAR
    Date Created: 29/03/2026
    Last Updated: 29/03/2026
    URL: 
#>

$username = "" # Must have API access + the correct level of perms. More information can be found from the Qualys API documentation.
$password = ""
$api = "" # Can be obtained from the Qualys Portal

$uri = $api + "/qps/rest/1.0/download/ca/downloadbinary/"

$outFilePath = ""
$qualysCloudAgent = "QualysCloudAgent.exe"
$outFile = Join-Path -Path $outFilePath -ChildPath $qualysCloudAgent

# Build Basic Auth header
$pair = "$username`:$password"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$encodedCreds = [Convert]::ToBase64String($bytes)

$headers = @{
    "Authorization"    = "Basic $encodedCreds"
    "X-Requested-With" = "curl"
}

# Read XML as raw string
$xmlPath = "C:\Temp\DownloadBinary.xml"
$body = Get-Content $xmlPath -Raw

# Send request and SAVE DIRECTLY
Invoke-WebRequest -Uri $uri -Method POST -Headers $headers -Body $body -ContentType "text/xml" -OutFile $outFile