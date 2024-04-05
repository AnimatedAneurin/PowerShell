# START DISM SCAN
Write-host "Scanning"
$Scan = & "C:\Windows\System32\dism.exe" /online /cleanup-image /scanhealth
$ScanResult = $Scan | ForEach-Object {If (($_ -like "*The component store is repairable.*") -or ($_ -like "*No component store corruption detected.*")) {$_}}
#$ScanResult = $Scan | % {If ($_ -like "*No component store corruption detected.*") {$_}}
Write-host "Scan result"
$ScanResult
if (!($ScanResult -eq "The component store is repairable.")) { # If output is not what is expected, skip DISM and step into SFC if statement.  or if scan output is not what is expected then
    # START SFC
    Write-host "Empty"
    if ($ScanResult -eq "No component store corruption detected.") { # If no corruption detected, then move into if statement. Else exit script.
        Write-Host "SFC"
        $Sfc = & "C:\Windows\System32\sfc.exe" /scannow
        $SfcResult = $Sfc | ForEach-Object {If ($_ -like "*Windows Resource Protection found corrupt files and successfully repaired them.*") {$_}}
        if (!($SfcResult -eq "Windows Resource Protection found corrupt files and successfully repaired them.")) { # If system files successfully repaired, notify the reader. Else, notify the reader that system file repair failed.
            Write-host "System File Checker Failed or Does Not Require to Repair Corrupt System Files."
            exit # SFC should be the final step of DISM & SFC. Placing an exit here will reassure that the script does not continue past this point.
        } else {
            #Windows resource Protection did not find any integrity violations.
            Write-Host "System File Checker Successfully Repaired Corrupt System Files."
            exit # SFC should be the final step of DISM & SFC. Placing an exit here will reassure that the script does not continue past this point.
        }
    # END SFC
    } else { # This was created in case the actual result did not meet either the primary expected result nor the secondary expected result. 
        Write-host "Exit1"
        exit
    }
# END DISM SCAN
} else {
    # START DISM CHECK
    write-host "Checking"
    $Check = & "C:\Windows\System32\dism.exe" /online /cleanup-image /checkhealth
    $CheckResult = $Check | ForEach-Object {If ($_ -like "*The component store is repairable.*") {$_}}
    write-host "Check result"
    $CheckResult
    # END DISM CHECK
    # START DISM RESTORE
    $Restore = & "C:\Windows\System32\dism.exe" /online /cleanup-image /restorehealth
    $RestoreResult = $Restore | ForEach-Object {If ($_ -like "*The restore operation completed successfully.*") {$_}}
    Write-host "Restore result"
    $RestoreResult
    if (!($RestoreResult -eq "The restore operation completed successfully.")) {
        Write-host "System File Restore Failed to Repair Component Store."
        exit
    } else {
        Write-Host "System File Checker Successfully Repaired Component Store."
        $Sfc = & "sfc /scannow"
        $SfcResult = $Sfc | ForEach-Object {If ($_ -like "*Windows Resource Protection found corrupt files and successfully repaired them.*") {$_}}
        if (!($SfcResult -eq "Windows Resource Protection found corrupt files and successfully repaired them.")) { # If system files successfully repaired, notify the reader. Else, notify the reader that system file repair failed.
            Write-host "System File Checker Failed to Repair Corrupt System Files."
            exit # SFC should be the final step of DISM & SFC. Placing an exit here will reassure that the script does not continue past this point.
        } else {
            #Windows resource Protection did not find any integrity violations.
            Write-Host "System File Checker Successfully Repaired Corrupt System Files."
            exit # SFC should be the final step of DISM & SFC. Placing an exit here will reassure that the script does not continue past this point.
        }
    }
    # END DISM RESTORE
}

#schtasks /run /tn 'SCCM Client Repair'