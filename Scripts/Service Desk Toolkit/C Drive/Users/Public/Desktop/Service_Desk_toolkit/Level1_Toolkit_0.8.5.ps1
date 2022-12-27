##REQUIRES -Modules ActiveDirectory

<#
.SYNOPSIS
    GUI created using Windows Forms and PowerShell
.DESCRIPTION
    A tool to launch scripts and functions that the team create.
.NOTES
    Author		:  Ashley Bickerstaff
    Contributor :  Scott Simpson
    Contributor :  Mac baczkowski
    Contributor :  Mathew Morgan
    Contributor :  Tyran Edwards (me@tyran.co.uk)
    Contributor :  Aneurin Weale
    Language    :  PowerShell
	Last Update :  24/09/2020
    Version     :  1.0.4

    
#######################################
#######################################
###                               #####  
###       Version History         #####
###                               ##### 
###                               #####
#######################################
#######################################



    0.0.1  27/04/2016  Updates to header
    0.0.2  28/04/2016  New Feature - Added logo to form
    0.0.3  28/04/2016  New Feature - Added icon and updated layout
    0.0.4  28/04/2016  New Feature - Created function and removed code from button
    0.0.5  29/04/2016  Refactor - Added and positioned logo from file
    0.0.6  29/04/2016  Refactor - Added and positioned logo from Base64 String
    0.0.7  29/04/2016  New Feature - Updated function to include PW Reset and Generator
    0.0.8  27/06/2016  Refactor - GUI will ask for confirmation to reset users password to avoid staff error
    0.0.9  28/06/2016  Refactor - GUI will provide username full name and email address to avoid staff error
    0.1.0  28/06/2016  Refactor - GUI time stamp will fluxuate every entry
    0.1.1  13/02/2017  New Feature - Added generate button
    0.1.2  15/03/2017  New Feature - Added AD Unlock button
    0.1.3  15/03/2017  Refactor - Refined output values + resolved issues with error reporting.
    0.1.4  16/03/2017  New Feature - When Generate button is clicked it automatically stores most recent password in analysts clipboard
    0.1.5  16/03/2017  New Feature - Script will address analyst by first name
    0.1.6  16/03/2017  New Feature - New function which pings ipaddress via PC Name of user
    0.1.7  23/03/2017  New Feature - System up time Function
    0.1.8  23/03/2017  Refactor - Font change to make buttons more easy to read
    0.1.9  23/03/2017  New Feature - New Function called OS - This will advise the analyst what operating system the PC is
    0.2.0  23/03/2017  New Feature - Quick link to the ESC Knowledge base wiki + Buttons when scrolled over with curser shows what they do
    0.2.1  23/03/2017  Refactor - Updated code to render form correctly.
    0.2.2  23/03/2017  Refactor - Updated title to have version + resized object form + hidden max window and min window buttons
    0.2.3  23/03/2017  Refactor - Moved output rich text box location on object form
    0.2.4  27/03/2017  New Feature - gpupdate /force through users CMD.EXE - user will recieve a pop up indicating GPUPDATE has been ran
    0.2.5  27/03/2017  New Feature - Backdoor into users C: Drive
    0.2.6  27/03/2017  New Feature - USB devices connected to computer (displayed via Out-GridView)
    0.2.7  28/03/2017  New Feature - PC restart
    0.2.8  29/03/2017  New Feature - PC Shutdown
    0.2.9  29/03/2017  New Feature - Applications installed and uninstalled on users PC listed in alphabetical order
    0.3.0  29/03/2017  New Feature - System of type of users PC
    0.3.1  30/03/2017  Refactor - Buttons moved + Gui size change
    0.3.2  31/03/2017  New Feature - More weblinks added
    0.3.3  31/03/2017  Refactor - GUI tidy up
    0.3.4  31/03/2017  Refactor - GUI BackGround now saved to S: service desk as Capture106.jpg
    0.3.5  31/03/2017  Refactor - GUI output box now 'lemon chiffon' Easier to read and to differential between GUI and output box
    0.3.6  31/03/2017  New Feature - All users member of information - working - out gridview
    0.3.7  05/04/2017  Bug Fix - removal of letter "r" as causing confusion with password resets
    0.3.8  10/04/2017  New Feature - Quick Links, added more.
    0.3.8  10/04/2017  Refactor - Changed quick links  - reduced size
    0.3.9  10/04/2017  Refactor - Updated Function - Changed apps function
    0.4.0  10/04/2017  Refactor - Updated Function - AD-Unlock - corrected the error recording.
    0.4.1  10/04/2017  Refactor - Updated Function - checkADaccount - corrected the error recording.
    0.4.2  10/04/2017  Refactor - Updated notes within scripts and adjusted layout of code.
    0.4.3  10/04/2017  Refactor - Removed Base64 images for quick links
    0.4.4  10/04/2017  Refactor - Removed cancel button \\ tidied up outputs for buttons (line) \\ changed font size of Title.
    0.4.5  13/07/2017  Refactor - Removed 3 functions (Ping-PC , Get-Uptime & Get-OPSYS) and condensed them into 1 function (Get-PCInfo)
	0.4.6  13/07/2017  Refactor - Removed System function
    0.4.7  13/07/2017  Refactor - Updated function Get-PCInfo
    0.4.8  13/07/2017  User password history function
    0.4.9  14/07/2017  PC member of information
    0.5.0  19/07/2017  user profiles on machine
    0.5.1  20/07/2017  button with pop up of which profiles are on searched machine and can be removed
    0.5.2  21/07/2017  Outlay change 
    0.5.3  21/07/2017  User Info button added
    0.5.4  24/07/2017  GSN weblink button
    0.5.5  24/07/2017  Applications running on remote pc button
    0.5.6  24/07/2017  auto remote control remote asset - approval from user still required
    0.5.7  25/07/2017  EDRMS quick link added
    0.5.8  25/07/2017  kill runing proccesses on remote machine
    0.5.9  26/07/2017  Merge DELPROF and profile button + add delete user C: data once profile removed (added test path)
    0.6.0  26/07/2017  Slow PC Button add - this will check with users pc is running inefficiantly + GUI tidy up
    0.6.1  31/07/2017  Added C: size  feature within slow pc check
    0.6.2  31/07/2017  Added "please wait" feature into slow pc due to retrival time
    0.6.3  31/07/2017  Top 5 running processes (RAM) on users machine via slow pc button + new quick link (the hub)
    0.6.4  01/08/2017  lucida console font change to assist with output box alignment - testing inetlevel corrected outlay to reflect lucida
    0.6.5  01/08/2017  Top 5 processes into Slow PC function
    0.6.6  07/08/2017  Testing GUI and fixing alignment errors / added access address + script log location
    0.6.7  07/08/2017  toolkit merge as was updating incorrect copy / fixed del+prof button error out 
    0.6.8  08/08/2017  Fix processes error out funtion
    0.6.9  08/08/2017  Fix slow PC function from branch
    0.7.0  08/08/2017  Tidy up of test code for release.
    0.7.1  08/08/2017  Check functions have (test connection) instead of get ad computer
    0.7.2  08/08/2017  Changed image on pc data and member of (pc)
    0.7.3  08/08/2017  realignment of user data and password info
    0.7.4  28/03/2018  Changed ACCESS LLP: to CGI & Added creator information
    0.7.5  28/03/2018  Toolkit Logo Changed from Access to CGI and amended tool state to red
    0.7.6  28/03/2018  Background change
    0.7.7  29/03/2018  GIF change to red
    0.7.8  04/04/2018  GSN Link Rename - Remedy to CGI Remedy Link - Bitlocker Link add - pulse remove - Iworld Link change 
    0.7.9  03/05/2018  Password reset option changed for Corida - password simplified and unticked change password at 1st login
    0.8.0  08/05/2018  Password Reset changed back to prompt at first login / password choice extended
    0.8.1  08/05/2018  Cordia Button added with no password prompt and password simplified / Profile Delete image changed / Kill process icon changed
    0.8.2  08/05/2018  Ping Feature - Changed check C: path to test connect in ping funciton
    0.8.3  08/05/2018  Cordia button name change to "Cordia AD"
    0.8.4  08/05/2018  3 quick links added - call routes - cordia security questions - it forms
    0.8.5  08/05/2018  swaped around AD Reset and Cordia reset - changed cordia ad to Cordia Rset 
    0.8.6  24/05/2018  (Unofficial) New feature - Added support for glasgowlife (\CSG) machines and added the asset tag lookup feature - Mac B
    0.8.7  24/05/2018  Added basic security features ie. Not allowing empty input to prevent performing tasks on a random machine. - Mac B
    0.8.8  08/06/2018  Sap logon error fix added - F Da Silva 
    0.8.9  04/07/2018  Added AFR/VIP lookup feature for validation - Mac B
    0.8.9  07/12/2018  Pulse link button updated & added Wiki Search box - Ty
    0.9.0  10/12/2018  Tidied buttons, removed "Challenge & Response" button, added Useful Links dropdown and updated DNS Flush icon" - Ty
    0.9.1  11/12/2018  Added software deployment function/button. Updated password gen' so that j and g removed and 3 numeric characters are always included at random spacing - Ty
    0.9.2  18/12/2018  Hop restart button added, tempInet function/button added as temp function for updating large numbers of user inet levels - Ty
    1.0.0  02/01/2019  Total GUI overhaul, tightened up buttonsand shuffled them, changed button img's to more suitable. GCC logo added, changed combobox to listbox - Ty
    1.0.0  02/01/2019  Added background pancels to clear up GUI sections, made outputbox smaller and added output clear button/function - Ty
    1.0.0  02/01/2019  Cleaned up AFR lists and centralised them onto ASGA56690 for easier administration - Ty
    1.0.1  31/01/2019  Removed clock (to speed up kit), combined gpupdate and dns flush, added comms batch file check, added temp file batch - Ty
    1.0.1  31/01/2019  Removed unused legacy commented out functions, removed un-required function calls to USB checks, removed file logging - Ty
    1.0.2  20/01/2019  Retired USB button. Added Software Cycle function and button. Added Printer Q button and function. - Ty
    1.0.3  10/03/2020  Added 'GCC SIM and LIM' and 'IT Forms' Usefull URL Links. Added 3 extra buttons (1 button = Application Support Queue, 2 buttons inactive) and moved Usefull Links Box - AW
    1.0.4  24/09/2020  Added more links to the Usefull URL Links List which include the following: EDRMS, IT Forms EDU and OWA EDU - AW

*************************************************************************************************************************
*************************************************************************************************************************
*************************************************************************************************************************
               Make sure you have RSAT tool installed, becasue this uses Active Direcotry module.
    New PC using powershell ????  run Powershell as admin and run script with the below line to essentially active
                         Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
*************************************************************************************************************************
.LINK
Get-ADUser
#>

$error.Clear()
$errorActionPreference = "SilentlyContinue"

#### FONT AND STYLE LINK https://blogs.technet.microsoft.com/stephap/2012/04/23/building-forms-with-powershell-part-1-the-form/ ####

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles()
Add-Type -AssemblyName Microsoft.VisualBasic

$DCHostName = (Get-ADDomainController | Select-Object -Property HostName).HostName
$EVUser = [Environment]::UserName
$EVDevice = [Environment]::MachineName


$UKDATE100 = (Get-Date -format U)

Import-Module ActiveDirectory


#######################################
#######################################
###                               #####  
###       Start Functions         #####
###                               ##### 
###                               #####
#######################################
#######################################

function checkADaccount {
    $error.Clear()
    $username = $InputBox.text;
    $check = $null
    $check = Get-ADUser -identity $username

    If ($check) {
        $info = (Get-AdUser -identity $UserName -Properties EmailAddress).EmailAddress
        $Characters = [Char[]] "bcdefhkrtx"
        $Q = ($Characters | Get-Random -count 5) -join ""
        $Characters = [Char[]] "23579"
        $Q1 = ($Characters | Get-Random -count 3) -join ""
        $Generate = ("A") + ((($Q+$Q1) -split '' | Sort-Object {Get-Random}) -join '')

        # GUI will now ask for confirmation of reset. Pop up will also advise users full name and email address
        $POP = new-object -comobject wscript.shell
        $confirmation = $POP.popup("Are you sure you want to reset the password for $username ?" + ("`r`n") + ("`r`n") + "Name: " + $c + ("`r`n") + "Email Address: " + (Get-ADUser $username -properties mail).mail , ` 0,"Confirm Password Reset" ,1)

        # Users password will now change to generated one, AD will also unlock, Prompt user to change after first log on
        IF ($confirmation -eq 1) {
            $error.clear()
            Set-ADAccountPassword $username -NewPassword (ConvertTo-SecureString $Generate -AsPlainText -force)
            Unlock-ADAccount -identity $username
            Set-ADUser -Identity $username -ChangePasswordAtLogon $True

            $Generate | Clip  

            Switch ($?) {
                True {
                    $accountResult = Write-Output("The following AD account has being amended: $username " + "`r`n")
                    $GenerateResult = Write-Output(("[") + (Get-datesortable) +("] - Password generated: " +$Generate+  ""))
                    $outputBox.Appendtext(($accountResult + ("`r`n") + $GenerateResult) + ("`r`n(Copied to Clipboard)`r`n") + ("`r`n"))
                }
                False {
                    $outputBox.Appendtext(("[") + (Get-datesortable) +("] - No change has taken place to AD account: $username") + $error.FullyQualifiedErrorId + ("`r`n") + ("`r`n"))
                   
                }
            }
        } Else {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - No change has taken place to AD account: $username") + ("`r`n") + ("`r`n"))
           
        }
    } Else {
        $accountResult = Write-Output ("Error! Username: " + $username + " does not exists on Active Directory.")
        $msg = command 2>&1
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - ") + ("$error") + ("`r`n") + ("`r`n"))
        $OutputBox.ContainsFocus
       
    }
}

function softwareCycle{
    $error.Clear()
    $check = $null
    
    If($inputBox2.text){
        $outputBox.Appendtext(("`r`n") +  "Please Wait......" + ("`r`n"))
        $Computer = $inputBox2.text
        $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
        $ok1 = $current1 -match "CN=(?<content>.*)"
        $ok1 = $matches['content']
        $ok1 = $ok1.split(',')[0] 
        $Computer = $ok1
    
        If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" } 
        
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Testing connection to $Computer.")

        $outputBox.Appendtext(("`r`n") + ("`r`n") + "Please Wait......")

        $PC = Test-Connection $Computer

        IF ($PC) {       
            $outputBox.Appendtext(("`r`n") + ("`r`n") + "Connection established. ✓")
            $outputBox.Appendtext(("`r`n") + ("`r`n") + "Please Wait......"+ ("`r`n"))

            
$SCCMClient = [wmiclass] “\\$Computer\root\ccm:SMS_Client”;
$SCCMClient | Get-Member;

get-wmiobject CCM_Scheduler_ScheduledMessage -namespace root\ccm\policy\machine\actualconfig | select-object ScheduledMessageID, TargetEndPoint | where-object {$_.TargetEndPoint -ne “direct:execmgr”}

try{
    Invoke-WmiMethod -ComputerName $Computer -Namespace root\ccm -Class sms_Client -Name TriggerSchedule “{00000000-0000-0000-0000-000000000002}”
}
catch{
$outputBox.Appendtext(("`r`n") + " Software Inventory // " + $_.Exception.Message + ("`r`n"));
}
      
          
try{
Invoke-WmiMethod -ComputerName $Computer -Namespace root\ccm -Class sms_Client -Name TriggerSchedule “{00000000-0000-0000-0000-000000000102}”
}
catch{
$outputBox.Appendtext(("`r`n") + " Software Inventory Collection Cycle // " + $_.Exception.Message + ("`r`n"));
}


try{
Invoke-WmiMethod -ComputerName $Computer -Namespace root\ccm -Class sms_Client -Name TriggerSchedule “{00000000-0000-0000-0000-000000000108}”
}
catch{
$outputBox.Appendtext(("`r`n") + " Software Updates Assignments Evaluation Cycle // " + $_.Exception.Message + ("`r`n"));
} 



try{
Invoke-WmiMethod -ComputerName $Computer -Namespace root\ccm -Class sms_Client -Name TriggerSchedule “{00000000-0000-0000-0000-000000000121}”
}
catch{
$outputBox.Appendtext(("`r`n") + " Application Manager Policy // " + $_.Exception.Message + ("`r`n"));
}


try{
Invoke-WmiMethod -ComputerName $Computer -Namespace root\ccm -Class sms_Client -Name TriggerSchedule “{00000000-0000-0000-0000-000000000122}”
}
catch{
$outputBox.Appendtext(("`r`n") + " Application Manager User Policy Action // " + $_.Exception.Message + ("`r`n"));
}


try{
Invoke-WmiMethod -ComputerName $Computer -Namespace root\ccm -Class sms_Client -Name TriggerSchedule “{00000000-0000-0000-0000-000000000022}”
}
catch{
$outputBox.Appendtext(("`r`n") + " Evaluate Machine Policies // " + $_.Exception.Message + ("`r`n"));
}



                
            #Invoke-WMIMethod $Computer $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule “{00000000-0000-0000-0000-000000000002}”
            #Invoke-WMIMethod $Computer $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule “{00000000-0000-0000-0000-000000000102}”
            #Invoke-WMIMethod $Computer $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule “{00000000-0000-0000-0000-000000000108}”
            #Invoke-WMIMethod $Computer $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule “{00000000-0000-0000-0000-000000000121}”
            #Invoke-WMIMethod $Computer $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule “{00000000-0000-0000-0000-000000000122}”
            #Invoke-WMIMethod $Computer $Server -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule “{00000000-0000-0000-0000-000000000022}”

            $outputBox.Appendtext(("`r`n")+ "...software actions have been cycled on $Computer." + ("`r`n") + ("`r`n") + "Re-check the device's software centre for deployment status.")
            $outputBox.Appendtext(("`r`n"))
        } Else {
            $outputBox.Appendtext(("`r`n") + "$Computer cannot be contacted, please check the asset tag with the user.")
            $outputBox.Appendtext(("`r`n"))   
        }

    } Else {
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Please enter a valid asset tag first!")
        $outputBox.Appendtext(("`r`n"))
    }    
}


function CordiaGen {
    $error.Clear()
    $username = $InputBox.text;
    $check = $null
    $check = Get-ADUser -identity $username    

    $randWord = 'Winter','Autumn','Balloon','Explore','Bottle','Silver','Summer','Desktop','Notepad','Pencil','Return','Sunshine','Window','Orange','Yellow','Screen','String','Waterfall','Toolkit','Carpet','Holiday','Coffee','Football','Garden','Batman','Manbat'

    $Characters = [Char[]] "135679"
    $Q = ($Characters | Get-Random -count 2) -join ""
    $Characters = [Char[]] "2468"
    $Q2 = ($Characters | Get-Random -count 1) -join ""
        
    $randWord = $randWord | Sort-Object {Get-Random}
    $shufrandWord = $randWord | Sort-Object {Get-Random}
    $Generate = ($shufrandWord[0] + $Q + $Q2)

    $GenerateResult = Write-Output(("[") + (Get-datesortable) +("] - Password generated: " +$Generate+  ""))
    $outputBox.Appendtext(("$GenerateResult") + ("`r`n(Copied to Clipboard)`r`n") + ("`r`n"))
    $Generate | Clip                          
}

function Cordia {
    $error.Clear()
    $username = $InputBox.text;
    $check = $null
    $check = Get-ADUser -identity $username

    If ($check) {
        $info = (Get-AdUser -identity $username -Properties EmailAddress).EmailAddress
        
        $Characters = [Char[]] "bcdefhkrtx"
        $Q = ($Characters | Get-Random -count 5) -join ""
        $Characters = [Char[]] "23579"
        $Q1 = ($Characters | Get-Random -count 3) -join ""
        $Generate = ("A") + ((($Q+$Q1) -split '' | Sort-Object {Get-Random}) -join '')
                

        # GUI will now ask for confirmation of reset. Pop up will also advise users full name and email address
        $POP = new-object -comobject wscript.shell
        $confirmation = $POP.popup("Are you sure you want to reset the password for $username ?" + ("`r`n") + ("`r`n") + "Name: " + $c + ("`r`n") + "Email Address: " + (Get-ADUser $username -properties mail).mail , ` 0,"Confirm Password Reset" ,1)

        # Users password will now change to generated one, AD will also unlock, Prompt user to change after first log on
        IF ($confirmation -eq 1) {
            $error.clear()
            Set-ADAccountPassword $username -NewPassword (ConvertTo-SecureString $Generate -AsPlainText -force)
            Unlock-ADAccount -identity $username
            Set-ADUser -Identity $username -ChangePasswordAtLogon $False

            $Generate | Clip

            Switch ($?) {
                True {
                    $accountResult = Write-Output("The following AD account has being amended: $username " + "`r`n")
                    $GenerateResult = Write-Output(("[") + (Get-datesortable) +("] - Password generated: " +$Generate+  ""))
                    $outputBox.Appendtext(($accountResult + ("`r`n") + $GenerateResult) + ("`r`n(Copied to Clipboard)`r`n") + ("`r`n"))
                    $msg = 1
                   
                }
                False {
                    $outputBox.Appendtext(("[") + (Get-datesortable) +("] - No change has taken place to AD account: $username") + $error.FullyQualifiedErrorId + ("`r`n") + ("`r`n"))
                   
                }
            }
        } Else {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - No change has taken place to AD account: $username") + ("`r`n") + ("`r`n"))
           
        }
    } Else {
        $accountResult = Write-Output ("Error! Username: " + $username + " does not exists on Active Directory.")
        $msg = command 2>&1
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - ") + ("$error") + ("`r`n") + ("`r`n"))
        $OutputBox.ContainsFocus
       
    }
}


