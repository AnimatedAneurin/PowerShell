## HOUSEKEEPING ##

## START SCRIPT ##

## PARAMETERS ##

Param (
    [Parameter()] [switch] $WhatIf
)

## GLOBAL VARIABLES ##

$ccmCache = "C:\Windows\ccmCache\"

$Users = "C:\Users"

$ccmCacheCleanup = Get-ChildItem C:\Windows\ccmCache\ -Include *.* -Recurse | Remove-Item
#Get-ChildItem –Path "C:\Users" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item

#$TestccmCacheCleanup = Get-ChildItem C:\Windows\ccmCache\ -Include *.* -Recurse

$BlacklistedUsers = @( # If a user is in this OU, they will be skipped. This needs to be written the same way as the OU name.

    "Administrator"

    "Public"

    "Default"

)

$UsersCleanup = Get-ChildItem -Path "C:\Users" | Where-Object {($_.Name -notin $BlacklistedUsers -and $_.LastWriteTime -lt (Get-Date).AddDays(-60))} | Remove-Item

$TestUsersCleanup = Get-ChildItem -Path "C:\Users" | Where-Object {($_.Name -notin $BlacklistedUsers -and $_.LastWriteTime -lt (Get-Date).AddDays(-60))}

## REMEDIATION ##

Function ccmCacheCleanup {

    if (-not ($WhatIf.IsPresent)) {
        Write-Host "FOLDER FOUND" -ForegroundColor Yellow
        Write-Host "DELETING UNNESSASSARY FILES..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        $ccmCacheCleanup
        #Remove-Item "$($User.FullName)$File" -Recurse
    }
    if ($WhatIf.IsPresent) {
        Write-Host "FOLDER FOUND" -ForegroundColor Yellow
        #$TestccmCacheCleanup
        Write-Host "Would Usually Delete Here But Script Has Been Run As A Test" -ForegroundColor Yellow
    }

}

Function UsersCleanup {

    if (-not ($WhatIf.IsPresent)) {
        Write-Host "FOLDER FOUND" -ForegroundColor Yellow
        Write-Host "DELETING UNNESSASSARY FILES..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        $UsersCleanup
        #Remove-Item "$($User.FullName)$File" -Recurse
    }
    if ($WhatIf.IsPresent) {
        Write-Host "FOLDER FOUND" -ForegroundColor Yellow
        $TestUsersCleanup
        Write-Host "`nWould Usually Delete Here But Script Has Been Run As A Test" -ForegroundColor Yellow
    }

}

## DETECTIONS ##

If (((Test-Path -Path $ccmCache) -eq $FALSE) -and ((Test-Path -Path $Users) -eq $FALSE)) {
    Write-Host "`nSomething's gone wrong." -ForegroundColor Red
    Write-Host "Exiting Script..." -ForegroundColor Yellow
    Exit
}

If ((Test-Path -Path $ccmCache) -eq $TRUE) {
    Write-Host "`nChecking If ccmCache File Path Exists..."
    Start-Sleep -s 1
    ccmCacheCleanup
}

If ((Test-Path -Path $Users) -eq $TRUE) {
    Write-Host "`nChecking Users File Path Exists..."
    Start-Sleep -s 1
    UsersCleanup
}

Write-Host "`nScript Finished. Exiting Script...`n" -ForegroundColor Green

## END SCRIPT ##