$AppxApps = @(
    "*GetHelp*"
    "*Getstarted*"
    "*Microsoft3DViewer*"
    "*MicrosoftOfficeHub*"
    "*MicrosoftSolitaireCollection*"
    "*MixedReality.Portal*"
    "*People*"
    "*SkypeApp*"
    "*Wallet*"
    "*windowscommunicationsapps*"
    "*WindowsFeedbackHub*"
    "*XboxSpeechToTextOverlay*"
    "*XboxGameOverlay*"
    "*XboxApp*"
    "*Xbox.TCUI*"
    "*XboxIdentityProvider*"
    "*XboxGamingOverlay*"
    "*YourPhone*"
)


$AppxApps | foreach-object {
    $App = $PSItem
    $ProvisionedApp = (Get-appxprovisionedpackage -online | where-object {$_.packagename -like $App}).packagename
    Remove-AppxProvisionedPackage -online -allusers -packagename $ProvisionedApp
}