function GeneratePassword {
    $Characters = [Char[]] "bcdefhkrtx"
    $Q = ($Characters | Get-Random -count 5) -join ""
    $Characters = [Char[]] "23579"
    $Q1 = ($Characters | Get-Random -count 3) -join ""
    $Generate = ("A") + ((($Q+$Q1) -split '' | Sort-Object {Get-Random}) -join '')
    $GenerateResult = Write-Output(("[") + (Get-datesortable) +("] - Password generated: " +$Generate+  ""))
    $outputBox.Appendtext(("$GenerateResult") + ("`r`n(Copied to Clipboard)`r`n") + ("`r`n"))
    $Generate | Clip    
}

function deployURL {
    $error.Clear()
    $check = $null
    
    If($inputBox2.text){
        $outputBox.Appendtext(("`r`n") +  "Please Wait......" + ("`r`n"))
        $Computer = $inputBox2.text
        $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
        $ok1 = $current1 -match "CN=(?<content>.*)"
        $ok1 = $matches['content']
        $ok1 = $ok1.split(',')[0] 
        $Computer = $ok1
    
        If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" } 
        
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Testing connection to $Computer.")

        $outputBox.Appendtext(("`r`n") + ("`r`n") + "Please Wait......")

        $PC = Test-Connection $Computer

        IF ($PC) { 

            $Menu = 'Business Objects','Carefirst','Dips','Gold','iWorld','LS/CMI','MyPortal','NetLoan','OWA','Pulse','Xerox Equitrac'
            $Result = $Menu | Out-GridView -PassThru  -Title 'Make a  selection'
            
            $outputBox.Appendtext($Result)

            
            if ($Result -eq 'NetLoan'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\netloan_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "NetLoan shortcut deployed to user's desktop.")
            }
            
            if ($Result -eq 'Business Objects'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\BI_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "Business Objects shortcut deployed to user's desktop.")
            }

            if ($Result -eq 'Dips'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\Dips_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "Dips shortcut deployed to user's desktop.")
            }
            
            
            if ($Result -eq 'iWorld'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\iWorld_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "iWorld Live/Training/Pratice shortcut deployed to user's desktop.")
            }

            if ($Result -eq 'Pulse'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\Pulse_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "Pulse shortcut deployed to user's desktop.")
            }

            if ($Result -eq 'MyPortal'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\MyPortal_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "MyPortal shortcut deployed to user's desktop.")
            }

            if ($Result -eq 'LS/CMI'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\Lscmi_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "LS/CMI shortcut deployed to user's desktop.")
            }

            if ($Result -eq 'Gold'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\Gold_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "Gold shortcut deployed to user's desktop.")
            }

            if ($Result -eq 'OWA'){

                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\OWA_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "OWA shortcut deployed to user's desktop.")
            }

            if ($Result -eq 'Carefirst'){
                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\Carefirst_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "Carefirst shortcut deployed to user's desktop.")
            }

            if ($Result -eq 'Xerox Equitrac'){
                $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\Xerox_Url.bat"

                Start-Process -filePath $currentPsPath $Computer

                $outputBox.Appendtext(("`r`n") + ("`r`n") + "Xerox Equitrac shortcut deployed to user's desktop.")
            }
        } Else {
            $outputBox.Appendtext(("`r`n") + "$Computer cannot be contacted, please check the asset tag with the user.")
            $outputBox.Appendtext(("`r`n"))   
        }

    } Else {
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Please enter a valid asset tag first!")
        $outputBox.Appendtext(("`r`n"))
    }
}


function AD-Unlock {
    $error.Clear()
    $username = $InputBox.text;
    $check = $null
    $check = Get-ADUser -identity $username

    IF ($check) {
        $info = (Get-AdUser -identity $username -Properties EmailAddress).EmailAddress
        $string = "$info"
        $a,$b = $info.split('@',2)
        $c = $a.split('.',2)
        $POP = new-object -comobject wscript.shell
        $confirmation = $POP.popup("Are you sure you want to unlock AD user account $username ?" + ("`r`n") + ("`r`n") + "Name: " + $c + ("`r`n") + "Email Address: " + $info , ` 0," Unlock" ,1)

        IF ($confirmation -eq 1) {
            $error.clear()
            Unlock-ADAccount -identity $username

            Switch ($?) {
                True {
                    $accountResult = Write-Output(("AD Account Unlocked: " + $username + "."))
                    $msg = 1
                    $outputBox.Appendtext(("[") + (Get-datesortable) +("] - $accountResult") + ("`r`n") + ("`r`n"))
                   
                }
                False {
                    $outputBox.Appendtext(("[") + (Get-datesortable) +("] - No change has taken place to AD account: $username")+ ("`r`n") + $error.FullyQualifiedErrorId + ("`r`n") + ("`r`n"))
                }
            }
        } ELSE {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - No change has taken place to AD account: $username") + ("`r`n") + ("`r`n"))
            
        }
    } Else {
        $ADUnlockResult = Write-Output ("Error! Username: " + $username + " does not exists on Active Directory.")
        $msg = command 2>&1
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - ") + ("$error") + ("`r`n") + ("`r`n"))
        #$OutputBox.ContainsFocus
        
    }
}

# This will run gpupdate/force on users machine via asset tag entry in gui with message to user#
function GP-UpDate {
    $error.Clear()
    $check = $null
    $Computer = $InputBox2.text;
    If($inputBox2.text){
        if ($Computer.length -lt 8) {
        
            $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
            $ok1 = $current1 -match "CN=(?<content>.*)"
            $ok1 = $matches['content']
            $ok1 = $ok1.split(',')[0] 
            $Computer = $ok1
            #$outputBox.Appendtext($ok1)    
            If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" }

            If($Computer.length -lt 4){ 
                $Computer = $inputBox2.text
                $Computer = "CSG$Computer.csglasgow.local" 
            } 

        } 

        Get-GPOReport -ComputerName $Computer -ReportType HTML -Path "C:\Users\Public\Desktop\Service_Desk_Toolkit\results\gpresults.html"
        Start "C:\Users\Public\Desktop\Service_Desk_Toolkit\results\gpresults.html"
    
        $Run = Invoke-WmiMethod -ComputerName $Computer -Path win32_process -Name create -ArgumentList "gpupdate /force/" #wait:5"
        $Run = Invoke-WmiMethod -ComputerName $Computer -Path win32_process -Name create -ArgumentList "ipconfig /flushdns" #wait:5"
        $msg = "A Group Policy update and DNS Flush has been performed on this device by the GCC Service Desk, please restart the device."
        Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList "msg * $msg" -ComputerName $Computer

        IF ($Run) {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Group Policy update and DNS Flush performed on device $Computer ✓") + ("`r`n") + ("`r`n"))
            
        } Else {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Tried to run command gpupdate /force on PC $Computer") + ("`r`n") + ("                    - Device $Computer is not contactable.") + ("`r`n") + ("`r`n"))
           
        }
    } Else {
        $outputBox.Appendtext("Please provide the asset tag")
    }
}


# Backdoor into users C: Drive (C$)#
function C-Drive {
    $error.Clear()
    $check = $null
    $Computer = $InputBox2.text;
    If($inputBox2.text){
        If ($Computer.length -lt 8) {
            $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
            $ok1 = $current1 -match "CN=(?<content>.*)"
            $ok1 = $matches['content']
            $ok1 = $ok1.split(',')[0] 
            $Computer = $ok1
            #$outputBox.Appendtext($ok1) 
               
            If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" }
            If($Computer.length -lt 4){ 
                $Computer = $inputBox2.text
                $Computer = "CSG$Computer.csglasgow.local" 
            }  
        }


        $Run = Test-Path "\\$Computer\c$"

        If ($Run) {
            Invoke-Item "\\$Computer\c$"
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Successfully accessed $Computer C: Drive ✓") + ("`r`n") + ("`r`n"))
            
        } Else {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Unable to access C:") + ("`r`n") + ("                    - Device $Computer is not contactable.") + ("`r`n") + ("`r`n"))
            
        }
    }Else {
        $outputBox.Appendtext("Please provide the asset tag")
    }
}

# ****RETIRED **** All USB's connected to current PC + Displays Out-Gridview as unable to show in GUI #
#function USB1 {
#    $error.Clear()
#    $check = $null
#    $Computer = $InputBox2.text;
#    If($inputBox2.text){
#        If ($Computer.length -lt 8) {
#            $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
#            $ok1 = $current1 -match "CN=(?<content>.*)"
#            $ok1 = $matches['content']
#            $ok1 = $ok1.split(',')[0] 
#            $Computer = $ok1
#            #$outputBox.Appendtext($ok1)    
#            If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" } 
#            If($Computer.length -lt 4){ 
#                $Computer = $inputBox2.text
#                $Computer = "CSG$Computer.csglasgow.local" 
#            } 
#    }
#
#    #$100 = Get-WmiObject Win32_USBControllerDevice -ComputerName $Computer
#
#        IF ($100) {
#            $Result = Get-WmiObject Win32_USBControllerDevice -ComputerName $Computer | %{[wmi]($_.Dependent)} | Select-Object SystemName,Description,Manufacturer | Out-GridView #| Format-Table -AutoSize
#            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - $Computer Connected USB Drives :") + ("`r`n") + ("`r`n"))
#            
#        } Else {
#            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Unable to access $Computer USB Drives") + ("`r`n") + ("                    - Device asset $Computer is not contactable.") + ("`r`n") + ("`r`n"))
#           
#        }
#    } Else {
#        $outputBox.Appendtext("Please provide the asset tag")
#    }
#}

#this fuction cleans the temporary files and prefetch on the target machine
function tempClean {    
    $error.Clear()
    $check = $null
    
    If($inputBox2.text){
        $outputBox.Appendtext(("`r`n") +  "Please Wait......" + ("`r`n"))
        $Computer = $inputBox2.text
        $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
        $ok1 = $current1 -match "CN=(?<content>.*)"
        $ok1 = $matches['content']
        $ok1 = $ok1.split(',')[0] 
        $Computer = $ok1
    
        If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" } 
        
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Testing connection to $Computer.")

        $outputBox.Appendtext(("`r`n") + ("`r`n") + "Please Wait......")

        $PC = Test-Connection $Computer

        IF ($PC) {       
            $outputBox.Appendtext(("`r`n") + ("`r`n") + "Connection established. ✓"+("`r`n")+("`r`n")+"Loading batch file....")
                $outputBox.Appendtext(("`r`n") + ("`r`n") + "Please Wait......")
                
            #$currentPsPath= Split-Path $psise.CurrentFile.FullPath
            $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\tempClean.bat"

            Start-Process -filePath $currentPsPath $Computer

            $outputBox.Appendtext("batch file started in command prompt, removing temporary files from $Computer." + ("`r`n") + ("`r`n") + "Please allow the batch file to run, any encountered errors will be displayed in command prompt.")
            $outputBox.Appendtext(("`r`n"))
        } Else {
            $outputBox.Appendtext(("`r`n") + "$Computer cannot be contacted, please check the asset tag with the user.")
            $outputBox.Appendtext(("`r`n"))   
        }

    } Else {
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Please enter a valid asset tag first!")
        $outputBox.Appendtext(("`r`n"))
    }
}


function PING {
     $error.Clear()
    $check = $null
    
    If($inputBox2.text){
        $outputBox.Appendtext(("`r`n") +  "Please Wait......" + ("`r`n"))
        $Computer = $inputBox2.text
        $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
        $ok1 = $current1 -match "CN=(?<content>.*)"
        $ok1 = $matches['content']
        $ok1 = $ok1.split(',')[0] 
        $Computer = $ok1
    
        If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" } 
        
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Testing connection to $Computer.")

        $outputBox.Appendtext(("`r`n") + ("`r`n") + "Please Wait......")

        $PC = Test-Connection $Computer

        IF ($PC) {       
            $outputBox.Appendtext(("`r`n") + ("`r`n") + "Connection established. ✓"+("`r`n")+("`r`n")+"Loading batch file....")
            $outputBox.Appendtext(("`r`n") + ("`r`n") + "Please Wait......")
                
            #$currentPsPath= Split-Path $psise.CurrentFile.FullPath
            $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\commsTest.bat"

            Start-Process -filePath $currentPsPath $Computer

            $outputBox.Appendtext("batch file started in command prompt, testing Comms to $Computer." + ("`r`n") + ("`r`n") + "Please allow the batch file to run, any encountered errors will be displayed in command prompt.")
            $outputBox.Appendtext(("`r`n"))
        } Else {
            $outputBox.Appendtext(("`r`n") + "$Computer cannot be contacted, please check the asset tag with the user.")
            $outputBox.Appendtext(("`r`n"))   
        }

    } Else {
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Please enter a valid asset tag first!")
        $outputBox.Appendtext(("`r`n"))
    }
}

# Applications list of remove machine
function APPS {
    $error.Clear()
    $check = $null
    $Computer = $InputBox2.text;
    
    If($inputBox2.text){
        If ($Computer.length -lt 8) {
        $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
        $ok1 = $current1 -match "CN=(?<content>.*)"
        $ok1 = $matches['content']
        $ok1 = $ok1.split(',')[0] 
        $Computer = $ok1
        #$outputBox.Appendtext($ok1)    
        If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" } 
    }

    $Run = Test-Path "\\$Computer\c$"

    IF ($Run) {
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Loading applications, please wait...") + ("`r`n") + ("`r`n"))

        Function Get-RemoteProgram {
           
                [CmdletBinding(SupportsShouldProcess=$true)]
                param(
                    [Parameter(ValueFromPipeline              =$true,
                               ValueFromPipelineByPropertyName=$true,
                               Position=0
                    )]
                    [string[]]
                        $ComputerName = $env:COMPUTERNAME,
                    [Parameter(Position=0)]
                    [string[]]
                        $Property,
                    [switch]
                        $ExcludeSimilar,
                    [int]
                        $SimilarWord
                )

                begin {
                    $RegistryLocation = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\',
                                        'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'
                    $HashProperty = @{}
                    $SelectProperty = @('ProgramName','ComputerName')
                    if ($Property) {
                        $SelectProperty += $Property
                    }
                }

                process {
                    foreach ($Computer in $ComputerName) {
                        $RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
                        $RegistryLocation | ForEach-Object {
                            $CurrentReg = $_
                            if ($RegBase) {
                                $CurrentRegKey = $RegBase.OpenSubKey($CurrentReg)
                                if ($CurrentRegKey) {
                                    $CurrentRegKey.GetSubKeyNames() | ForEach-Object {
                                        if ($Property) {
                                            foreach ($CurrentProperty in $Property) {
                                                $HashProperty.$CurrentProperty = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue($CurrentProperty)
                                            }
                                        }
                                        $HashProperty.ComputerName = $Computer
                                        $HashProperty.ProgramName = ($DisplayName = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('DisplayName'))
                                        if ($DisplayName) {
                                            New-Object -TypeName PSCustomObject -Property $HashProperty |
                                            Select-Object -Property $SelectProperty
                                        }
                                    }
                                }
                            }
                        } | ForEach-Object -Begin {
                            if ($SimilarWord) {
                                $Regex = [regex]"(^(.+?\s){$SimilarWord}).*$|(.*)"
                            } else {
                                $Regex = [regex]"(^(.+?\s){3}).*$|(.*)"
                            }
                            [System.Collections.ArrayList]$Array = @()
                        } -Process {
                            if ($ExcludeSimilar) {
                                $null = $Array.Add($_)
                            } else {
                                $_
                            }
                        } -End {
                            if ($ExcludeSimilar) {
                                $Array | Select-Object -Property *,@{
                                    name       = 'GroupedName'
                                    expression = {
                                        ($_.ProgramName -split $Regex)[1]
                                    }
                                } |
                                Group-Object -Property 'GroupedName' | ForEach-Object {
                                    $_.Group[0] | Select-Object -Property * -ExcludeProperty GroupedName
                                }
                            }
                        }
                    }
                }
            }

        Get-RemoteProgram -ComputerName $Computer -Property DisplayVersion | Out-GridView
        #Get-WmiObject -Class Win32_Product -ComputerName $Computer | Select-Object Name,Vendor,Version | Sort-Object Name | Out-GridView
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Applications installed and uninstalled $Computer C: Drive ✓") + ("`r`n") + ("`r`n"))
        
    } Else {
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Device $Computer is not contactable.") + ("`r`n") + ("`r`n"))
       
        }
    } Else {
        $outputBox.Appendtext("Please provide the asset tag")
    }
}

###### Confirmation prompt ######
$Button100 = [System.Windows.MessageBoxButton]::YesNo
$MessageIcon = [System.Windows.MessageBoxImage]::Warning
$MessageboxTitle = “Restart PC $Computer”
$Messageboxbody = “Are you sure you wish to restart PC?”
$MessageboxTitle1 = “Shutdown PC $Computer”
$Messageboxbody1 = “Are you sure you wish to shutdown PC?”


# Restarts Users PC #
function Restart {
    $error.Clear()
    $check = $null
    $Computer = $InputBox2.text;
    $200 = Test-Path "\\$Computer\c$"

    If ($200) {
        $Confirmation = [System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$Button100,$messageicon)

        If ($Confirmation -eq "Yes"){
            Restart-Computer -ComputerName $Computer -Force
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - PC $Computer is now restarting... ") + ("`r`n") + ("`r`n"))
        } ElseIf ($Confirmation -eq "No") {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - PC $Computer Restart Cancelled ! ") + ("`r`n") + ("`r`n"))
            
        }
     } Else {
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Unable to locate $Computer") + ("`r`n") + ("                    - Device $Computer is not contactable. Please provide full asset tag.") + ("`r`n") + ("`r`n"))
        
    }
}


function DNSFlush {
     If($inputBox2.text){

        $Input100 = $inputBox2.text   

        If ($Input100.length -lt 8) {
 
            $current = Get-ADComputer -Filter "Name -like '*$Input100'"
            $ok = $current -match "CN=(?<content>.*)"
            $ok = $matches['content']    
            $ok = $ok.split(',')[0] 
            $Input100 = $ok
            #$outputBox.Appendtext($ok)    
            If($Input100 -like "*CSG*"){ $Input100 = "$Input100.csglasgow.local" } 
            
            If($Input100.length -lt 4){ 
                $ComputerName = $inputBox2.text

                $Input100 = "CSG$ComputerName.csglasgow.local" 
            } 
        }
        
        $ComputerName = (Test-Connection -count 1 $Input100).IPV4Address
    
        

        $Run = Invoke-WmiMethod -ComputerName $ComputerName -Path win32_process -Name create -ArgumentList "ipconfig /flushdns" #wait:5"
        $msg = " DNS Flush was successfully, Please restart you device"
            Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList "msg * $msg" -ComputerName $ComputerName

            IF ($Run) {
                $outputBox.Appendtext(("[") + (Get-datesortable) +("] - DNS Flush preformed & has been updated on PC $ComputerName ✓") + ("`r`n") + ("`r`n"))
               



    } Else {
         $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Please provide the Asset Tag.") + ("`r`n") + ("`r`n"))
    }

}
}

  



###Users Password history###
function PASSWORD1 {
    $error.Clear()
    $check = $null
    $SamAccountName = $InputBox.text;
    $Result = Get-ADUser -identity $SamAccountName
   

    IF ($Result) {
        $Pass = Get-ADUser -identity $SamAccountName -properties PasswordLastSet, passwordneverexpires, BadLogonCount, badPwdCount, LockoutTime, whenCreated
        $PassLAstSet = (Get-ADUser -identity $SamAccountName -properties PasswordLastSet).PasswordLastSet
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Username:                $SamAccountName ") + ("`r`n"))
        $outputBox.Appendtext(("") +(("                    - Password Last Set:       " +     $PassLastSet) + ("`r`n")))
        $outputBox.Appendtext(("") +(("                    - Password never expires:  " + $Pass.passwordneverexpires) + ("`r`n")))
        $outputBox.Appendtext(("") +(("                    - Account lockout period:  " + $Pass.LockoutTime) + ("`r`n")))
        $outputBox.Appendtext(("") +(("                    - Bad password count:      " +   $Pass.badPwdCount) + ("`r`n")))
        $outputBox.Appendtext(("") +(("                    - AD account created:      " +   $Pass.whenCreated) + ("`r`n")))
        $outputBox.Appendtext(("") +(("                    - Bad login attempts:      " +   $Pass.BadLogonCount) + ("`r`n") + ("`r`n")))
        
    } Else {
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Unable to locate username: $SamAccountName via active directory") + ("`r`n") + ("`r`n"))
       
    }
}

function Printer{
   
    $outputBox.Appendtext(("[") + (Get-datesortable) +("] - "))
    $outputBox.Appendtext("Hello`n")
    $outputBox.Appendtext("`n")

}


###Lists member of data of asset input###
function PC {
    $error.Clear()
    $check = $null
    $Computer = $InputBox2.text;
    If($inputBox2.text){
        If ($Computer.length -lt 8) {
            $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
            $ok1 = $current1 -match "CN=(?<content>.*)"
            $ok1 = $matches['content']
            $ok1 = $ok1.split(',')[0] 
            $Computer = $ok1
            #$outputBox.Appendtext($ok1)    
            If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" } 
        }

        $Result = (Test-Connection -count 1 $Computer).IPV4Address

        IF ($Result) {
            $c=$null
            $b=$null
            $a = (Get-adcomputer $Computer -Properties memberof | Select-Object MemberOf).MemberOf
            $a | foreach {
            $b = $_.split(',')[0].substring(3)
            $c += "$b `n "
        }
        $c | Out-GridView
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Asset tag $Computer is enabled" + $Member.Enabled) + ("`r`n"))
        $outputBox.Appendtext(("") + "          " +("          - Asset tag $Computer is a member of the following application groups:" + ("`r`n")+ ("`r`n")))
        
        } Else {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("]- Unable to locate asset tag $Computer on Active Driectory.") + ("`r`n") + ("`r`n"))
            
        }
    } Else {
        $outputBox.Appendtext("Please provide the asset tag")
    }
}

### AD users information ###
function UserInfo {
    $error.Clear()
    $Input100 = $InputBox.text;
    $User = Get-ADUser $Input100

    $mailboxEx = Get-Mailbox -Identity $Input100
    
    If ($User) {
     $Info = Get-ADUser $Input100 -Properties GivenName, Surname, LockedOut, Mail, Created, HomeDirectory, Enabled, Department
     $outputBox.Appendtext(("[") + (Get-datesortable) +("] - FirstName:       ") + $Info.GivenName + ("`r`n"))
     $outputBox.Appendtext(("                    - Surname:         ") +  $Info.Surname + ("`r`n"))
     $outputBox.Appendtext(("                    - Username:        $Input100"  + ("`r`n")))
     $outputBox.Appendtext(("                    - Account Locked:  ") + $Info.LockedOut + ("`r`n"))
     $outputBox.Appendtext(("                    - Email Address:   ") + $Info.Mail  + ("`r`n"))
     $outputBox.Appendtext(("                    - Account Created: ") + $Info.Created + ("`r`n"))
     $outputBox.Appendtext(("                    - Home Drive Path: ") + $Info.HomeDirectory + ("`r`n"))
     $outputBox.Appendtext(("                    - Account Enabled: ") + $Info.Enabled + ("`r`n"))
     $outputBox.Appendtext(("                    - Department:      ") + $Info.Department + ("`r`n")+ ("`r`n"))
     $outputBox.Appendtext(("                    - Exchange:      ") + $mailboxEx + ("`r`n")+ ("`r`n"))

} Else {
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Username $Input100 cannot be found in AD.") + ("`r`n") + ("`r`n"))
        
        }
   }

###Profile removal on PC ###
function DeleteProfile{
    $error.Clear()
    $check = $null

    [text]$Computer = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the asset tag of the device $deployAsset.", "Asset Tag")
                
     If($Computer){
        $outputBox.Appendtext(("`r`n") +  "Please Wait......" + ("`r`n"))
        $current1 = Get-ADComputer -Filter "Name -like '*$Computer'"
        $ok1 = $current1 -match "CN=(?<content>.*)"
        $ok1 = $matches['content']
        $ok1 = $ok1.split(',')[0] 
        $Computer = $ok1
    
        If($Computer -like "*CSG*"){ $Computer = "$Computer.csglasgow.local" } 
        
        $outputBox.Appendtext(("`r`n") + "[" + (Get-datesortable) + "]" + " - Testing connection to $Computer.")

        $outputBox.Appendtext(("`r`n") + ("`r`n") + "Please Wait......")

        $PC = Test-Connection $Computer

        IF ($PC) { 
            $outputBox.Appendtext(("`r`n") + ("`r`n") + "Connection successful!")
            [text]$userProfile = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the username that requires removal from $Computer. If all profiles need to be removed please type 'Beastmode'", "Username")
            
            IF ($userProfile) { 
                    $outputBox.Appendtext(("`r`n") + ("`r`n") + "$userProfile Batch file started in command prompt, testing Comms to $Computer." + ("`r`n") + ("`r`n") + "Please allow the batch file to run, any encountered errors will be displayed in command prompt.")
                    $outputBox.Appendtext(("`r`n"))

                    $beasty="Beastmode"

                IF ($userProfile -eq $beasty) { 

                    $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\run_delprof.bat"

                    Start-Process -filePath $currentPsPath $Computer

                }Else{

                    $currentPsPath="C:\Users\Public\Desktop\Service_Desk_Toolkit\batch\run_delprof.bat"
                    
                    Start-Process -filePath $currentPsPath "$Computer $userProfile"
                }
            }Else{
                $outputBox.Appendtext(("`r`n") + "I'll need a username first. Please re-try.")
                $outputBox.Appendtext(("`r`n")) 
            }
        }Else{
            $outputBox.Appendtext(("`r`n") + "$Computer cannot be contacted, please check the asset tag with the user and that the device has been restarted, at the login screen and has NOT been logged into.")
            $outputBox.Appendtext(("`r`n"))
        }
    }Else{
        $outputBox.Appendtext(("`r`n") + "I'll need an asset tag first. Please re-try.")
        $outputBox.Appendtext(("`r`n"))  
    }
}



### PC Shutdown ### 
function Shutdown {
    $error.Clear()
    $check = $null
    $Computer = $InputBox2.text;
    $PC = (Test-Connection -count 1 $Computer).IPV4Address

    If ($PC) {
        $Confirmation = [System.Windows.MessageBox]::Show($Messageboxbody1,$MessageboxTitle1,$Button100,$messageicon)

        If ($Confirmation -eq "Yes"){
            Stop-Computer -ComputerName $Computer -Force
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - PC $Computer is now shutting down...") + ("`r`n") + ("`r`n"))
        } ElseIf ($Confirmation -eq "No") {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - PC $Computer shutdown Cancelled ! ") + ("`r`n") + ("`r`n"))
           
        }
     } Else {
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Unable to locate asset tag $Computer") + ("`r`n") + ("                    - Device $Computer is not contactable. Please provide full asset tag.") + ("`r`n") + ("`r`n"))
        
    }
}

###List all AD users Member of information###
function MemberOf {
    $error.Clear()
    $check = $null
    $User = $InputBox.text;
    $Run3 = Get-ADUser $User

    IF ($Run3) {
        GET-ADUser -Identity $User –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | where { $_.GroupCategory -eq "Security" } | sort | Select-Object name | Out-GridView
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - User $User is a member of the following AD Groups :") + ("`r`n") + ("`r`n"))
        
    } Else {
       $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Username $User cannot be found in Active Directory :") + ("`r`n") + ("`r`n"))
       
    }
}

### Inet level change ###
function INET {
    $error.Clear()
    $check = $null
    $Username = $InputBox.text;
    $Result = Get-ADUser -identity $Username

    IF ($Result) {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

        $objForm = New-Object System.Windows.Forms.Form
        $objForm.Text = "Internet Level Options"
        $objForm.Size = New-Object System.Drawing.Size(300,200)
        $objForm.StartPosition = "CenterScreen"

        $objForm.KeyPreview = $True
        $objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter")
            {$x=$objListBox.SelectedItem;$objForm.Close()}})
        $objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
            {$objForm.Close()}})

        $OKButton = New-Object System.Windows.Forms.Button
        $OKButton.Location = New-Object System.Drawing.Size(75,120)
        $OKButton.Size = New-Object System.Drawing.Size(75,23)
        $OKButton.Text = "Ok"
        $OKButton.Add_Click({$objListBox.SelectedItem;$objForm.Close()})
        $objForm.Controls.Add($OKButton)

        $CancelButton = New-Object System.Windows.Forms.Button
        $CancelButton.Location = New-Object System.Drawing.Size(110,120)
        $CancelButton.Size = New-Object System.Drawing.Size(75,23)
        $CancelButton.Text = "Cancel"
        $CancelButton.Add_Click({$objForm.Close()})
        $objForm.Controls.Add($CancelButton)

        $objLabel = New-Object System.Windows.Forms.Label
        $objLabel.Location = New-Object System.Drawing.Size(10,20)
        $objLabel.Size = New-Object System.Drawing.Size(280,20)
        $objLabel.Text = "Please select an internet level:"
        $objForm.Controls.Add($objLabel)

        $objListBox = New-Object System.Windows.Forms.ListBox
        $objListBox.Location = New-Object System.Drawing.Size(10,40)
        $objListBox.Size = New-Object System.Drawing.Size(260,20)
        $objListBox.Height = 80

        [void] $objListBox.Items.Add("InetLevel1")
        [void] $objListBox.Items.Add("InetLevel2")
        [void] $objListBox.Items.Add("InetLevel3")
        [void] $objListBox.Items.Add("InetLevel4")
        [void] $objListBox.Items.Add("InetLevel5")
        [void] $objListBox.Items.Add("InetLevel6")
        [void] $objListBox.Items.Add("InetLevel7")

        $objForm.Controls.Add($objListBox)
        $objForm.Topmost = $True
        $objForm.Add_Shown({$objForm.Activate()})
        [void] $objForm.ShowDialog()

        $objListBox.SelectedItem
        $selection = $objListBox.SelectedItem

        If ($selection) {
            Remove-ADGroupMember -identity "inetlevel1" -Members $Username -confirm:$false
            Remove-ADGroupMember -identity "inetlevel2" -Members $Username -confirm:$false
            Remove-ADGroupMember -identity "inetlevel3" -Members $Username -confirm:$false
            Remove-ADGroupMember -identity "inetlevel4" -Members $Username -confirm:$false
            Remove-ADGroupMember -identity "inetlevel5" -Members $Username -confirm:$false
            Remove-ADGroupMember -identity "inetlevel6" -Members $Username -confirm:$false
            Remove-ADGroupMember -identity "inetlevel7" -Members $Username -confirm:$false
            Add-ADGroupMember -identity "$selection" -Members $Username

            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Internet Level Change completed ✓ ") + ("`r`n") + ("                    - User $Username now has internet level $selection."+ ("`r`n") + ("`r`n")))
           
        } Else {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Action Cancelled!")+ ("`r`n") + ("`r`n"))
           
        }
    } Else {
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Action failed!") + ("`r`n") + ("                                  -Unable to locate username $Username in active directory.") + ("`r`n") + ("`r`n"))
       
    }
}

function tempInet{
    $users = import-csv \\cpfpsclc01fs\MyDocs$\edwardstadm\Documents\Desktop\level1.csv
    Foreach ($user in $users){
        $currentUser=$($user.usernames)
        Remove-ADGroupMember -identity "inetlevel1" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel2" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel3" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel4" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel5" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel6" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel7" -Members $currentUser -confirm:$false
        Add-ADGroupMember -identity "inetlevel1" -Members $currentUser
         $outputBox.Appendtext("User: "+$currentUser+" Now Inetlevel 1   ✓ `r`n")
    }
    $outputBox.Appendtext("Finished!" + ("`r`n") + ("`r`n"))
    $currentUser=""

    $users = import-csv \\cpfpsclc01fs\MyDocs$\edwardstadm\Documents\Desktop\level2.csv
    Foreach ($user in $users){
        $currentUser=$($user.usernames)
        Remove-ADGroupMember -identity "inetlevel1" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel2" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel3" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel4" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel5" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel6" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel7" -Members $currentUser -confirm:$false
        Add-ADGroupMember -identity "inetlevel2" -Members $currentUser
        $outputBox.Appendtext("User: "+$currentUser+" Now Inetlevel 2   ✓ `r`n")
    }
    $outputBox.Appendtext("Finished!" + ("`r`n") + ("`r`n"))
    $currentUser=""

    $users = import-csv \\cpfpsclc01fs\MyDocs$\edwardstadm\Documents\Desktop\level3.csv
    Foreach ($user in $users){
        $currentUser=$($user.usernames)
        Remove-ADGroupMember -identity "inetlevel1" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel2" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel3" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel4" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel5" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel6" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel7" -Members $currentUser -confirm:$false
        Add-ADGroupMember -identity "inetlevel3" -Members $currentUser
         $outputBox.Appendtext("User: "+$currentUser+" Now Inetlevel 3   ✓ `r`n")
    }
    $outputBox.Appendtext("Finished!" + ("`r`n") + ("`r`n"))
    $currentUser=""

    $users = import-csv \\cpfpsclc01fs\MyDocs$\edwardstadm\Documents\Desktop\level4.csv
    Foreach ($user in $users){
        $currentUser=$($user.usernames)
        Remove-ADGroupMember -identity "inetlevel1" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel2" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel3" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel4" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel5" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel6" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel7" -Members $currentUser -confirm:$false
        Add-ADGroupMember -identity "inetlevel4" -Members $currentUser
         $outputBox.Appendtext("User: "+$currentUser+" Now Inetlevel 4   ✓ `r`n")
    }
    $outputBox.Appendtext("Finished!" + ("`r`n") + ("`r`n"))
    $currentUser=""

    $users = import-csv \\cpfpsclc01fs\MyDocs$\edwardstadm\Documents\Desktop\level5.csv
    Foreach ($user in $users){
        $currentUser=$($user.usernames)
        Remove-ADGroupMember -identity "inetlevel1" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel2" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel3" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel4" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel5" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel6" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel7" -Members $currentUser -confirm:$false
        Add-ADGroupMember -identity "inetlevel5" -Members $currentUser
         $outputBox.Appendtext("User: "+$currentUser+" Now Inetlevel 5   ✓ `r`n")
    }
    $outputBox.Appendtext("Finished!" + ("`r`n") + ("`r`n"))
    $currentUser=""

    $users = import-csv \\cpfpsclc01fs\MyDocs$\edwardstadm\Documents\Desktop\level6.csv
    Foreach ($user in $users){
        $currentUser=$($user.usernames)
        Remove-ADGroupMember -identity "inetlevel1" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel2" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel3" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel4" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel5" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel6" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel7" -Members $currentUser -confirm:$false
        Add-ADGroupMember -identity "inetlevel6" -Members $currentUser
         $outputBox.Appendtext("User: "+$currentUser+" Now Inetlevel 6   ✓ `r`n")
    }
    $outputBox.Appendtext("Finished!" + ("`r`n") + ("`r`n"))
    $currentUser=""

    $users = import-csv \\cpfpsclc01fs\MyDocs$\edwardstadm\Documents\Desktop\level7.csv
    Foreach ($user in $users){
        $currentUser=$($user.usernames)
        Remove-ADGroupMember -identity "inetlevel1" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel2" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel3" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel4" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel5" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel6" -Members $currentUser -confirm:$false
        Remove-ADGroupMember -identity "inetlevel7" -Members $currentUser -confirm:$false
        Add-ADGroupMember -identity "inetlevel7" -Members $currentUser
         $outputBox.Appendtext("User: "+$currentUser+" Now Inetlevel 7   ✓ `r`n")
    }
    $outputBox.Appendtext("Finished!" + ("`r`n") + ("`r`n"))
}

# Applications running on remote machine #
function Processes {
    $error.Clear()
    $check = $null
    $Input100 = $InputBox2.text;
    If($inputBox2.text){
        If ($Input100.length -lt 8) {
            $current1 = Get-ADComputer -Filter "Name -like '*$Input100'"
            $ok1 = $current1 -match "CN=(?<content>.*)"
            $ok1 = $matches['content']
            $ok1 = $ok1.split(',')[0] 
            $Input100 = $ok1
            #$outputBox.Appendtext($ok1)    
            If($Input100 -like "*CSG*"){ $Input100 = "$Input100.csglasgow.local" } 
        }

        $selectedApp = ""
	    $Applist = @()
        $Result = (Test-Connection -count 1 $Input100).IPV4Address
    
        If ($Result) {
            [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
            $objForm2 = New-Object System.Windows.Forms.Form 
	        $objForm2.Text = "Select Application(s)"
	        $objForm2.Size = New-Object System.Drawing.Size(300,320) 
	        $objForm2.StartPosition = "CenterScreen"
            $objForm2.MinimizeBox = $True
            $objForm2.MaximizeBox = $False
            $objForm2.FormBorderStyle = "Fixed3D"
            $objForm2.AutoSize = $True
	        $btnDelete1 = New-Object System.Windows.Forms.Button
	        $btnDelete1.Location = New-Object System.Drawing.Size(20,140)
	        $btnDelete1.Size = New-Object System.Drawing.Size(110,23)
	        $btnDelete1.Text = "Kill App"
	        $objForm2.Controls.Add($btnDelete1)

            $btnDelete1.Add_Click({KillProcess;$objForm2.Close()})

            $CancelButton2 = New-Object System.Windows.Forms.Button
	        $CancelButton2.Location = New-Object System.Drawing.Size(110,140)
	        $CancelButton2.Size = New-Object System.Drawing.Size(110,23)
	        $CancelButton2.Text = "Cancel"
	        $CancelButton2.Add_Click({$objForm2.Close()})
	        $objForm2.Controls.Add($CancelButton2)
            $objLabel2 = New-Object System.Windows.Forms.Label 
	        $objLabel2.Location = New-Object System.Drawing.Size(10,20) 
	        $objLabel2.Size = New-Object System.Drawing.Size(280,20)
	        $objLabel2.Text = "Please select application(s) to kill:"
	        $objForm2.Controls.Add($objForm2) 
            $objListBox1 = New-Object System.Windows.Forms.ListBox
            $objListBox1.Location = New-Object System.Drawing.Size(10,40) 
            $objListBox1.Size = New-Object System.Drawing.Size(260,300) 
            $objListBox1.Height = 180
            $objListBox1.SelectionMode = "MultiExtended"
            $List = (Get-WmiObject -ComputerName $Input100 Win32_Process).Name | Sort-Object Name -Descending
        
            ForEach($App in $List) {
                [void] $objListBox1.Items.Add($App)
            }
    
        $objForm2.Controls.Add($objListBox1) 
	    $objForm2.Topmost = $True
	    $objForm2.Add_Shown({$objForm2.Activate()})
	    [void] $objForm2.ShowDialog()
        } Else {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Unable to access $Input100") + ("`r`n") + ("                    - Device $Input100 is not contactable.") + ("`r`n") + ("`r`n"))
           
        }
    } Else {
        $outputBox.Appendtext("Please provide the asset tag")
    }
}     


Function KillProcess {
    ForEach ($processName in $objListBox1.SelectedItems) {
        $ComputerName = $InputBox2.text;

        If($inputBox2.text){
            If ($ComputerName.length -lt 8) {

                $current1 = Get-ADComputer -Filter "Name -like '*$Input100'"
                $ok1 = $current1 -match "CN=(?<content>.*)"
                $ok1 = $matches['content']
                $ok1 = $ok1.split(',')[0] 
                $Input100 = $ok1
                #$outputBox.Appendtext($ok1)    
                If($Input100 -like "*CSG*"){ $Input100 = "$Input100.csglasgow.local" }
            } 

            $Processes = Get-WmiObject -Class Win32_Process -ComputerName $ComputerName -Filter "name='$processName'"

            foreach ($process1 in $Processes) {
                $returnval = $process1.terminate()
                $processid = $process1.handle

                If($returnval.returnvalue -eq 0) {
                    $outputBox.Appendtext(("[") + (Get-datesortable) +("] - The process $processName `($Processid`) terminated successfully") + ("`r`n")+ ("`r`n"))
                } else {
                    $outputBox.Appendtext(("[") + (Get-datesortable) +("] - The process $processName `($Processid`) termination has some problems") + ("`r`n")+ ("`r`n"))
                }
            }
        } Else {
            $outputBox.Appendtext("Please provide the asset tag")
        }
    }
}
    
### Users profiles on searched asset tag ###
function RemoteDSK {
    $error.Clear()

    If($inputBox2.text){

        $Input100 = $inputBox2.text   

        If ($Input100.length -lt 8) {

            
            $current = Get-ADComputer -Filter "Name -like '*$Input100'"
            $ok = $current -match "CN=(?<content>.*)"
            $ok = $matches['content']    
            $ok = $ok.split(',')[0] 
            $Input100 = $ok
            #$outputBox.Appendtext($ok)    
            If($Input100 -like "*CSG*"){ $Input100 = "$Input100.csglasgow.local" } 
            
            If($Input100.length -lt 4){ 
                $ComputerName = $inputBox2.text

                $Input100 = "CSG$ComputerName.csglasgow.local" 
            } 
        }
        
        $ComputerName = (Test-Connection -count 1 $Input100).IPV4Address
    
        If ($ComputerName) {
            Start-Process "C:\Program Files (x86)\configmgrConsole\bin\i386\CmRcViewer.exe" -ArgumentList $Input100 
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Attempting to Remote :  $Input100 ") + ("`r`n") + ("`r`n"))    
        } Else {
            $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Unable to remote asset $Input100") + ("`r`n") + ("                    - Device asset $Input100 is not contactable.") + ("`r`n") + ("`r`n"))
           
        }
    } Else {
         $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Please provide the Asset Tag.") + ("`r`n") + ("`r`n"))
    }
}

#### Deploy Software Function ####
function AddSoft {
    $deployAsset = $inputbox2.text
    $deploydeploy = $false

    if ($deployAsset){
        $current = Get-ADComputer -Filter "Name -like '*$deployAsset'"
        $ok = $current -match "CN=(?<content>.*)"
        $ok = $matches['content']
        $queryCount = $ok.count
        if ($queryCount -eq 1) {
           
            $ok = $ok.split(',')[0] 
            $deployAsset = $ok

            if ($queryCount -eq 1) {
                $deploydeploy = $true
            }elseif ($queryCount -gt 1){
                [System.Windows.Forms.MessageBox]::Show("More than one asset found: $deployAsset","Duplicate Asset!",[windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::Warning)
                $deploydeploy = $false
            }else{
                [System.Windows.Forms.MessageBox]::Show("Computer not found in AD: $deployAsset","Device not Found!",[windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::Warning)
                $deploydeploy = $false
            }


            if ($deploydeploy){
                [text]$softPackage = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the name of the package you want to deploy on $deployAsset.", "Package to Deploy")
                
                if($softPackage){
                    $GroupExists = Get-ADGroup -Identity $softPackage
                    if ($GroupExists){

                        $softPackage = $ListApps.SelectedItem.ToString()

                        $Group = Get-ADGroup -Identity $softPackage 

                        $member = Get-ADComputer -Identity "$deployAsset" -Properties MemberOf | Select-Object MemberOf
                        $pc = Get-ADComputer "$deployAsset" | Select -expand SamAccountName

                        if ($member.Memberof -like "$Group"){
                            [System.Windows.Forms.MessageBox]::Show("$deployAsset is already a member of $softPackage","Whoops!",[windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::Warning)
                        }else{
                            Add-ADGroupMember $softPackage $pc -passthru
                            [System.Windows.Forms.MessageBox]::Show("$deployAsset has been added to $softPackage", "Success!",[windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::Information)  
                        } 
                    }else{
                        [System.Windows.Forms.MessageBox]::Show("Package '$softPackage' does not exist.", "Failed!",[windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::Warning) 
                        
                    }
                }else{
                     [System.Windows.Forms.MessageBox]::Show("Package not selected.", "Failed!",[windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::Warning)  
                }
            }
        }else{
             [System.Windows.Forms.MessageBox]::Show("More than one asset found: $queryCount","Try Again!",[windows.forms.messageboxbuttons]::Ok, [windows.forms.messageboxicon]::Warning)
        }
    }else{
        $softPackage=[System.Windows.Forms.Messagebox]::Show("You must enter an asset tag before trying to deploy.","Asset Tag",[System.Windows.Forms.MessageBoxButtons]::Warning)
    }
}

### PC perforance check ###
function SlowPC {
    $error.Clear()
    $check = $null
    $ComputerName = $InputBox2.text;
    If($inputBox2.text){
        If ($ComputerName.length -lt 8) {
            $current = Get-ADComputer -Filter "Name -like '*$ComputerName'"
            $ok = $current -match "CN=(?<content>.*)"
            $ok = $matches['content']    
            $ok = $ok.split(',')[0] 
            $ComputerName = $ok
            #$outputBox.Appendtext($ok)    
            If($ComputerName -like "*CSG*"){ $ComputerName = "$ComputerName.csglasgow.local" } 
        }

    $Result = (Test-Connection -count 1 $ComputerName).IPV4Address

    IF ($Result) {

        Add-Type -AssemblyName System.Windows.Forms 
        $Form = New-Object system.Windows.Forms.Form
        $Label = New-Object System.Windows.Forms.Label
        $Form.Controls.Add($Label)
        $Label.Text = "Retrieving Data, please wait..."
        $Label.AutoSize = $True
        $Form.Visible = $True
        $Form.Update()

        $wmi = Get-WmiObject -class Win32_OperatingSystem -computer $ComputerName
        $LBTime = $wmi.ConvertToDateTime($wmi.Lastbootuptime)
        [TimeSpan]$uptime1 = New-TimeSpan $LBTime $(get-date) 

        $TempSize = "{0:N2}" -f ((get-childitem -path "\\$ComputerName\c$\temp" -recurse | Measure-Object -property length -sum ).sum /1MB)

        $cpuSpeed = ((get-wmiobject Win32_Processor).MaxClockSpeed)/1000
        $Speed = ("{0}GHz" -f  $cpuspeed)

        $WMIComputerSystem = Get-WmiObject –ComputerName $ComputerName –Class Win32_ComputerSystem

        $Table23 = Get-WmiObject Win32_logicaldisk -ComputerName $ComputerName | Format-Table DeviceID, `
        @{Name="Size(GB)";Expression={[decimal]("{0:N0}" -f($_.size/1gb))}}, `
        @{Name="Free Space(GB)";Expression={[decimal]("{0:N0}" -f($_.freespace/1gb))}}, `
        @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}} -AutoSize | Out-String

        $OutString1 = Get-WmiObject WIN32_PROCESS -ComputerName $ComputerName | Sort-Object -Property ws -Descending |select -first 5 | Select Name, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}} | Format-Table -AutoSize | Out-String
        
        ###END###

        $WMIComputerSystem = Get-WmiObject –ComputerName $ComputerName –Class Win32_ComputerSystem
        f

        ######ip address #######
        function get-IPAddress { 
        [CmdletBinding()] 
        param ( 
            [string]$computer=$env:COMPUTERNAME 
        ) 
     
        Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $ComputerName -filter 'IPEnabled="True"' | 
        ForEach-Object{ 
            $address = $_.IPAddress[1]             
     
            Write-Verbose "Test for ::" 
            if ($_.IPAddress[1].Contains("::")){ 
                $blocks = $_.IPAddress[1] -split ":" 
                $count = $blocks.Count 
                $replace = 8 - $count + 1 
                for ($i=0; $i -le $count-1; $i++){ 
                    if ($blocks[$i] -eq ""){ 
                        $blocks[$i] = ("0000:" * $replace).TrimEnd(":") 
                    } 
                } 
                $address = $blocks -join ":" 
            }             
     
            Write-Verbose "Check leading 0 in place" 
            $blocks = $address -split ":" 
            for ($i=0; $i -le $blocks.Count-1; $i++){ 
                if ($blocks[$i].length -ne 4){ 
                    $blocks[$i] = $blocks[$i].Padleft(4,"0") 
                } 
            } 
     
            $address = $blocks -join ":"             
       
            New-Object -TypeName PSObject -Property @{ 

                IPv6Address = $address    
            } 
        } 
    }
}
 

        #####END######

        ########PC OS Function steal ##########

        $OSWin32_OS = Get-WmiObject -Query "SELECT * FROM Win32_OperatingSystem" -ComputerName $ComputerName
        $OSCaption = ($OSWin32_OS|Select-Object caption).Caption
        $OSVersion = $OSWin32_OS.Version
        #2003/xp+
        $OSOther = $OSWin32_OS.OtherTypeDescription
        $OSSP = $OSWin32_OS.CSDVersion
        #2008/win7+
        $OSArchi = $OSWin32_OS.OSArchitecture
        $OSFullCaption = "$OSCaption $OSOther $OSArchi $OSSP"

        $IPV6Address = get-IPAddress

        ########END######

        #$outputBox.Appendtext(("[") + ((Get-datesortable) + ("]") + ("`r`n")  + ("`r`n")))
        $outputBox.Appendtext(("********************************") + ("`r`n"))
        $outputBox.Appendtext(("***                          ***") + ("`r`n"))
        $outputBox.Appendtext(("***   PC PERFORMANCE CHECK   ***") + ("`r`n"))
        $outputBox.Appendtext(("***                          ***") + ("`r`n"))
        $outputBox.Appendtext(("********************************") + ("`r`n")  + ("`r`n"))
        $outputBox.Appendtext(("- Asset Tag :        $ComputerName") + ("`r`n"))
        $outputBox.Appendtext(("- Logged in User:    " +$WMIComputerSystem.UserName) + ("`r`n"))
        $outputBox.Appendtext(("- CPU Clock Speed :  $Speed ") + ("`r`n"))
        $outputBox.Appendtext(("- Temp Folder Size : " + $TempSize + " MB") + ("`r`n"))
        $outputBox.Appendtext(("- Uptime:           " + " $($uptime1.days) Days $($uptime1.hours) Hours $($uptime1.minutes) Minutes $($uptime1.seconds) Seconds") + ("`r`n"))
        $outputBox.Appendtext(("- OS:                " + $OSFullCaption) + ("`r`n"))
        $outputBox.Appendtext(("- Device:            " + $WMIComputerSystem.Manufacturer + " " + $WMIComputerSystem.Model) + ("`r`n"))
        $outputBox.Appendtext(("- IPV6 Address:      " +  ($IPV6Address.IPv6Address)) + ("`r`n"))
        $outputBox.Appendtext(("- IPV4 Address:      " +  $Result) + ("`r`n") + ("`r`n"))
        $outputBox.Appendtext(("----------------------------------------------------------  ") + ("`r`n"))
        $outputBox.Appendtext(("*** DRIVE SIZE ***") + ("`r`n"))
        $outputBox.Appendtext($Table23) + ("`r`n")
        $outputBox.Appendtext(("----------------------------------------------------------  ") + ("`r`n"))
        $outputBox.Appendtext(("*** TOP 5 RUNNING PROCESSES ***") + ("`r`n"))
        $outputBox.Appendtext($OutString1) + ("`r`n")
        $outputBox.Appendtext(("----------------------------------------------------------  "  ) + ("`r`n"))

        $Form.Close()

    } Else {
        $outputBox.Appendtext(("[") + (Get-datesortable) +("] - Unable to access $ComputerName") + ("`r`n") + ("                    - Device $ComputerName is not contactable.") + ("`r`n") + ("`r`n"))
        
    }
}


Function Get-LockedOutLocation 
{ 

    [CmdletBinding()] 
 
    Param( 
      [Parameter(Mandatory=$True)] 
      [String]$Identity       
    ) 
 
    Begin 
    {  
        $DCCounter = 0  
        $LockedOutStats = @()    
                 
        Try 
        { 
            Import-Module ActiveDirectory -ErrorAction Stop 
        } 
        Catch 
        { 
           Write-Warning $_ 
           Break 
        } 
    }#end begin 
    Process 
    { 
         
        #Get all domain controllers in domain 
        $DomainControllers = Get-ADDomainController -Filter * 
        $PDCEmulator = ($DomainControllers | Where-Object {$_.OperationMasterRoles -contains "PDCEmulator"}) 
         
        Write-Verbose "Finding the domain controllers in the domain" 
        Foreach($DC in $DomainControllers) 
        { 
            $DCCounter++ 
            Write-Progress -Activity "Contacting DCs for lockout info" -Status "Querying $($DC.Hostname)" -PercentComplete (($DCCounter/$DomainControllers.Count) * 100) 
            Try 
            { 
                $UserInfo = Get-ADUser -Identity $Identity  -Server $DC.Hostname -Properties AccountLockoutTime,LastBadPasswordAttempt,BadPwdCount,LockedOut  
            } 
            Catch 
            { 
                Write-Warning $_ 
                Continue 
            } 
            If($UserInfo.LastBadPasswordAttempt) 
            {     
                $LockedOutStats += New-Object -TypeName PSObject -Property @{ 
                        Name                   = $UserInfo.SamAccountName 
                        SID                    = $UserInfo.SID.Value 
                        LockedOut              = $UserInfo.LockedOut 
                        BadPwdCount            = $UserInfo.BadPwdCount 
                        BadPasswordTime        = $UserInfo.BadPasswordTime             
                        DomainController       = $DC.Hostname 
                        AccountLockoutTime     = $UserInfo.AccountLockoutTime 
                        LastBadPasswordAttempt = ($UserInfo.LastBadPasswordAttempt).ToLocalTime() 
                }           
            }#end if 
        }#end foreach DCs 
        $LockedOutStats | Format-Table -Property Name,LockedOut,DomainController,BadPwdCount,AccountLockoutTime,LastBadPasswordAttempt -AutoSize 
 
        
                                                 
            }#end ifevent 
             
       }#end foreach lockedout event 
        
    


$comboBox_SelectedIndexChanged=
{   
   switch ($combobox.text){
    "Xerox My Print PIN - Equittrac" {$outputBox.Appendtext(("`r`n Xerox Equitrac URL`r`n------------------------------------------------`r`nhttps://cpxerequ01s:2941/webtools"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://cpxerequ01s:2941/webtools" | Clip}

    "CORP Outlook Online - OWA" {$outputBox.Appendtext(("`r`n Outlook URL`r`n------------------------------------------------`r`nhttps://outlook.office.com/owa/access.uk.com"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://outlook.office.com/owa/access.uk.com" | Clip}

    "EDU Outlook Online - OWA" {$outputBox.Appendtext(("`r`n EDU Outlook URL`r`n------------------------------------------------`r`nhttps://email.gsn.local/owa/"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://email.gsn.local/owa/" | Clip}

    "Glow - RM Unify Logon" {$outputBox.Appendtext(("`r`n GLOW RM Unify URL`r`n------------------------------------------------`r`nhttps://www.rmunify.com/"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://www.rmunify.com/" | Clip}

    "iPhone Airwatch Logon" {$outputBox.Appendtext(("`r`n iPhone Airwatch URL`r`n------------------------------------------------`r`nhttps://cn532.awmdm.com/"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://cn532.awmdm.com/" | Clip}

    "SAP Fiori User Login" {$outputBox.Appendtext(("`r`n SAP FIORI User URL`r`n------------------------------------------------`r`nhttps://engage.glasgow.gov.uk/mobi"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://engage.glasgow.gov.uk/mobi" | Clip}

    "Spam Report Email Address" {$outputBox.Appendtext(("`r`n Spam Report Address`r`n------------------------------------------------`r`nspamreport@glasgow.gov.uk"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "spamreport@glasgow.gov.uk" | Clip}

    "Remedy URL - (Internal)" {$outputBox.Appendtext(("`r`n Remedy Internal URL`r`n------------------------------------------------`r`nitsm-uk.ent.cginet/arsys/shared/login.jsp"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "itsm-uk.ent.cginet/arsys/shared/login.jsp" | Clip}

    "Remedy URL - (External)" {$outputBox.Appendtext(("`r`n Remedy External URL`r`n------------------------------------------------`r`nhttps://itsm-uk.cgi.com"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://itsm-uk.cgi.com" | Clip}  
        
    "Verint 360" {$outputBox.Appendtext(("`r`n Verint 360 URL`r`n------------------------------------------------`r`nhttp://lhwton360app01/wfo/control/signin"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "http://lhwton360app01/wfo/control/signin" | Clip}  
        
    "GCC Ensemble" {$outputBox.Appendtext(("`r`n GCC Ensemble URL`r`n------------------------------------------------`r`nhttps://ensemble.ent.cgi.com/client/29204/GCCITO/BAUService/ServiceDesk/SitePages/Home.aspx"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://ensemble.ent.cgi.com/client/29204/GCCITO/BAUService/ServiceDesk/SitePages/Home.aspx" | Clip}

    "GCC SIM and LIM" {$outputBox.Appendtext(("`r`n GCC SIM and LIM URL`r`n------------------------------------------------`r`nhttp://connect.glasgow.gov.uk/article/21720/Key-Contacts"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "http://connect.glasgow.gov.uk/article/21720/Key-Contacts" | Clip}

    "CORP IT Forms" {$outputBox.Appendtext(("`r`n CORP IT Forms URL`r`n------------------------------------------------`r`nhttp://connect.glasgow.gov.uk/index.aspx?articleid=19594"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "http://connect.glasgow.gov.uk/index.aspx?articleid=19594" | Clip}

    "EDU IT Forms" {$outputBox.Appendtext(("`r`n EDU IT Forms URL`r`n------------------------------------------------`r`nhttp://www.goglasgow.org.uk/pages/show/2253"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "http://www.goglasgow.org.uk/pages/show/2253" | Clip}

    "EDRMS" {$outputBox.Appendtext(("`r`n EDRMS URL`r`n------------------------------------------------`r`nhttps://edrms"+"`r`n------------------------------------------------`r`n(Copied to clipboard)") + ("`r`n`r`n")) 
        "https://edrms" | Clip}
   }
}

#########################
#########################
##                     ##
##    QUICK LINKS      ##
##                     ##
#########################
#########################

Function ADloc {

$DCloc = $InputBox.text
#$o = Get-LockedOutLocation -Identity $DCloc | Out-File \\ASGA56690\c$\List\Reports\DomainLockouts\LockoutLocation.txt -Append
$a = Get-LockedOutLocation -Identity $DCloc | Format-Table  -AutoSize -Wrap |Out-String -Width 50
$outputBox.Text=$a

-Property Name,LockedOut,DomainController,BadPwdCount
Get-LockedOutLocation -Identity $DCloc | Out-GridView
}


function ASQ {

$csvASQ = Import-Csv \\ASGA56690\c$\Useful_Documentation\Application_Support_Queues.csv 

$csvASQ | Out-GridView -Title "Application_Support_Queues"

}


function AFRVip {

$csvVip = Import-Csv \\ASGA56690\c$\List\AFR\vip.csv 

$csvVip | Out-GridView -Title "VIP - ARF"

}

function AFREDU {

$csvVip = Import-Csv \\ASGA56690\c$\List\AFR\edu.csv 

$csvVip | Out-GridView -Title "EDUCATION - ARF"

}

function AFRCRD {

$csvVip = Import-Csv \\ASGA56690\c$\List\AFR\crd.csv 

$csvVip | Out-GridView -Title "CORDIA - AFR"

}


# Opens window to internet explorer straight to knowledge base (WIKI) page #

function KB-WIKI {

$ieWKB = New-Object -ComObject InternetExplorer.Application



$ieWKB.AddressBar = $false

$ieWKB.top = 25; $ie.width = 1450; $ie.height = 1000 ; $ie.Left =220  
$ieWKB.navigate("http://escwiki/")
 
 while ($ieWKB.Busy -eq $true) 
 
{ 
 
Start-Sleep -Milliseconds 2000; 
 
} 


$ieWKB.Document.getElementById(“search”).value = $SE
$ieWKB.Document.getElementById(“go”).click()

    #(New-Object -Com Shell.Application).Open("http://escwiki/")


}

function CDA {
    (New-Object -Com Shell.Application).Open("https://cda-iis1/CarerSearch/")
}

function GLIT {
    (New-Object -Com Shell.Application).Open("http://connect.glasgow.gov.uk/index.aspx?articleid=19594")
}

function Routes {
    (New-Object -Com Shell.Application).Open("https://knowledgebase.glasgow.gov.uk/wiki/index.php/Call_Routes")
}

# Opens window to internet explorer straight to CareFirst page
function CareFirst {
    (New-Object -Com Shell.Application).Open("http://cfrlive.glasgow.gov.uk/cfi/application_store/")
}

# Opens window to internet explorer straight to ROD page #
function ROD {
    (New-Object -Com Shell.Application).Open("https://itsm-uk.cgi.com/arsys/shared/login.jsp")
}

# Opens window to internet explorer straight to MyPortal page
function MyPortal {
    (New-Object -Com Shell.Application).Open("http://myconnections.glasgow.gov.uk/Portal.aspx")
}

# Opens window to internet explorer straight to IWORLD page
function IWORLD {
    (New-Object -Com Shell.Application).Open("http://iwapp:7777/iworld/iwlive.html")
}

# Opens window to internet explorer straight to LSCMI page
function LSCMI {
    (New-Object -Com Shell.Application).Open("http://cpcmiweb01s/LIVE/(S(zd3fshu5udv2l155pmj31dul))/default.aspx")
}

function pulse {
(new-object -com shell.application).open("http://pulse.glasgow.gov.uk/logon.aspx")
}

function vpn {
(new-object -com shell.application).open("https://10.254.5.12:8443/FrejaTMC/")
}


# Opens window to internet explorer straight to LSCMI page
function GOLD {

 (New-Object -Com Shell.Application).Open("http://tracking.brightwave.co.uk/lnt/bwmc/15_glasgow_index.aspx")

}
# Launches snip tool on machine
 function Snip {
    (Start-process -filepath C:\Windows\System32\SnippingTool.exe)
}

# Launches Business Objects URL
 function bizOb {
    (Start-process -filepath "http://cpsappasp07s.glasgow.gov.uk:50700/BOE/CMC ")
}

# Launches snip tool on machine
 function Connect {
    (New-Object -Com Shell.Application).Open("http://connect.glasgow.gov.uk/")
}

# Launches wiki knowledgebase with search terms from inputBox3
function WikiSearch {
    $error.Clear()
    $check = $null
    $searchTerms = $InputBox3.text;
    If($inputBox3.text){
        (New-Object -Com Shell.Application).Open("https://knowledgebase.glasgow.gov.uk/wiki/index.php/?search="+$searchTerms)
        $inputBox3.text=""
    }

}

# Launches Cisco Wifi Guest Setup Page
 function guestWifi {
    (New-Object -Com Shell.Application).Open("https://cpprimeapp01s/webacs/loginAction.do?action=login&product=wcs#pageId=guestUserTemplateGeneralAction_pageId&queryParams=command%3Dlist&forceLoad=true")
}

###Hop Restart###
function hopRestart {
    $restarthop=$false
    $restarthop=[System.Windows.Forms.MessageBox]::Show("You are restarting your hop! This is only to be used when you hop is slow and not responding correctly. You MUST close all programs before proceeding. Are you sure you want to do this?","WARNING","YesNo","Warning")
    if($restarthop -eq "Yes"){
       $restarthopY=[System.Windows.Forms.MessageBox]::Show("Your hop will be unavailable while it restarts, which could take a few minutes. Are you sure?","WARNING","YesNo","Warning")
    }
    if($restarthopY -eq "Yes"){
        ##RESTART##
        Restart-Computer -Force
    }
}

# Launches Bitlocker GL
 function BitlockerGL {
    (New-Object -Com Shell.Application).Open("https://csg-cpmbamw01.csglasgow.local/helpdesk/KeyRecoveryPage.aspx")
}

# Launches Bitlocker Corp
 function BitlockerCorp {
    (New-Object -Com Shell.Application).Open("https://cpmbmcon01s.user.ad.glasgow.gov.uk/helpdesk/Default.aspx")
}

function rsOutBox{
    $outputBox.text=""
}

###################################
###################################
###                            #### 
###       GUI STRUCTURE        ####
###                            ####
###################################
###################################


#region Get-DateSortable
function Get-datesortable {
    $global:datesortable = Get-Date -Format "yyyyMMdd-HH':'mm':'ss"
    return $global:datesortable
}#endregion Get-DateSortable

###### End Functions

######### GUI will now welcome analyst by their first name #########

$FirstName1 = (Get-ADUser -identity $EVUser).GivenName

###### Start Form

#
$objForm = New-Object System.Windows.Forms.Form
$objForm.Text = "CGI: Service Desk Toolkit"
$Icon = [system.drawing.icon]::ExtractAssociatedIcon("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe")
#$Image100 = [system.drawing.image]::FromFile("\\CPFPSCLC01FS\ASG$\Data\ICT-Central\SharedData\Service Delivery\Service Desk\Capture108.png")
$objForm.BackgroundImage = 'White'
$objForm.Icon = $Icon
$objForm.BackColor = "White"
$objForm.WindowState = "Normal"
$objForm.MinimizeBox = $True
$objForm.MaximizeBox = $False
$objform.FormBorderStyle = "Fixed3D"
$objForm.AutoSize = $True
$objForm.Size = New-Object System.Drawing.Size(985,750)
$objForm.StartPosition = "CenterScreen"

$tooltip1 = New-Object System.Windows.Forms.ToolTip

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
    {$objForm.Close()}})

###### End Form

###### Start Buttons

$tooltip1.Active = $True

##### Font Stlye + BOLD ####
$Style = New-Object System.Drawing.Font("Corbel",9.2,[System.Drawing.FontStyle]::Bold) #Corbel

##### Font Stlye + BOLD ####
$Style1 = New-Object System.Drawing.Font("Corbel",8,[System.Drawing.FontStyle]::Bold) #Corbel

### Output box font ###
$OPB = New-Object System.Drawing.Font("Lucida Console",10.2,[System.Drawing.FontStyle]::Regular) #Lucida Console

### inputbox text font ###
$INTEXT = New-Object System.Drawing.Font("Corbel",10.3,[System.Drawing.FontStyle]::Bold) #Corbel

### Tool Name text font ###
$Access10 = New-Object System.Drawing.Font("Lucida Console",25.25,[System.Drawing.FontStyle]::Italic) #Corbel

### Address text font ###
$Address11 = New-Object System.Drawing.Font("Calibri Light",10.2,[System.Drawing.FontStyle]::Regular) #Corbel

#
$img = [System.Drawing.Image][system.convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAAGQAAAAtCAYAAABYtc7wAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAAZdEVYdFNvZnR3YXJlAEFkb2JlIEltYWdlUmVhZHlxyWU8AAAEB2lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS4wLWMwNjAgNjEuMTM0Nzc3LCAyMDEwLzAyLzEyLTE3OjMyOjAwICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InV1aWQ6OUUzRTVDOUE4QzgxREIxMTg3MzREQjU4RkRERTRCQTciIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6QzA4QkZBRjAyQ0E5MTFFNjg2NTRBMjk2RTE2Qjg5NzciIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6QzA4QkZBRUYyQ0E5MTFFNjg2NTRBMjk2RTE2Qjg5NzciIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgSWxsdXN0cmF0b3IgQ1M2IChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjgxMjU5RTBGQjA3Q0UyMTFB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')
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Location = New-Object System.Drawing.Size(845,675)
$pictureBox.Width =  $img.Size.Width
$pictureBox.Height =  $img.Size.Height
$pictureBox.Image = $img
$objForm.controls.add($pictureBox)


##GCC Lgog###
#$img = [System.Drawing.Image][system.convert]::FromBase64String('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')
#$pictureBoxGCC = new-object Windows.Forms.PictureBox
#$pictureBoxGCC.Location = New-Object System.Drawing.Size(271,140)
#$pictureBoxGCC.Width =  $img.Size.Width
#$pictureBoxGCC.Height =  $img.Size.Height
#$pictureBoxGCC.Image = $img
#$objForm.controls.add($pictureBoxGCC)

#Username Entry text #
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(30,30)
$objLabel.Size = New-Object System.Drawing.Size(80,20)
$objLabel.Text = "Username :"
$objLabel.Font = $INTEXT
$objLabel.BackColor = "#edf2f1"
$objForm.Controls.Add($objLabel)

#Asset Tag text#
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(30,260)
$objLabel.Size = New-Object System.Drawing.Size(100,20)
$objLabel.Text = "Full Asset Tag :"
$objLabel.Font = $INTEXT
$objLabel.BackColor = "#edf2f1"
$objForm.Controls.Add($objLabel)

#CGI Email Address postcode #
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(450,680)
$objLabel.Size = New-Object System.Drawing.Size(200,20)
$objLabel.Text = "EMAIL: gccservicedesk@cgi.com"
$objLabel.Font = $Address11
$objForm.Controls.Add($objLabel)

#CGI Address tel #
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(450,700)
$objLabel.Size = New-Object System.Drawing.Size(200,20)
$objLabel.Text = "TEL: 0141 287 4000  (ext x74000)"
$objLabel.Font = $Address11
$objForm.Controls.Add($objLabel)

#Username Input Box#
$InputBox = New-Object System.Windows.Forms.TextBox
$InputBox.Location = New-Object System.Drawing.Size(110,30)
$InputBox.BackColor = 'LemonChiffon'
$InputBox.Size = New-Object System.Drawing.Size(314,20)
$objForm.Controls.Add($InputBox)

#Asset Tag Input Box#
$InputBox2 = New-Object System.Windows.Forms.TextBox
$InputBox2.Location = New-Object System.Drawing.Size(130,260)
$InputBox2.BackColor = 'LemonChiffon'
$InputBox2.Size = New-Object System.Drawing.Size(293,30)
$objForm.Controls.Add($InputBox2)


#WIKI Search Label#
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(460,465)
$objLabel.Size = New-Object System.Drawing.Size(85,20)
$objLabel.Text = "Wiki Search:"
$objLabel.Font = $INTEXT
$objLabel.BackColor = "#edf2f1"
$objForm.Controls.Add($objLabel)

#WIKI Search Input Box#
$InputBox3 = New-Object System.Windows.Forms.TextBox
$InputBox3.Location = New-Object System.Drawing.Size(555,465)
$InputBox3.BackColor = 'LemonChiffon'
$InputBox3.Size = New-Object System.Drawing.Size(220,60)
$objForm.Controls.Add($InputBox3)
$InputBox3.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        #logic
        WikiSearch
    }
})


#Useful Links DropBox#
$combobox = New-Object System.Windows.Forms.listbox
$combobox.Location = New-Object System.Drawing.Size(785,465) #(765,585)
$combobox.BackColor = 'PowderBlue'
$combobox.Size = New-Object System.Drawing.Size(160,20)
$combobox.Height = 80
$combobox.Items.Add("====== USEFUL LINKS ======")
$combobox.Items.Add("Xerox My Print PIN - Equittrac")
$combobox.Items.Add("CORP Outlook Online - OWA")
$combobox.Items.Add("EDU Outlook Online - OWA")
$combobox.Items.Add("Glow - RM Unify Logon")
$combobox.Items.Add("iPhone Airwatch Logon")
$combobox.Items.Add("SAP Fiori User Login")
$combobox.Items.Add("Spam Report Email Address")
$combobox.Items.Add("Remedy URL - (Internal)")
$combobox.Items.Add("Remedy URL - (External)")
$combobox.Items.Add("Verint 360")
$combobox.Items.Add("GCC Ensemble")
$combobox.Items.Add("GCC SIM and LIM")
$combobox.Items.Add("CORP IT Forms")
$combobox.Items.Add("EDU IT Forms")
$combobox.Items.Add("EDRMS")
$combobox.SelectedIndex = 0
$objForm.Controls.Add($combobox)
$combobox.add_SelectedIndexChanged($combobox_SelectedIndexChanged)


$rsOutBox = New-Object System.Windows.Forms.Button
$rsOutBox.Image = [System.Convert]::FromBase64String('')
$rsOutBox.ImageAlign = 'TopCenter'
$rsOutBox.Location = New-Object System.Drawing.Size(890,395)
$rsOutBox.Size = New-Object System.Drawing.Size(44,40)
$rsOutBox.Text = "Clear"
$rsOutBox.TextAlign = 'BottomCenter'
$rsOutBox.Font = $Style
$rsOutBox.SetToolTip($rsOutBox, "Clear Output Box")
$rsOutBox.ForeColor = "Black"
$rsOutBox.UseVisualStyleBackColor = $True
$rsOutBox.Image = [System.Convert]::FromBase64String('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')
$rsOutBox.Add_Click({rsOutBox})
$objForm.Controls.Add($rsOutBox)

#
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Size(450,20)
$outputBox.Size = New-Object System.Drawing.Size(505,420)
$outputBox.ScrollBars = "Vertical" #adding scroll bars if required
$outputBox.Font = $OPB
$outputBox.BackColor =  'LemonChiffon'
$outputBox.MultiLine = $True
$objform.FormBorderStyle = "Fixed3D"
$outputBox.Text += (("[") + (Get-datesortable) +("] - Welcome $FirstName1 `r`n") + ("`r`n"))
$objForm.Controls.Add($outputBox)



##################################
##################################
###                           ####  
###      GUI FUNCTIONS        ####
###                           ####
##################################
##################################
 


#top
$ResetButton = New-Object System.Windows.Forms.Button
$ResetButton.Image = [System.Convert]::FromBase64String('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')
$ResetButton.ImageAlign = 'TopCenter'
$ResetButton.Location = New-Object System.Drawing.Size(190,60)
$ResetButton.Size = New-Object System.Drawing.Size(75,70)
$ResetButton.Text = "AD Reset"
$ResetButton.TextAlign = 'BottomCenter'
$ResetButton.Font = $Style
$ResetButton.UseVisualStyleBackColor = $True
$tooltip1.SetToolTip($ResetButton, "Reset users AD account to random generated password")
$ResetButton.Add_Click({checkADaccount})
$ResetButton -eq 'Enter',({checkADaccount})
$objForm.Controls.Add($ResetButton)

#top
$Cordia = New-Object System.Windows.Forms.Button
$Cordia.Image = [System.Convert]::FromBase64String('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')
$Cordia.ImageAlign = 'TopCenter'
$Cordia.Location = New-Object System.Drawing.Size(30,60)
$Cordia.Size = New-Object System.Drawing.Size(75,70)
$Cordia.Text = "Cordia VPN Rset"
$Cordia.TextAlign = 'BottomCenter'
$Cordia.Font = $Style
$Cordia.UseVisualStyleBackColor = $True
$tooltip1.SetToolTip($Cordia, "Reset CORDIA or VPN users AD account to random generated password (No first login prompt)")
$Cordia.Add_Click({Cordia})
$Cordia -eq 'Enter',({Cordia})
$objForm.Controls.Add($Cordia)

#top
$CordiaGen = New-Object System.Windows.Forms.Button
$CordiaGen.Image = [System.Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC94AAAveAHgFiJeAAAAB3RJTUUH4wMWDwgx/I18EAAACA1JREFUWMO1mE2MHMUVgL9X3TO987Mz++ddr9e2YryGBSw7tsEBh5gICBECKZGIDYoElwgpkSMuXDhy5JILJMohN3IJRkThZEEUInxAiWNb2EAA4Z/g7NqL8e7O/s50T3e9HLpndv52dxbIk0ateVX16utXr6tePWEDOf/sO53UoyiHUT2KkUPOcM9t0pcaiG6UM/gWtVpGmSWwV1DOYTiNkTPAjVZDB197dN35ZRNwBtgPHEf1MYzZkz7Qn3V2ZnG2ZTD9HnbOR5dCNFS0HBF+Mg8K4RfLK1qOPkc4BZwELgC2G0jpAgxgAjiBchwYNsMe6UODpA8NIFkHrIICIqsWVSFUEPDPzOD/bRotRyByE+Ek8Dvg0428KRvApYFngBexOi45F++BYVJ3FjDDPTFYN2KV6icLVD8uEV1bwc5XQbgEvAz8EQjWgmwCbIEbBF4CnkPxpODifW8I7+hwPKpLtqaZFKqfLFB+67/ocgSCD/whmWemE2QdsAVuK/AKcAwFyThkj+3EHe/dIGq7EIXqhyXKb02iga3ZewN4HphuhTQdTAzW4QBcwXtgC+7u/DeHS2Z07yzg/XAYM5CurcSxZM7BDt2bvJdO3H2spkjdUSB93xA43wZd7EFJGbwHR0h9tz/+mKhDvpQw1JlMy9I+AzxXM2QKKXoeHkE8s/mY2xBUcQY9JOM22n4uYaAG2bjEE8CLgFdTSN5Fcu63TLbqydTeIu4dvY1e9BKGiZrCNDxPAOONNlJ398WA37b36rML0uO0ascTFtMIGJ8QbW+p8eb7/xKReGdIt32rxxOmOuBxYLh5cLzEnaAlCkBt/YlI/LRR/FRNnslppjY22LoNCIgrSLsThmsOc4FR4LH2t6PdezYkffMznEoJ66Qh9CGVQXMDmGAFquV4oJsCtVgMmsog/iKSyhB5BcLCKIipv6wzmsEMeURTK2Ca5nsMeMUFDgN72vhSBtOfbtIZtXx08QPeP3uBxXKFoBqRdh2G+noZ29LH1oECANMz80zdKjEzv4xfDUm5DsWsx/33HmDioZ/FL1dbkEqE+rZTKO0BDrvAUSDbtpKRopWoGdAIH1ye4tU//x1B4vwAEBFc1zBYyAMwM79EGFlUtd5HUTL9W7jrEVlNY0SwcwF2Ieh0CGSBoy5wiA4ijmCybV8Y42PD5HrS+NVmeGuVpx++F4BX33wXY5pjzks5jI81hzlWsTNBQ+LVJocMcFunFvUtwYclCGujBbXKSF+OXMZDV/curCpDfXkeuWeCR+6ZYEtfHtvQrqrkMh4jfTnU1nwKhEr1s4WGOdrkNgMMdGzS5O1WFUhpktFCmrt3jRFGtv4TEZ64fx87RgbYMTLA40f2ISJNffbuGmO0kEZKk8TnHdjFKrYUrLeVDbhApmOTCNF0meqnC6TuKsY6f5Fs2uGFp37EHTtGmLpVQlXZu2uMn/xgP46Jv85fPP59hgp5Pro6hYgwNtTHE0f2kU07hP5i3b5WInQpZB3JyPln34nonNWAVdyJArmffwccgzN3Dff6RUySOUdRvDSOY+KtL1lWEUFa2tE4FMJt+4j6d0JkCc7OUj51HaI1jyprgPKa/CLYr3yiqXIc0NlBNJXFqsVaTUAEa7UpJlW1rd2qjcdmB8EIwfk5Kn+9EV8L1payAWbXBgQ7F7Dy+heElxbRTA5bHOXrii2Ooj05omvLBGdnkjvKukNmDXBlQ8OlgMq7XxL8a5YwvwPNFtlcBqFopkjUtxN7s0Ll7etEk20nRye54gLngAfX7WaEaHKF8nSZ6PogdnSUnvQy4kYbcwpo6OJHO6lerOC/9yV2odoNHMA5FzgN/JIOp0nrRERK8M9bBK4Q7iqS319C0nZtSAENDEsXilQml9BwAara7dVhBThtgDPA512vVgJavpRj8Ww/0ZLbeUKBaMll8Vw/5Uu5ON7CruFImM64xOWIUyT512ak8p8s4XyK3N0LeDtWmtr8axmWPy4SzqU6ZlpdyCngRm3/Ownc3LQJgepsmupX6bam6oxHOJv+ujfBmwlTfYO+UFNsShTcYpXM+HIziEBm9xJuX/B1rwu1+k0d0BLXSi51bcKCk4/oPTCHU6w2gyg4hZD8gRJOPlovW+kklxIW2wgIcSHnZcDfyGsIuLfnyT65DXc8E+tUk0ZNUn5I7e6J+9ye77Zc4icM9aKSQNvF/TfAr9eCk6zi7PdJHxwgtXUXEoaY+SnM0k2kWom7pXqw+S3Y4nbUdalOXyU4P0t0wUNXZL24/C3wAkkx6eBrj3aszQwCv6ehulCHK1rc+yuYHXGyanr6cQtjGK8AKBKFgKJOKo4Cf5FwYRJbKcX/Jx3C93vQedMJ8g3gVyRFpFptptOtfIa4kEMdMvGce6SC2b56etjyLIG/gEn3YrxexI2/Zg19rL+EDRbBhrWFwmyPcI9UCN/LtHqyVjyaaYXprvxm8NzDFZy91TXiSFvMaSfzdVX0UYrwTA/YjctvTXlgS/FwBniBiBNmW3jZ2ROuE+StO/E6O7OCsyfEbAsvE3GCOOY6wrGWlUZPph4qY3L2LrbY5xGeBIb4ZnIL5U2+Mq/YZfPv6rurCX1XJeBW0OXXhuj/0zVSfYETeeagijyF8GNgN2tdF9qlDFxGeVtUX3d8e75aSkdzT+8k9+ytzRfRG+Xzv5wk7I1TdnWF5a1pctf97Yjcp8JR4mvrLoQBVitjPsoscBU4J8ppVP+xvM2bzE0HSJI0uIuWPT89vu78/wN+2W+uNcdAHgAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wMy0yMlQxNTowODo0OSswMDowMKb9d7oAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDMtMjJUMTU6MDg6NDkrMDA6MDDXoM8GAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAABJRU5ErkJggg==')
$CordiaGen.ImageAlign = 'TopCenter'
$CordiaGen.Location = New-Object System.Drawing.Size(270,140)
$CordiaGen.Size = New-Object System.Drawing.Size(75,70)
$CordiaGen.Text = "Generate Password"
$CordiaGen.TextAlign = 'BottomCenter'
$CordiaGen.Font = $Style
$CordiaGen.UseVisualStyleBackColor = $True
$tooltip1.SetToolTip($CordiaGen, "Cordia Password Generator")
$CordiaGen.Add_Click({CordiaGen})
$CordiaGen -eq 'Enter',({CordiaGen})
$objForm.Controls.Add($CordiaGen)


#top
$GenerateButton = New-Object System.Windows.Forms.Button
$GenerateButton.Image = [System.Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAB+0lEQVRoge1ZS07EMAx9Rpxp1pxq5gztqdjOqcymYdyQj504ySD1SREVOK6f418DMTP+Mz5WG9CLiwAAENFGRK6xGHQea8sKMnN2AdgAMIBNI1eSsSz53poNGiVTCeR05fR/5o4PwB3AfvycAhkq8pmZH8xMyU21sMHEE8DrxE+rtOeUxNLzzPxo8OBv0hUTL4PDy3t4Dqu0Jw6hZuMP7EIPiAgWXbKSyecSiROBGtsahLEPcZoWZ+wAvgDc8HJGEckkXgVmDsRv8ckREacc7EpAxH2oXCovShwkQgjJkEzrUlaGYhVK9Q3NHou+nBwdwiWvMvoSeyiuYQ4wDF4j4DW7QDF4jVguxrcm/lICOeNnk6hWoRxyjUX8fQNwL8l4oDmJFYblm48jhpTRmb3DncD0xudaERoTF4bPV7cqNMD4pj6y1PiwN0VIu787B3pjnjvLbNf3gJzZiegJ4DuW0RJrvRjramQaOa2HoyFQ3QCbCXgh7ujmDm4sce7zDc5V6Gl9h7XEDRmXMaIPoFDORpBoJm81/t1IVI2P4p8j2eUkip5Nxb/1pKTelpOuLVUnZp/Jco/uPl0+eFSd2OOmgf/euPl8rfXmgDlmnUtx8SW5WO4xone/ikDsqbB6PRjv8yChPe7qv3qsxsvf9+hdPsz14rrcXY2LwGr8ACocdNSESFkoAAAAAElFTkSuQmCC')
$GenerateButton.ImageAlign = 'TopCenter'
$GenerateButton.Location = New-Object System.Drawing.Size(350,60)
$GenerateButton.Size = New-Object System.Drawing.Size(75,70)
$GenerateButton.Text = "Generate"
$GenerateButton.TextAlign = 'BottomCenter'
$GenerateButton.Font = $Style
$tooltip1.SetToolTip($GenerateButton, "Generates random password")
$GenerateButton.ForeColor = 'Black'
$GenerateButton.UseVisualStyleBackColor = $True
$GenerateButton.Add_Click({GeneratePassword})
$objForm.Controls.Add($GenerateButton)

#top
$ADUnlockbutton = New-Object System.Windows.Forms.Button
$ADUnlockbutton.Image = [System.Convert]::FromBase64String('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')
$ADUnlockbutton.ImageAlign = 'TopCenter'
$ADUnlockbutton.Location = New-Object System.Drawing.Size(270,60)
$ADUnlockButton.Size = New-Object System.Drawing.Size(75,70)
$ADUnlockButton.Text = "AD Unlock"
$ADUnlockButton.TextAlign = 'BottomCenter'
$ADUnlockButton.Font = $Style
$tooltip1.SetToolTip($ADUnlockButton, "Unlocks users AD account")
$ADUnlockButton.ForeColor = 'black'
$ADUnlockButton.UseVisualStyleBackColor = $True
$ADUnlockButton.Add_Click({AD-Unlock})
$objForm.Controls.Add($ADUnlockbutton)

#----------------------WEB Links Bottom Line----------------------------------


##Web Link
$WIKI = New-Object System.Windows.Forms.Button
$WIKI.ImageAlign = 'TopCenter'
$WIKI.Location = New-Object System.Drawing.Size (460,495)
$WIKI.Size = New-Object System.Drawing.Size(75,40)
$WIKI.Text = "Wiki KB Search"
$WIKI.Font = $Style
$WIKI.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($WIKI, "Link to knowledge base")
$WIKI.ForeColor = 'Blue'
$WIKI.UseVisualStyleBackColor = $True
$WIKI.Add_Click({KB-WIKI})
$objForm.Controls.Add($WIKI)
#Web Link
$Carefirst = New-Object System.Windows.Forms.Button
$Carefirst.ImageAlign = 'TopCenter'
$Carefirst.Location = New-Object System.Drawing.Size (190,620)
$Carefirst.Size = New-Object System.Drawing.Size(75,40)
$Carefirst.Text = "CareFirst"
$Carefirst.Font = $Style
$Carefirst.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($Carefirst, "Link to CareFirst")
$Carefirst.ForeColor = 'Blue'
$Carefirst.UseVisualStyleBackColor = $True
$Carefirst.Add_Click({CareFirst})
$objForm.Controls.Add($Carefirst)

#Web Link
$bitlockerCorp = New-Object System.Windows.Forms.Button
$bitlockerCorp.ImageAlign = 'Center' #'BottomCenter'
$bitlockerCorp.Location = New-Object System.Drawing.Size (270,570)
$bitlockerCorp.Size = New-Object System.Drawing.Size(75,40)
$bitlockerCorp.Text = "Bitlocker Corp"
$bitlockerCorp.Font = $Style
$bitlockerCorp.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($bitlockerCorp, "Link to BitLocker")
$bitlockerCorp.ForeColor = 'Blue'
$bitlockerCorp.UseVisualStyleBackColor = $True
$bitlockerCorp.Add_Click({bitlockerCorp})
$objForm.Controls.Add($bitlockerCorp)
#Web Link
$MyPortal = New-Object System.Windows.Forms.Button
$MyPortal.ImageAlign = 'TopCenter'
$MyPortal.Location = New-Object System.Drawing.Size (350,570)
$MyPortal.Size = New-Object System.Drawing.Size(75,40)
$MyPortal.Text = "MyPortal"
$MyPortal.Font = $Style
$MyPortal.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($MyPortal, "Link to MyPortal")
$MyPortal.ForeColor = 'Blue'
$MyPortal.UseVisualStyleBackColor = $True
$MyPortal.Add_Click({MyPortal})
$objForm.Controls.Add($MyPortal)
#Web Link

$IWORLD = New-Object System.Windows.Forms.Button
$IWORLD.ImageAlign = 'TopCenter'
$IWORLD.Location = New-Object System.Drawing.Size (30,570)
$IWORLD.Size = New-Object System.Drawing.Size(75,40)
$IWORLD.Text = "IWorld"
$IWORLD.Font = $Style
$IWORLD.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($IWORLD, "Link to IWorld")
$IWORLD.ForeColor = 'Blue'
$IWORLD.UseVisualStyleBackColor = $True
$IWORLD.Add_Click({IWORLD})
$objForm.Controls.Add($IWORLD)

$Pulse = New-Object System.Windows.Forms.Button
$Pulse.ImageAlign = 'TopCenter'
$Pulse.Location = New-Object System.Drawing.Size (30,620)
$Pulse.Size = New-Object System.Drawing.Size(75,40)
$Pulse.Text = "Pulse"
$Pulse.Font = $Style
$Pulse.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($Pulse, "Link to PULSE")
$Pulse.ForeColor = 'Blue'
$Pulse.UseVisualStyleBackColor = $True
$Pulse.Add_Click({Pulse})
$objForm.Controls.Add($Pulse)

$vpn = New-Object System.Windows.Forms.Button
$vpn.ImageAlign = 'TopCenter'
$vpn.Location = New-Object System.Drawing.Size (30,670)
$vpn.Size = New-Object System.Drawing.Size(75,40)
$vpn.Text = "VPN Drift"
$vpn.Font = $Style
$vpn.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($vpn, "Link to VPN Drift Portal")
$vpn.ForeColor = 'Blue'
$vpn.UseVisualStyleBackColor = $True
$vpn.Add_Click({vpn})
$objForm.Controls.Add($vpn)

$hopRestart = New-Object System.Windows.Forms.Button
$hopRestart.ImageAlign = 'TopCenter'
$hopRestart.Location = New-Object System.Drawing.Size (110,670)
$hopRestart.Size = New-Object System.Drawing.Size(315,40)
$hopRestart.Text = "Restart GCC Hop"
$redFont = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold)
$hopRestart.Font = $redFont
$hopRestart.Image = [System.Convert]::FromBase64String('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')
$hopRestart.ImageAlign = 'MiddleLeft'
$hopRestart.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($hopRestart, "Hop Restart")
$hopRestart.ForeColor = 'RED'
$hopRestart.UseVisualStyleBackColor = $True
$hopRestart.Add_Click({hopRestart})
$objForm.Controls.Add($hopRestart)

$guestWifi = New-Object System.Windows.Forms.Button
$guestWifi.ImageAlign = 'TopCenter'
$guestWifi.Location = New-Object System.Drawing.Size (350,620)
$guestWifi.Size = New-Object System.Drawing.Size(75,40)
$guestWifi.Text = "Guest Wifi"
$guestWifi.Font = $Style
$guestWifi.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($guestWifi, "Link to Cisco Wifi Guest Setup")
$guestWifi.ForeColor = 'Blue'
$guestWifi.UseVisualStyleBackColor = $True
$guestWifi.Add_Click({guestWifi})
$objForm.Controls.Add($guestWifi)


#Web Link
$LSCMI = New-Object System.Windows.Forms.Button
$LSCMI.ImageAlign = 'TopCenter'
$LSCMI.Location = New-Object System.Drawing.Size (110,570)
$LSCMI.Size = New-Object System.Drawing.Size(75,40)
$LSCMI.Text = "LSCMI"
$LSCMI.Font = $Style
$LSCMI.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($LSCMI, "Link to LSCMI")
$LSCMI.ForeColor = 'Blue'
$LSCMI.UseVisualStyleBackColor = $True
$LSCMI.Add_Click({LSCMI})
$objForm.Controls.Add($LSCMI)

#BO - automate
$bizOb = New-Object System.Windows.Forms.Button
$bizOb.ImageAlign = 'TopCenter'
$bizOb.Location = New-Object System.Drawing.Size (110,620)
$bizOb.Size = New-Object System.Drawing.Size(75,40)
$bizOb.Text = "Business Objects -"
$bizOb.Font = $Style
$bizOb.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($bizOb, "Link to BI Launch Pad (Business Objects)")
$bizOb.ForeColor = 'Blue'
$bizOb.UseVisualStyleBackColor = $True
$bizOb.Add_Click({bizOb})
$objForm.Controls.Add($bizOb)

#Web Link
$GOLD = New-Object System.Windows.Forms.Button
$GOLD.ImageAlign = 'TopCenter'
$GOLD.Location = New-Object System.Drawing.Size (190,570)
$GOLD.Size = New-Object System.Drawing.Size(75,40)
$GOLD.Text = "GOLD"
$GOLD.Font = $Style
$GOLD.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($GOLD, "Link to GOLD")
$GOLD.ForeColor = 'Blue'
$GOLD.UseVisualStyleBackColor = $True
$GOLD.Add_Click({GOLD})
$objForm.Controls.Add($GOLD)

##Web Link

#Web Link
$bitlockerGL = New-Object System.Windows.Forms.Button
$bitlockerGL.ImageAlign = 'TopCenter'
$bitlockerGL.Location = New-Object System.Drawing.Size (270,620)
$bitlockerGL.Size = New-Object System.Drawing.Size(75,40)
$bitlockerGL.Text = "Bitlocker GL/CSG"
$bitlockerGL.Font = $Style
$bitlockerGL.TextAlign = 'Center' #'BottomCenter'
$bitlockerGL.SetToolTip($bitlockerGL, "Bitlocker for glasgowlife")
$bitlockerGL.ForeColor = 'Blue'
$bitlockerGL.UseVisualStyleBackColor = $True
$bitlockerGL.Add_Click({bitlockerGL})
$objForm.Controls.Add($bitlockerGL)
#Web Link
$CDA = New-Object System.Windows.Forms.Button
$CDA.ImageAlign = 'TopCenter'
$CDA.Location = New-Object System.Drawing.Size (540,495)
$CDA.Size = New-Object System.Drawing.Size(75,40)
$CDA.Text = "Cordia Security Q"
$CDA.Font = $Style
$CDA.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($CDA, "Link to Cordia Security Question's")
$CDA.ForeColor = 'Blue'
$CDA.UseVisualStyleBackColor = $True
$CDA.Add_Click({CDA})
$objForm.Controls.Add($CDA)
#Web Link
$GLIT = New-Object System.Windows.Forms.Button
$GLIT.ImageAlign = 'TopCenter'
$GLIT.Location = New-Object System.Drawing.Size (700,495)
$GLIT.Size = New-Object System.Drawing.Size(75,40)
$GLIT.Text = "IT Forms"
$GLIT.Font = $Style
$GLIT.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($GLIT, "Link to IT Forms")
$GLIT.ForeColor = 'Blue'
$GLIT.UseVisualStyleBackColor = $True
$GLIT.Add_Click({GLIT})
$objForm.Controls.Add($GLIT)
#Web Link
$Routes = New-Object System.Windows.Forms.Button
$Routes.ImageAlign = 'TopCenter'
$Routes.Location = New-Object System.Drawing.Size (620,495)
$Routes.Size = New-Object System.Drawing.Size(75,40)
$Routes.Text = "Call Routes"
$Routes.Font = $Style
$Routes.TextAlign = 'Center' #'BottomCenter'
$tooltip1.SetToolTip($Routes, "Link to Call Routes on Wiki")
$Routes.ForeColor = 'Blue'
$Routes.UseVisualStyleBackColor = $True
$Routes.Add_Click({Routes})
$objForm.Controls.Add($Routes)

#bottom
$gpupdate = New-Object System.Windows.Forms.Button
$gpupdate.Image = [System.Convert]::FromBase64String('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')
$gpupdate.ImageAlign = 'TopCenter'
$gpupdate.Location = New-Object System.Drawing.Size(270,290)
$gpupdate.Size = New-Object System.Drawing.Size(74,70)
$gpupdate.Text = "GP/Flush"
$gpupdate.Font = $Style
$gpupdate.TextAlign = 'BottomCenter'
$tooltip1.SetToolTip($gpupdate, "Runs gpupdate/force and FlushDNS on users machine")
$gpupdate.ForeColor = "Black"
$gpupdate.UseVisualStyleBackColor = $True
$gpupdate.Add_Click({GP-UpDate})
$objForm.Controls.Add($gpupdate)

#bottom
$CDrive = New-Object System.Windows.Forms.Button
$CDrive.Image = [System.Convert]::FromBase64String('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
jNa7tTOOdvEAAAAASUVORK5CYII=')
$CDrive.ImageAlign = 'TopCenter'
$CDrive.Location = New-Object System.Drawing.Size(110,370)
$CDrive.Size = New-Object System.Drawing.Size(74,70)
$CDrive.Text = "Users C:"
$CDrive.TextAlign = 'BottomCenter'
$CDrive.Font = $Style
$tooltip1.SetToolTip($CDrive, "Backdoor into users C: Drive")
$CDrive.ForeColor = "Black"
$CDrive.UseVisualStyleBackColor = $True
$CDrive.Add_Click({C-Drive})
$objForm.Controls.Add($CDrive)

#RETIRED USB BUTTON
#$USB = New-Object System.Windows.Forms.Button
#$USB.Image = [System.Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAA0lBMVEX///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABK2kbTAAAARXRSTlMAgGYT/JkC/aYwNSl3FQGWa/sP90vfhwfJ7MoUZV28wAwX0elWmnb63OWUtOcW27Y0PVH5Uy2O4kFfr+gGwo2IoWMlXL5xD7b5AAABKklEQVRIx92Ux3KDQBBEWQQIJIIklHN0zjnL6f3/L/mAkVyFsHeO1p77VU33bI9hbO8rFISAbcv0pWKxJNE7Xeg6AsAEMAWOOwAdfd82ANj6jhNA4luBEsX6A1BKKaUEQDLefwHK0X5UFgBOA2g4mZRGMNqYUh2AemYPuTsZADDQB4IZMAsyoibsbI6mDGRNt9pwlhPmOo0VMKlM4SjUBIL+0AKsD0MHiCqfFgDxVe5+9+B4BSRv9/S+lv8hDuCw3lsD1rD/e03PLYCT17d3BUwrkz97c3H5PUkV2i2dpl3f3KbTN3Xb2bvzHx4RdvrpWXoEXmApkId+Fap+qA0sEtsLXf04ToB4rAnM02TnkmMvOfheCni6JtxE72qnVHMB3JpgE55pesbWvi9CuUodB/PFaAAAAABJRU5ErkJggg==')
#$USB.ImageAlign = 'TopCenter'
#$USB.Location = New-Object System.Drawing.Size(30,450)
#$USB.Size = New-Object System.Drawing.Size(74,70)
#$USB.Text = "USB"
#$USB.TextAlign = 'BottomCenter'
#$USB.Font = $Style
#$tooltip1.SetToolTip($USB, "All USB's currently connected to PC")
#$USB.ForeColor = "Black"
#$USB.UseVisualStyleBackColor = $True
#$USB.Add_Click({USB1})
#$objForm.Controls.Add($USB)


#bottom
$tempClean = New-Object System.Windows.Forms.Button
$tempClean.Image = [System.Convert]::FromBase64String('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')
$tempClean.ImageAlign = 'TopCenter'
$tempClean.Location = New-Object System.Drawing.Size(110,450)
$tempClean.Size = New-Object System.Drawing.Size(74,70)
$tempClean.Text = "Temp"
$tempClean.TextAlign = 'BottomCenter'
$tempClean.Font = $Style
$tooltip1.SetToolTip($tempClean, "Remove the Temp folder from C:/Windows")
$tempClean.ForeColor = "Black"
$tempClean.UseVisualStyleBackColor = $True
$tempClean.Add_Click({tempClean})
$objForm.Controls.Add($tempClean)

#bottom
#$DNSFlush = New-Object System.Windows.Forms.Button
#$DNSFlush.Image = [System.Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAADIAAAAxCAYAAACYq/ofAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAuJAAALiQE3ycutAAAAB3RJTUUH4gwKDhQC9yuGPwAAAAFvck5UAc+id5oAAAhpSURBVGjezdlbbBxXGcDx/zkzu+u92N51fE1sN64TJ0qgInF6A0pbVy1tVVQR8QBShaC0pSCKKL1CC4nTUqkiqA/0qVJ5gAcihba5gLgktNA0SICKhGiaOGnTkoRGSePLemftnZmd8/EwuxvbsZN440vO0648uzO/8132m7HiMl/ZPT/Fsqzy2xTwdeB7QAdKv6OTS56L9vTttqo9wUIhbNsuv02WEI8DywELpE3XtnRZtU3/tqs8x4IgIpEIxhgII3FvCbGscpAYlB29imjiZr3YFzwTQmt9fgQCVhSdbERHEtZlBylHQikFYTrdCzxxDkJZ2E3dWEu6BpQde/OySq1yTUyIxDeAJ4HWcxEriHT0vq/jmZ9JUPj7ZQMZ3bsVy7IQkTLiPsJ0ap10YBnRueF9nWh4Torj29FWQS02YBpEbQnxKLB0MkJjN60sI35i/Pw2pa1xUCw6ZHTvVrSulGoZ8RjQdvaocjqtlEjnhqM62bBF/PHtKDUOCh1Lsai/I+VIlFYKuJ8wnaZDhJFINmyRwNuOsgoAOpYCYNG61jTp9ABhdzq3sJtXEunccKSMUMoqYIoVxKJBpiDqSojHgJZJB5YRHRuO6GTDs+KNbUcoSOCBmnzpC14jo3u3TmyxZcQjTNedmlcS6ew9rBMNzxrX2a60XUCpSZFYFMg0hf3NcxECysZu7pFIZ+97OpHpF2/8FZSaEQEsXLFPKexa4EGmppMIaBu7uSesiURDvwTeK2jLBWZEwALVyDQ18a0Sonl6RO+ATmT6pVgIEUHxvIgFgUxB1JcQjwBNk6/Exm6pIJ4Rz3kVcPELoC98mfNaI6N7txKNRikWixMRDzMxEhAWdksPkc4NAzqe3mIKuVeUFXHPVxMLBplS2DMgSoXdskoinb2HdTyzWbz8ayg9KwTAnA2Nt9z5pcprI0LtLRsZ+8tORKRcE99nYjqVa6JlVZhO8cxmKRZ2YEVcxMwKAXPYtbpWrAl3xlIIoupPv09Xayqt4NtMrYnJiIM6numX4vgOdMQl8NA1dbM+/5xEpO+OSjSSgZHbxBA/nS++bWu1MTDyMNA4efts7ObVRDrXv6vj6WeMm9uhrIiLBKCr29vzQu77zhPhCzX9mGzbNgOHDpXfppTiq4RDX/TYmbFDw463Jp2MNBmZ8KFyJDp63w0LO/uasqIegI4mq97MSdd3/0NPTv27BiIC9QrSQAzwgSwwArinT50y2Ww2aVn6a4RDX4cI1CVs7lq3lLvWt1EbL7VfbWO3rJZIR+8hHU9vEs/ZhbJmXdjnjcj9Dz0BSNlmEY4N1wE3KVhL2G2iJcggcBh4K53JvJ3P528UMY8DHaUAkveEfR8USNaN0deTpDYeRTevJtKx/qCKpzcFxcIubUW9agp7xog88N0fAGENgjQAnwfuAa4nbJ2Kc1u1AcaMCU5kR7IZx8m1+L4ffqlSpNNp6tMZItpwTbvNXX3Xm6a1nz1ATf2WwBvbpa2oZ4oudrz+khEAVt/tG8lms7iuSyqV6iHsMI8C64D4DIjyJkSV0o01NTWpSDSKMQbf91FKURNPoLVmcHCYIx9lGbfrP65raH6+sal5m1bGFxNgV9GdZoxI3+0b4yjaW9uWdSSTyQeBuwlTaNbL933yTo5cbhRjBMuy8H0fI4KldU4pnh8cGn6hJhYb2//6b+cMAWArrW8Afug4uWWxWKzTtu2qEACRSITGxiYy6TTHT5zAdV1UqeMFQVALdKfr6xPA2JwqAA0qANU0Pja2YmR4OFqai6pegTE0NTWyamU3tm2Xh0VRSu1TSv1ChMG5RgBoben9SqvnROSw4+QYGR7mUjDGGHL5Mbq6lrP8ig4IW+E+4Ckx7FcKUfMw4Vndqz5Z1No6IsgZRNZ6ntsoRojGYhOHvoteSik836e+vo4rr+gITp489WbOcZ5WovaDEoA///438wH5BCBFra0BQc4IrPU8t9EYIVYlBsD3fNavu8q99upPvZCpq9vZ1tZijh0/wet/mHsElNrqrV/4cnk3Y8YEG8WYzUqplanaOpXJZCb+j2JW67a+G4p33HrTz5PJxFPAuJqPnCotDbBn9zYARMTV2npVab1JRAac3CjDVdaMMYbTHw/aBdf9XGBM6813f2XeEBVIBaMUIsbV2n5Nad0PHAwxQ7PGCODk8wSB6RQj3Tt+9dK83o1OKoA9u34NnMWg1JYQk6sKEwQGIAG0V5ueVUFgYpoZV2v7VZTqlxAjIca/6C+PxaLYtqWNMXUmCBYuItNgPK3tHUqpUs3kJKyZC2MUkE7XE41GUUp5Smm54IfmGjIF42pt71Ra/0iknGbnx4iE40r70lZqYlFPRE4F4SPShYdUMEohEnha27uUVpuBAxfCiBiWNGRYfkU7tm1/XAyKR88MDi1ORCqYsw3A05a9E6X6K5ihYcr3IGcR4dS7ZvUK2ttaxRjzryAIjnV3dc6n4+KeNFbSzFQwm0U44Dg5GRkemoQRYGlbC1evv4pEIp71i8XdruePOvn84kPOwYRp9mMROeg4joyUupkAdakkN37mGq5c3kkQBG8EQfDGkoZ0UCi4lwdkEibsZruV1k8LHHAch6GhISKWxU03XMc1G9ahtB7wi8WX/vin1z/KZnNVjznzAqlgwgnA19r+nVJqE/AfJ5dDTJHVPd3Ea2Ini37xxbHx8b/eduvNcvz4/8ik5+befKZV1dOwowPvUJqaA6Wt95TiJLDGcZwWJ58fTyWTLy9b2vqiGHGMGDo72ucVUTUE4OjhEGNZ2tTEat7TWp30fX/NBx8ei771t3/88uiH//3np6+9mtrUpT/quZh1yWPDnV+8B8vS1CaT0aGRkds9z+stFovbBA7u27NzQRAA/wdpRdFRgBwupwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOC0xMi0xMFQxNDoyMDowMiswMDowMMcKrDMAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTgtMTItMTBUMTQ6MjA6MDIrMDA6MDC2VxSPAAAAAElFTkSuQmCC')
#$DNSFlush.ImageAlign = 'TopCenter'
#$DNSFlush.Location = New-Object System.Drawing.Size(350,370)
#$DNSFlush.Size = New-Object System.Drawing.Size(74,70)
#$DNSFlush.Text = "DNS Flush"
#$DNSFlush.TextAlign = 'BottomCenter'
#$DNSFlush.Font = $Style
#$tooltip1.SetToolTip($DNSFlush, "DNS flush function")
#$DNSFlush.ForeColor = "Black"
#$DNSFlush.UseVisualStyleBackColor = $True
#$DNSFlush.Add_Click({DNSFlush})
#$objForm.Controls.Add($DNSFlush)

#bottom
$Restart = New-Object System.Windows.Forms.Button
$Restart.Image = [System.Convert]::FromBase64String('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
yulPgf4biUjLzYjxGOQAAAAASUVORK5CYII=')
$Restart.ImageAlign = 'TopCenter'
$Restart.Location = New-Object System.Drawing.Size(190,290)
$Restart.Size = New-Object System.Drawing.Size(74,70)
$Restart.Text = "Restart PC"
$Restart.TextAlign = 'BottomCenter'
$Restart.Font = $Style
$tooltip1.SetToolTip($Restart, "Restart users PC")
$Restart.ForeColor = "Black"
$Restart.UseVisualStyleBackColor = $True
$Restart.Add_Click({Restart})
$objForm.Controls.Add($Restart)

#bottom
$Shutdown = New-Object System.Windows.Forms.Button
$Shutdown.Image = [System.Convert]::FromBase64String('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
yOl5co93qgAAAABJRU5ErkJggg==')
$Shutdown.ImageAlign = 'TopCenter'
$Shutdown.Location = New-Object System.Drawing.Size(110,290)
$Shutdown.Size = New-Object System.Drawing.Size(74,70)
$Shutdown.Text = "Shutdown"
$Shutdown.TextAlign = 'BottomCenter'
$Shutdown.Font = $Style
$tooltip1.SetToolTip($Shutdown, "Shutdown users PC")
$Shutdown.ForeColor = "Black"
$Shutdown.UseVisualStyleBackColor = $True
$Shutdown.Add_Click({Shutdown})
$objForm.Controls.Add($Shutdown)

#bottom
$APPS = New-Object System.Windows.Forms.Button
$APPS.Image = [System.Convert]::FromBase64String('R0lGODlhMAAwAIcAAAAAAFpaW1RUZVlZdkN3YU1zc2NjY2FhbWpqamZmd3lhe3FxcXx8fABr0QB1
2x581gB/5F5ehV90qVt9tmJjimdomXBvmHh6hnFxnGxuomV1qmF/s3Z2qHx8tAGaAQ2TExqMJhWn
DhqqESWxGDGuNDK6ITOATT3BKEm1UEOvYEnKMVHFL1nUO2bdRHPlTACI7QWY/BKf/xui/iim/jeh
7zir/Fayj32Fr3iEtnO7v1KPz1Of30uy/VKx8VW1/1qy9Vq3/169/mST0XaRyWis5m2462S6/m63
8mm8/3m36nC+/XTGgHfD9nXA/3jE93vC/3zI+4ZpeaZWRrVuTqZtYN9pI9JtMM5+WqmQIIjzWqLq
W7PoXPqVNf+iPO6oXuy+T/+oQv+xS8zVVdvFT4SEhIODjY2NjYOAlpeXmIWFqYeHuo+dqpmZu5ml
spqouKOjo6Cir6urrKaqt6asv6ussKuruqq0vbOzs7u7u4eIxomL15OUxpKf0p+f0pyc2pmZ5Zub
/oOgxpiqyZOn2p2yzIy354e0/Jmm/5Ww45a945e57JS7/6WlyaSo26ys2a2zzKG52LO3xLKyzL+/
xb+/zLO00bq6076+2ays6aen/qW/5amy5a298LOp/7Oz5ru85be2/q7dv5/F34TF/4nH/4/L/JvL
65bC+ZbP9pTK/5jC9ZnF/5vM/5nR+7bEz7vO26bE7KTM/6zB9KvM/63S7KbT/bLN5rDP6L/C67PM
/7vM/7LQ57ba9bLZ/7vd/77h/NyvgdGzksS7/8LAudDOp+nnp8PDw8DAzcvLy8DA1sbG2c7O087O
3dTU1NHR3tXY2dra2sTE5cLC7MjI5sXF8sTE/sPM/83E/83P9svL/snc7NLM/dPT4dbX7tbd5Nbf
6Nrc5Njc6dHS8tPT/9vb/83g7cji+9Xg693j6dbp/OrF/+7X//3M//rY/+Pj4+Lk7eTo7Ovr6+Pj
8+Pj/uPt8+vt8+vr/+n0/v3o/vPz8/T0/PP4//7x//39/f///wAAACH/C05FVFNDQVBFMi4wAwEB
AAAh+QQBAAD+ACwAAAAAMAAwAAAI/wD9CRxIsKBBd9CeGWuWT6A+gxAjQkSo0NgdOpHkzHn06NMn
aXWMxXuGxxgePMieNZRIsJnFOHbauCFECJImTbNy6dTF05rPbJXIQKOzr59Rd80m3UG2EiIyaHGO
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
EAA7')
$APPS.Location = New-Object System.Drawing.Size(30,370)
$APPS.ImageAlign = 'TopCenter'
$APPS.Size = New-Object System.Drawing.Size(74,70)
$APPS.Text = "Apps"
$APPS.TextAlign = 'BottomCenter'
$APPS.Font = $Style
$tooltip1.SetToolTip($APPS, "All apps installed and uninstalled")
$APPS.ForeColor = "Black"
$APPS.UseVisualStyleBackColor = $True
$APPS.Add_Click({APPS})
$objForm.Controls.Add($APPS)

#top
$MemberOf = New-Object System.Windows.Forms.Button
$MemberOf.Image = [System.Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAEeklEQVR42t2aV2gVQRSGzzUmscResWBsKBoRfLJgiyW2gCUaBeOLqOCLIlYQBMWKIioiKj4ItmjEgmLB+hAUe28vFrAr9gbG+P/OXHe8d6/u7t3Nqgc+Mrt3d2b+PWdnz8wkIr9aBpgIRoAskCbe7ApYCjZ5vN+xRYxyN7AZNAKlxm+lMddFjxNdY5aLwBjwKWgB7PwBUDGANs6BvuB1UAIYNjdBQ/n1KT4Ad13W1w7UlHhvnAWDwLMgBEwHi43G3oICsNdDfa3ADVAuRgDtNsgGj/wWQBd3MM4N9tj5qF0DbRL8dh70ER/DiQI+g3SxwiYzyTqPgx66bPdyHwPD/BIRHU2iDZwEPQMWQOM7kQue+iHgm3Hsl4DuDq67o69LSkRYHjBHp6SG2LAFiBbBNj94FRBWCJm2Gwz1KiBsD0SPx4ENf4OALWCUBwH3QTOjP44F+B1CjcFq/TeR1Qf1bM43AE/cCvDbA06to6gEsrpYHmktKuX4JwTQmLLk/ssCdonKvZIS4Pc74MY4dDKRrCNqBjhaXKbwYXsgafsvBIQZQr4IKGsPtAAjQRdRHy6ufLwDF8ERsBN8/BsF8CO1TNSSTUTsVzpoz8ECsAqUOBFQFiHEufAOUMPmN84IK9icPyrKUy//JCBoD7Dz/OKm6vbeg7Vgu6j58xdQS9TSzliQI5Y3LoGu+p5QBDBsropaamH9zP2Hi5p7J7I8UVlpVX1PoVjJoa2AIENoK8jXZXae3nAycekkavKfro9762NbAUF5gKMN0wKuETEE2srvn3yscb1qkVgrGb3KWsBsMFe3wdFnqsv7+fQ5R2DazShheh63KBZkCPHFzdFlps5nPNSxBkzQZQ6/RXYCgvIAw6elbqOyuPg4GcZp5jpdngGWlKUAZpVNRI3zVcTBR8nGOABs0+WZotZw4wQEFULc5MjSZU4hvaxM86kv1OVJor7OcQKC8sBGUavcbINjf5GHOvaDAbrMfp2wExCUBwq0CNoh0N/l/c3BLZAiKtnjaPTZTkBQHqgE7omabdHceIH92qdFs8zRaGKiC4NMJSaD5brMjZN+4JSDzvNlnab7xKfP/YaHYQig+w+KSgVYPxO3OWCFLscaw2alWHHPezj6rAevEgkoESv7uyWJd1e8GjNNTlTaG+c4InFF4oIoz2SKykb7atGmfQXlRe3uDJSY0YwdZ7aYJZYnmL4W+ywiQz/FfInfohWJX3Z8p6+fEnOe+2/Zpgj+OE9U3hKthB+gIeCyzyJEN862uHpdzjhvbjByr3q+qGTwuMSvp143RfBEXVGf/WpGhXQbM8DHSXSWDS7VTy3WOE/oLGpOzD4wzWAknBZrqGTyxpC227v+6YmoOiZKXFVOMRr3Y6f+DRgvavblxRgJTCXSbNr4IcLsGGc9G7RivwREy3vALFEb6l5FpNrUWxyJuZjD2HTtkWpOW3Bo/OIfFuVpDq0vXNzL9dNCLcK00kiCG/iCNQW1fRZB4yrDPVHvmRuzC6ftEZeVhG0UwX/hYZhzwpT3HfvyYslKqk4eAAAAAElFTkSuQmCC')
$MemberOf.ImageAlign = 'TopCenter'
$MemberOf.Location = New-Object System.Drawing.Size(110,60)
$MemberOf.Size = New-Object System.Drawing.Size(74,70)
$MemberOf.Text = "Member Of"
$MemberOf.TextAlign = 'BottomCenter'
$MemberOf.Font = $Style
$tooltip1.SetToolTip($MemberOf, "AD groups user is member of")
$MemberOf.ForeColor = "Black"
$MemberOf.UseVisualStyleBackColor = $True
$MemberOf.Add_Click({MemberOf})
$objForm.Controls.Add($MemberOf)

### Script still running indicator ###

#top
$Password = New-Object System.Windows.Forms.Button
$Password.Image = [System.Convert]::FromBase64String('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
')
$Password.Location = New-Object System.Drawing.Size(30,140)
$Password.ImageAlign = 'TopCenter'
$Password.Size = New-Object System.Drawing.Size(74,70)
$Password.Text = "Pswrd info"
$Password.TextAlign = 'BottomCenter'
$Password.Font = $Style
$tooltip1.SetToolTip($Password, "Password Information")
$Password.ForeColor = "Black"
$Password.UseVisualStyleBackColor = $True
$Password.Add_Click({PASSWORD1})
$objForm.Controls.Add($Password)
#bottom
$PC = New-Object System.Windows.Forms.Button
$PC.Image = [System.Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6QTg2RUEyMDM5RDRCMTFFMjk4MDZBMTdENjVBRTUzQzEiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6QTg2RUEyMDQ5RDRCMTFFMjk4MDZBMTdENjVBRTUzQzEiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpBODZFQTIwMTlENEIxMUUyOTgwNkExN0Q2NUFFNTNDMSIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpBODZFQTIwMjlENEIxMUUyOTgwNkExN0Q2NUFFNTNDMSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PjIUql0AAAaySURBVHja7FhbaFRX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
')
$PC.Location = New-Object System.Drawing.Size(30,290)
$PC.ImageAlign = 'TopCenter'
$PC.Size = New-Object System.Drawing.Size(74,70)
$PC.Text = "PC Membr"
$PC.TextAlign = 'BottomCenter'
$PC.Font = $Style
$tooltip1.SetToolTip($PC, "PC Member Of Information")
$PC.ForeColor = "Black"
$PC.UseVisualStyleBackColor = $True
$PC.Add_Click({PC})
$objForm.Controls.Add($PC)

#bottom
$DeleteProfile = New-Object System.Windows.Forms.Button
$DeleteProfile.Image = [System.Convert]::FromBase64String('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')
$DeleteProfile.Location = New-Object System.Drawing.Size(190,370)
$DeleteProfile.ImageAlign = 'TopCenter'
$DeleteProfile.Size = New-Object System.Drawing.Size(74,70)
$DeleteProfile.Text = "Del Profile"
$DeleteProfile.TextAlign = 'BottomCenter'
$DeleteProfile.Font = $Style
$tooltip1.SetToolTip($DeleteProfile, "Delete a user's profile, asset tag and username required.")
$DeleteProfile.ForeColor = "Black"
$DeleteProfile.UseVisualStyleBackColor = $True
$DeleteProfile.Add_Click({DeleteProfile})
$objForm.Controls.Add($DeleteProfile)


#top
$UserInfo = New-Object System.Windows.Forms.Button
$UserInfo.Image = [System.Convert]::FromBase64String('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
')
$UserInfo.Location = New-Object System.Drawing.Size(110,140)
$UserInfo.ImageAlign = 'TopCenter'
$UserInfo.Size = New-Object System.Drawing.Size(74,70)
$UserInfo.Text = "User Info"
$UserInfo.TextAlign = 'BottomCenter'
$UserInfo.Font = $Style
$tooltip1.SetToolTip($UserInfo, "AD user information")
$UserInfo.ForeColor = "Black"
$UserInfo.UseVisualStyleBackColor = $True
$UserInfo.Add_Click({UserInfo})
$objForm.Controls.Add($UserInfo)

#bottom 
$deployURL = New-Object System.Windows.Forms.Button
$deployURL.Image = [System.Convert]::FromBase64String('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')
$deployURL.Location = New-Object System.Drawing.Size(190,450)
$deployURL.ImageAlign = 'TopCenter'
$deployURL.Size = New-Object System.Drawing.Size(74,70)
$deployURL.Text = "Send Shortcuts"
$deployURL.TextAlign = 'BottomCenter'
$deployURL.Font = $Style
$tooltip1.SetToolTip($deployURL, "Send URL shortcut to users desktop")
$deployURL.ForeColor = "Black"
$deployURL.UseVisualStyleBackColor = $True
$deployURL.Add_Click({deployURL})
$objForm.Controls.Add($deployURL)

$AddSoft = New-Object System.Windows.Forms.Button
$AddSoft.Image = [System.Convert]::FromBase64String('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')
$AddSoft.Location = New-Object System.Drawing.Size(270,450)
$AddSoft.ImageAlign = 'TopCenter'
$AddSoft.Size = New-Object System.Drawing.Size(74,70)
$AddSoft.Text = "Deploy Software"
$AddSoft.TextAlign = 'BottomCenter'
$AddSoft.Font = $Style
$tooltip1.SetToolTip($AddSoft, "Deploy Software to an Asset")
$AddSoft.ForeColor = "Black"
$AddSoft.UseVisualStyleBackColor = $True
$AddSoft.Add_Click({AddSoft})
$objForm.Controls.Add($AddSoft)


#bottom
$RemoteDSK = New-Object System.Windows.Forms.Button
$RemoteDSK.Image = [System.Convert]::FromBase64String('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
')
$RemoteDSK.Location = New-Object System.Drawing.Size(350,290)
$RemoteDSK.ImageAlign = 'TopCenter'
$RemoteDSK.Size = New-Object System.Drawing.Size(74,70)
$RemoteDSK.Text = "Remote PC"
$RemoteDSK.TextAlign = 'BottomCenter'
$RemoteDSK.Font = $Style
$tooltip1.SetToolTip($RemoteDSK, "Remote control pc via sccm")
$RemoteDSK.ForeColor = "Black"
$RemoteDSK.UseVisualStyleBackColor = $True
$RemoteDSK.Add_Click({RemoteDSK})
$objForm.Controls.Add($RemoteDSK)
#bottom
$SlowPC = New-Object System.Windows.Forms.Button
$SlowPC.Image = [System.Convert]::FromBase64String('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
')
$SlowPC.Location = New-Object System.Drawing.Size(270,370)
$SlowPC.ImageAlign = 'TopCenter'
$SlowPC.Size = New-Object System.Drawing.Size(74,70)
$SlowPC.Text = "CPU Check"
$SlowPC.TextAlign = 'BottomCenter'
$SlowPC.Font = $Style
$tooltip1.SetToolTip($SlowPC, "PC Information")
$SlowPC.ForeColor = "Black"
$SlowPC.UseVisualStyleBackColor = $True
$SlowPC.Add_Click({SlowPC})
$objForm.Controls.Add($SlowPC)


#bottom
$PING = New-Object System.Windows.Forms.Button
$PING.Image = [System.Convert]::FromBase64String('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
AAAAAElFTkSuQmCC')
$PING.Location = New-Object System.Drawing.Size(350,370)
$PING.ImageAlign = 'TopCenter'
$PING.Size = New-Object System.Drawing.Size(74,70)
$PING.Text = "Comms"
$PING.TextAlign = 'BottomCenter'
$PING.Font = $Style
$tooltip1.SetToolTip($PING, "Run comms check (Ping, Tracacert, DNSLookup)")
$PING.ForeColor = "Black"
$PING.UseVisualStyleBackColor = $True
$PING.Add_Click({PING})
$objForm.Controls.Add($PING)

 Future Buttons
$Button0 = New-Object System.Windows.Forms.Button
#Button0.Image = [System.Convert]::FromBase64String('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')
$Button0.ImageAlign = 'TopCenter'
$Button0.Location = New-Object System.Drawing.Size(860,585)
$Button0.Size = New-Object System.Drawing.Size(74,70)
$Button0.Text = "{Inactive}"
$Button0.TextAlign = 'BottomCenter'
$Button0.Font = $Style
$tooltip1.SetToolTip($Button0, "{Inactive}")
$Button0.ForeColor = "Black"
$Button0.UseVisualStyleBackColor = $True
$Button0.Add_Click({Button0})
$objForm.Controls.Add($Button0)

$Button1 = New-Object System.Windows.Forms.Button
#$Button1.Image = [System.Convert]::FromBase64String('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')
$Button1.ImageAlign = 'TopCenter'
$Button1.Location = New-Object System.Drawing.Size(780,585)
$Button1.Size = New-Object System.Drawing.Size(74,70)
$Button1.Text = "{Inactive}"
$Button1.TextAlign = 'BottomCenter'
$Button1.Font = $Style
$tooltip1.SetToolTip($Button1, "{Inactive}")
$Button1.ForeColor = "Black"
$Button1.UseVisualStyleBackColor = $True
$Button1.Add_Click({Button1})
$objForm.Controls.Add($Button1)


# ASQ = Application Support Queue
$ASQ = New-Object System.Windows.Forms.Button
$ASQ.Image = [System.Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAAC4AAAAuCAYAAABXuSs3AAAACXBIWXMAAAsTAAALEwEAmpwYAAA5tmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS41LWMwMjEgNzkuMTU0OTExLCAyMDEzLzEwLzI5LTExOjQ3OjE2ICAgICAgICAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgICAgICAgICB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIgogICAgICAgICAgICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgICAgICAgICAgIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOmV4aWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvIj4KICAgICAgICAgPHhtcDpDcmVhdG9yVG9vbD5BZG9iZSBQaG90b3Nob3AgQ0MgKFdpbmRvd3MpPC94bXA6Q3JlYXRvclRvb2w+CiAgICAgICAgIDx4bXA6Q3JlYXRlRGF0ZT4yMDIwLTAzLTA0VDE5OjU3OjUxWjwveG1wOkNyZWF0ZURhdGU+CiAgICAgICAgIDx4bXA6TWV0YWRhdGFEYXRlPjIwMjAtMDMtMDRUMTk6NTc6NTFaPC94bXA6TWV0YWRhdGFEYXRlPgogICAgICAgICA8eG1wOk1vZGlmeURhdGU+MjAyMC0wMy0wNFQxOTo1Nzo1MVo8L3htcDpNb2RpZnlEYXRlPgogICAgICAgICA8eG1wTU06SW5zdGFuY2VJRD54bXAuaWlkOmVhNDBlZGZkLTFhZjgtNTk0ZS1hMzliLTg1ZGRhNDRkNTNkZTwveG1wTU06SW5zdGFuY2VJRD4KICAgICAgICAgPHhtcE1NOkRvY3VtZW50SUQ+eG1wLmRpZDpmNDMyNjAzNy04ZjM2LTM4NDYtOGJhNS0wMGQ1NWYyMjE0YmM8L3htcE1NOkRvY3VtZW50SUQ+CiAgICAgICAgIDx4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ+eG1wLmRpZDpmNDMyNjAzNy04ZjM2LTM4NDYtOGJhNS0wMGQ1NWYyMjE0YmM8L3htcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD4KICAgICAgICAgPHhtcE1NOkhpc3Rvcnk+CiAgICAgICAgICAgIDxyZGY6U2VxPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5jcmVhdGVkPC9zdEV2dDphY3Rpb24+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDppbnN0YW5jZUlEPnhtcC5paWQ6ZjQzMjYwMzctOGYzNi0zODQ2LThiYTUtMDBkNTVmMjIxNGJjPC9zdEV2dDppbnN0YW5jZUlEPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6d2hlbj4yMDIwLTAzLTA0VDE5OjU3OjUxWjwvc3RFdnQ6d2hlbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnNvZnR3YXJlQWdlbnQ+QWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKTwvc3RFdnQ6c29mdHdhcmVBZ2VudD4KICAgICAgICAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgICAgICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0iUmVzb3VyY2UiPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6YWN0aW9uPnNhdmVkPC9zdEV2dDphY3Rpb24+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDppbnN0YW5jZUlEPnhtcC5paWQ6ZWE0MGVkZmQtMWFmOC01OTRlLWEzOWItODVkZGE0NGQ1M2RlPC9zdEV2dDppbnN0YW5jZUlEPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6d2hlbj4yMDIwLTAzLTA0VDE5OjU3OjUxWjwvc3RFdnQ6d2hlbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnNvZnR3YXJlQWdlbnQ+QWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKTwvc3RFdnQ6c29mdHdhcmVBZ2VudD4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmNoYW5nZWQ+Lzwvc3RFdnQ6Y2hhbmdlZD4KICAgICAgICAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgICAgIDwvcmRmOlNlcT4KICAgICAgICAgPC94bXBNTTpIaXN0b3J5PgogICAgICAgICA8ZGM6Zm9ybWF0PmltYWdlL3BuZzwvZGM6Zm9ybWF0PgogICAgICAgICA8cGhvdG9zaG9wOkNvbG9yTW9kZT4zPC9waG90b3Nob3A6Q29sb3JNb2RlPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICAgICA8dGlmZjpYUmVzb2x1dGlvbj43MjAwMDAvMTAwMDA8L3RpZmY6WFJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOllSZXNvbHV0aW9uPjcyMDAwMC8xMDAwMDwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6UmVzb2x1dGlvblVuaXQ+MjwvdGlmZjpSZXNvbHV0aW9uVW5pdD4KICAgICAgICAgPGV4aWY6Q29sb3JTcGFjZT42NTUzNTwvZXhpZjpDb2xvclNwYWNlPgogICAgICAgICA8ZXhpZjpQaXhlbFhEaW1lbnNpb24+NDY8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+NDY8L2V4aWY6UGl4ZWxZRGltZW5zaW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/Ph/NbPkAAAAgY0hSTQAAeiUAAICDAAD5/wAAgOkAAHUwAADqYAAAOpgAABdvkl/FRgAADGRJREFUeNq8mXtwVFWexz/nvjrp7jw6CYRgSMKbQNDhqfIYZgARRHZ0nXJYGbd22JlypVZLYRlGd5zRcpVZHVkXd2dHd3UdwFJrHNcaMRNBeUxABeQdkkAMbUIYk5DQSbrTj9t979k/+nYnUV7y8Fd1q7pO3/P7fc/v/t5HzKl8myukXODbznM9UAIMBjzO/71AO9AMHAGqgZ1A15UIFZcJ3AV8H/ghcAugfs39FvABsBF4C4h9XQDK13w/E1gJNAKbgIWXARpnz60Oj5MOz8xrBXwRcBR4DriOq0dDHZ5HHRlXDXgG8BugEhjJtaORjozfODKvCHih40z3883R/cBuR/Z5SUv9GO42BvzhD5sjgPeBUenFcJjuozUE9h/ibO1x4r0hdI+brJEjKJp5E+6xY1Bycq4G+MnALmBB6FSjP5EAdIEQAoCc64b3RZX+wP1hs9jRdBmAGo/T8vt3aK7aQtFN0ym4aTqZQwtRXAaJqEm0rY2OPQdo3f0RRXNmUrZsKXZGxtU4wOfA7C5/Y8tFgfvDpts57SQA2tvZ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')
$ASQ.ImageAlign = 'TopCenter'
$ASQ.Location = New-Object System.Drawing.Size(700,585)
$ASQ.Size = New-Object System.Drawing.Size(74,70)
$ASQ.Text = "App Support"
$ASQ.TextAlign = 'BottomCenter'
$ASQ.Font = $Style1
$tooltip1.SetToolTip($ASQ, "Application Support Queue")
$ASQ.ForeColor = "Black"
$ASQ.UseVisualStyleBackColor = $True
$ASQ.Add_Click({ASQ})
$objForm.Controls.Add($ASQ)


$AFRVip = New-Object System.Windows.Forms.Button
$AFRVip.Image = [System.Convert]::FromBase64String('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')
$AFRVip.ImageAlign = 'TopCenter'
$AFRVip.Location = New-Object System.Drawing.Size(620,585)
$AFRVip.Size = New-Object System.Drawing.Size(74,70)
$AFRVip.Text = "VIP - AFR"
$AFRVip.TextAlign = 'BottomCenter'
$AFRVip.Font = $Style
$tooltip1.SetToolTip($AFRVip, "VIP AFR List")
$AFRVip.ForeColor = "Black"
$AFRVip.UseVisualStyleBackColor = $True
$AFRVip.Add_Click({AFRVip})
$objForm.Controls.Add($AFRVip)

#Function to launch print queue management
$PrintMgmt = New-Object System.Windows.Forms.Button
$PrintMgmt.Image = [System.Convert]::FromBase64String('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')
$PrintMgmt.ImageAlign = 'TopCenter'
$PrintMgmt.Location = New-Object System.Drawing.Size(350,450)
$PrintMgmt.Size = New-Object System.Drawing.Size(75,70)
$PrintMgmt.Text = "Print Q's"
$PrintMgmt.TextAlign = 'BottomCenter'
$PrintMgmt.Font = $Style
$PrintMgmt.UseVisualStyleBackColor = $True
$tooltip1.SetToolTip($PrintMgmt, "Print Management Tool")
$PrintMgmt.Add_Click(
    {
            start-process Printmanagement.msc
    }
)
$objForm.Controls.Add($PrintMgmt) 


$AFREDU = New-Object System.Windows.Forms.Button
$AFREDU.Image = [System.Convert]::FromBase64String('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')
$AFREDU.ImageAlign = 'TopCenter'
$AFREDU.Location = New-Object System.Drawing.Size(540,585)
$AFREDU.Size = New-Object System.Drawing.Size(74,70)
$AFREDU.Text = "EDU - AFR"
$AFREDU.TextAlign = 'BottomCenter'
$AFREDU.Font = $Style
$tooltip1.SetToolTip($AFREDU, "EDU AFR List")
$AFREDU.ForeColor = "Black"
$AFREDU.UseVisualStyleBackColor = $True
$AFREDU.Add_Click({AFREDU})
$objForm.Controls.Add($AFREDU)

$AFRCRD = New-Object System.Windows.Forms.Button
$AFRCRD.Image = [System.Convert]::FromBase64String('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')
$AFRCRD.ImageAlign = 'TopCenter'
$AFRCRD.Location = New-Object System.Drawing.Size(460,585)
$AFRCRD.Size = New-Object System.Drawing.Size(74,70)
$AFRCRD.Text = "Cordia AFR"
$AFRCRD.TextAlign = 'BottomCenter'
$AFRCRD.Font = $Style
$tooltip1.SetToolTip($AFRCRD, "Cordia AFR List")
$AFRCRD.ForeColor = "Black"
$AFRCRD.UseVisualStyleBackColor = $True
$AFRCRD.Add_Click({AFRCRD})
$objForm.Controls.Add($AFRCRD)



$ADloc = New-Object System.Windows.Forms.Button
$ADloc.Image = [System.Convert]::FromBase64String('')
$ADloc.ImageAlign = 'TopCenter'
$ADloc.Location = New-Object System.Drawing.Size(190,140)
$ADloc.Size = New-Object System.Drawing.Size(74,70)
$ADloc.Text = "Locked Location"
$ADloc.TextAlign = 'BottomCenter'
$ADloc.Font = $Style
$tooltip1.SetToolTip($ADloc, "Domain Lock-Out")
$ADloc.ForeColor = "Black"
$ADloc.UseVisualStyleBackColor = $True
$ADloc.Image = [System.Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAA3NCSVQICAjb4U/gAAAACXBIWXMAAADlAAAA5QGP5Zs8AAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAk9QTFRF////AAD//wAAAID//1UA1SsAAG3/vyAAxhwA/zkA/y4A1SsA/zsA/zcAySgAAHPy/zMAAGjz1ikA0CYA/zMA/zEAAHDv/zMA/zMAzSwAAG7wAG3xzSkAyywA/zUA/zUA/zQAzCkAAG3vAGzwAG3v/zYA/zUAzSoAUVORzCkA/zUA/zUAAG3wAGzwzCsA/zUA/zQA/zUAAG3xAGzxzCsA/zUCAG3xzSkAAG3xzSoA/zYCzisAzCsA/zYCAG3wAGzw/zUCAG3w/zUBAGzw/zQBzSoAZ015T5bt0ioAAG3wSJDq/7SiAG3wPIrqRpX0YaP2Zab205KD1qmh1quj/8u+/6SNAG3xL4XrN43zY0x90oJw/zYBImLIL4fyfqrkgKzklsP618C+G3rtIIDyfEVe/zYB/4Zm5+fo/4RkjbLhpsz6/+znE2fb/zUBzCoAD3TvEXby/zUB//PvmTs80kkpCWrl187Q//f0AG3wqMDfxt/7zSsACHHwCXPx19DT0CsAzksqBnHvBXDwBnHxzSoAzkQg/1MnAG3wA2zs/zUBsTMgtTEaAm/wAm/xAm7wAm7xws3c5fD+0TAF3Nrc/zUBAW7wxc3b/zUBAG3w/zUB2Nba/zUB//7+AG3wAW3v0CsA2tncAG3w19bZ2Nfa9fr/////AG3wzjEI////zSoA/zUBAG3xxywH/zwIzSoA/zUBAG3w////zSoA/zgFzSsA1dba/P3//zUB/zcEAG3wzSoAzSsC/zUBAG3wzSoA/zYCAG3wzSoA2Nfa/zUB////vGy9UwAAAMB0Uk5TAAEBAgMGBwgJCQsMDQ4TFBQWGRseHyAjKC4zNjhAQ0hJUFJTXl5lZ2hpbnR1eHh4enx+f4OHjY6PmJibnKKmp6irra6vtre4vL+/v8DAwMDAwMDAwMHCwsLCwsPExMfHx8fIyMjIyMnJzMzMzc7P0dHS09XV19fX2NjY2NnZ2tvc3t/f3+Li4+Pj5Ojp6erq6urr6+vs7Ozt7e7u7vHx8fHy9PT19fb29vf3+Pj4+fn6+vv7/Pz8/Pz9/f39/v7+sBo6IAAAAhJJREFUOE9t0flbTkEUB/CJ7FuyZBeRXbJkJxRJJVtv2ansa8lOylq8WVKypCLrjS7ZwsuZe+8f5sycmel6Ob/c+zzfz8w5M8MYVVRsYkpFaersMQPY/yoyodXFauCcf5/b/d98SKHrasD5uRHh+fi3rh/wT9PD1utcA/5rpD+PLHTDAb/SywcSTH7txA8t5nfkUa2UflvzxGt8tv6VEkMNiKX890HP8xod56ISkwxIJLDJI+BsILDIgBQCpzR4TnMcMaBC5u8+aOBckuBjNw0e0ogvDLhKPfpqsIVaFGnwiPI3psUCAns0WCfiluKVwzorMJmAu5HALpwxr8QGgLplwyUYqF9iX9Hr6pObOa88BKrsaXKXOa6utnu4e+VTgGCWDUd34zYrBOhz3wjxWLh+W7NnQcA5Uw4wToh4P8jDHKcRwLlTBXX9hVjsAyUQbEaQvWo/nmgHwFQBehw2oMWGLHFgb6+4s8+3YIk8yaAHGhTj7JaVLcF5y2qH03QZo74qUCDPt1aCMvFbr65rigI3AY7l5h6QID0QqIEcBViyGvIG5HfMUGtDkgY9jxPYCvZZzC+UpSPIBIjTgMU8FuD9xBBcvqvuYXsIMiIMYKN/IpjA5gHc3vkFQW1mCJoGM1/NcBsWMtZ1Kc4ebIcafIqmsf6cdVqe1gU/EbNeqtfM+Gs9Vu9o+vabufp6fU5SnOz/B7AV0laCTNlRAAAAAElFTkSuQmCC')
$ADloc.Add_Click({ADloc})
$objForm.Controls.Add($ADloc)


$softwareCycle = New-Object System.Windows.Forms.Button
$softwareCycle.Image = [System.Convert]::FromBase64String('')
$softwareCycle.ImageAlign = 'TopCenter'
$softwareCycle.Location = New-Object System.Drawing.Size(30,450)
$softwareCycle.Size = New-Object System.Drawing.Size(74,70)
$softwareCycle.Text = "Cycle Updates"
$softwareCycle.TextAlign = 'BottomCenter'
$softwareCycle.Font = $Style
$tooltip1.SetToolTip($softwareCycle, "Cycle Software Centre")
$softwareCycle.ForeColor = "Black"
$softwareCycle.UseVisualStyleBackColor = $True
$softwareCycle.Image = [System.Convert]::FromBase64String('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')
$softwareCycle.Add_Click({softwareCycle})
$objForm.Controls.Add($softwareCycle)



$greyBoxAsset = New-Object System.Windows.Forms.TextBox
$greyBoxAsset.Location = New-Object System.Drawing.Size(180,30)
$greyBoxAsset.BackColor = 'LemonChiffon'
$greyBoxAsset.Size = New-Object System.Drawing.Size(203,20)
$objForm.Controls.Add($InputBox)



$userPanel = New-Object system.Windows.Forms.Panel
$userPanel.height = 200
$userPanel.width = 415
$userPanel.BackColor = "#edf2f1"
$userPanel.location = New-Object System.Drawing.Point(20,20)
$objForm.Controls.Add($userPanel)


$assetPanel = New-Object system.Windows.Forms.Panel
$assetPanel.height = 280
$assetPanel.width = 415
$assetPanel.BackColor = "#edf2f1"
$assetPanel.location = New-Object System.Drawing.Point(20,250)
$objForm.Controls.Add($assetPanel)

$linksPanel = New-Object system.Windows.Forms.Panel
$linksPanel.height = 160
$linksPanel.width = 415
$linksPanel.BackColor = "#edf2f1"
$linksPanel.location = New-Object System.Drawing.Point(20,560)
$objForm.Controls.Add($linksPanel)

$linksPanel2 = New-Object system.Windows.Forms.Panel
$linksPanel2.height = 90
$linksPanel2.width = 505
$linksPanel2.BackColor = "#edf2f1"
$linksPanel2.location = New-Object System.Drawing.Point(450,455)
$objForm.Controls.Add($linksPanel2)

$linksPanel3 = New-Object system.Windows.Forms.Panel
$linksPanel3.height = 90
$linksPanel3.width = 505
$linksPanel3.BackColor = "#edf2f1"
$linksPanel3.location = New-Object System.Drawing.Point(450,575)
$objForm.Controls.Add($linksPanel3)

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()