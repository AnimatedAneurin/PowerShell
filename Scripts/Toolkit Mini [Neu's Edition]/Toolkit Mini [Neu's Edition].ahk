;Copyright © 2020 by Aneurin Weale
;
;All rights reserved.

#SingleInstance force

;.DESCRIPTION
;A tool to launch scripts to assist DLM Engineers to improve efficencey of providing remote support.
;
;.NOTES
;   Author	:  Aneurin Weale
;   Contributor :  
;   Contributor :  
;   Contributor :  
;   Contributor :  
;   Contributor :  
;   Language    :  AutoHotKey
;   Last Update :  26/05/2021
;   Version     :  1.0.3
;
;
;#######################################
;#######################################
;###                               #####  
;###       Version History         #####
;###                               ##### 
;###                               #####
;#######################################
;#######################################
;
;
;
;   VERSION:     DATE:       NOTES:
;    0.0.1    23/10/2020  Created Menu and 6 SubMenus. Created a GUI to be worked on later. - Aneurin Weale
;    0.0.2    26/10/2020  Completed SubMenu's 1 through 3. - Aneurin Weale
;    0.0.3    27/10/2020  Started working on submenu 4 through 6. - Aneurin Weale
;    0.0.4    28/10/2020  Completed Submenu 4. - Aneurin Weale
;    0.0.5    29/10/2020  Completed Submenu 5 and 6. - Aneurin Weale
;    0.0.6    02/11/2020  Modified Submenu 4 - AnalystChasedPhone1 to 3 and AnalystChasedEmail1 to 3. - Aneurin Weale
;    0.0.7    05/11/2020  Modified Submenu 1, 2 & 3 - Changed original method from typing out the command to pasting it from the clipboard. - Aneurin Weale
;    0.0.8    30/11/2020  Made adjustments to the GUI (Welcome Page) which includes; repositioning of text, font changes, Read-Only Textbox with instructions on how to use the script, and a designated a Hot Key for the GUI so that it appears on launch and on command. - Aneurin Weale
;    0.0.9    02/12/1010  Made adjustments to the GUI. Added multiple tabs for users who require more information or would like to keep track of updates. - Aneurin Weale
;    0.1.0    04/12/2020  Made adjustments to the GUI. Reduced risk of Errors by creacting a function and moving the GUI into that fucntion allowing it to be called upon when pressing the HotKey. - Aneurin Weale
;    0.1.1    07/12/2020  Performed Housekeeping. Making sure there is no spelling mistakes or any incorrect information. - Aneurin Weale
;    1.0.0    16/12/2020  Released Final copy to LM's and DTL for evaluation ready to be pushed out to Team 6. - Aneurin Weale
;    1.0.1    16/02/2021  Special Edition Released named "Neu's Edition" - This changes all signatures to Author's Name. On top of this, Short-keys have been added for quick access to common E-Mails (Not a part of Neu's Edition) - Aneurin Weale
;    1.0.2    24/05/2021  Added new submenus to support DLM (PowerShell & PSExec)
;    1.0.3    26/05/2021  Added new URL's and Scripts. 
;
;
;
;
;
;*************************************************************************************************************************
;*************************************************************************************************************************
;*************************************************************************************************************************
;		Script Starts here
;*************************************************************************************************************************
;
;
;
; Create another menu destined to become a submenu of the above menu.
Menu, Submenu1, Add, FlushDNS, Flushdns, MenuHandler
Menu, Submenu1, Add, Gpupdate, gpupdate, MenuHandler
Menu, Submenu1, Add, GSN Profile Deletion, ProfileDeletion, MenuHandler
Menu, Submenu1, Add, Hostname, hostname, MenuHandler
Menu, Submenu1, Add, Ipconfig, ipconfig, MenuHandler
Menu, Submenu1, Add, Net Use, NetUse, MenuHandler
Menu, Submenu1, Add, Ping, ping, MenuHandler
Menu, Submenu1, Add, Tracert, tracert, MenuHandler


; Create another menu destined to become a submenu of the above menu.
Menu, Submenu2, Add, applicationDeploymentEvaluationCycle, applicationDeploymentEvaluationCycle, MenuHandler
Menu, Submenu2, Add, bitlockerStatus, bitlockerStatus, MenuHandler
Menu, Submenu2, Add, findInstalledProgram, findInstalledProgram, MenuHandler
Menu, Submenu2, Add, machinePolicyEvaluationCycle, machinePolicyEvaluationCycle, MenuHandler
Menu, Submenu2, Add, machinePolicyRetrievalCycle, machinePolicyRetrievalCycle, MenuHandler
Menu, Submenu2, Add, remoteSignedPowershell, remoteSignedPowershell, MenuHandler
Menu, Submenu2, Add, suspendBitlocker, suspendBitlocker, MenuHandler
Menu, Submenu2, Add, uninstallProgram, uninstallProgram, MenuHandler
Menu, Submenu2, Add, userPolicyEvaluationCycle, userPolicyEvaluationCycle, MenuHandler
Menu, Submenu2, Add, userPolicyRetrievalCycle, userPolicyRetrievalCycle, MenuHandler


; Create another menu destined to become a submenu of the above menu.
Menu, Submenu3, Add, checkUpTime, checkUpTime, MenuHandler
Menu, Submenu3, Add, currentLoggedOnUser, currentLoggedOnUser, MenuHandler
Menu, Submenu3, Add, customReboot, customReboot, MenuHandler
Menu, Submenu3, Add, forceReboot, forceReboot, MenuHandler
Menu, Submenu3, Add, getGUID, getGUID, MenuHandler
Menu, Submenu3, Add, installSCCMClient, installSCCMClient, MenuHandler
Menu, Submenu3, Add, runPS1File, runPS1File, MenuHandler
Menu, Submenu3, Add, singlePowershellCommand, singlePowershellCommand, MenuHandler
Menu, Submenu3, Add, uninstallSCCMClient, uninstallSCCMClient, MenuHandler


; Create another menu destined to become a submenu of the above menu.
Menu, Submenu4, Add, Clear IE Cache and Cookies, ClearCacheAndCookies, MenuHandler
Menu, Submenu4, Add, Clear Temp Files, temp, MenuHandler
Menu, Submenu4, Add, Device Manager, DeviceManager, MenuHandler
Menu, Submenu4, Add, Explorer.exe, explorer, MenuHandler
Menu, Submenu4, Add, Network Adapter Connections, ncpa, MenuHandler
Menu, Submenu4, Add, rundll32.exe keymgr.dll KRShowKeyMgr, RUNDLL, MenuHandler


; Create another menu destined to become a submenu of the above menu.
Menu, Submenu5, Add, AirWatch URL, AirWatch, MenuHandler
Menu, Submenu5, Add, Apple School Manager URL, AppleID, MenuHandler
Menu, Submenu5, Add, Bitlocker CORP URL, BitlockerCORP, MenuHandler
Menu, Submenu5, Add, Bitlocker GL URL, BitlockerGL, MenuHandler
Menu, Submenu5, Add, CareFirst URL, Carefirst, MenuHandler
Menu, Submenu5, Add, Cordia URL, CordiaSQ, MenuHandler
Menu, Submenu5, Add, Equitrac URL, Equitrac, MenuHandler
Menu, Submenu5, Add, GCC Ensemble URL, GCCEnsemble, MenuHandler
Menu, Submenu5, Add, GCC SIM and LIM URL, SIMandLIM, MenuHandler
Menu, Submenu5, Add, GLOW URL, GLOW, MenuHandler
Menu, Submenu5, Add, GOLD URL, GOLD, MenuHandler
Menu, Submenu5, Add, IT CORP Forms, ITCorpForms, MenuHandler
Menu, Submenu5, Add, IT EDU Forms, ITEduForms, MenuHandler
Menu, Submenu5, Add, iWorld URL, iWorld, MenuHandler
Menu, Submenu5, Add, Jamf URL, jamf, MenuHandler
Menu, Submenu5, Add, MyPortal URL, MyPortal, MenuHandler
Menu, Submenu5, Add, OWA CORP URL, OWA.CORP, MenuHandler
Menu, Submenu5, Add, OWA EDU URL, OWA.EDU, MenuHandler
Menu, Submenu5, Add, Pulse URL, Pulse, MenuHandler
Menu, Submenu5, Add, QStory URL, QStory, MenuHandler
Menu, Submenu5, Add, Remedy URL (External), ExtRemedy, MenuHandler
Menu, Submenu5, Add, Remedy URL (Internal), IntRemedy, MenuHandler
Menu, Submenu5, Add, SAP Fiori URL, SAPFiori, MenuHandler
Menu, Submenu5, Add, Verint URL, Verint, MenuHandler


; Create another menu destined to become a submenu of the above menu.
Menu, Submenu6, Add, 3 Strike Rule, 3StrikeRule, MenuHandler
Menu, Submenu6, Add, Analyst Phone Chased #1, AnalystChasedPhone1, MenuHandler
Menu, Submenu6, Add, Analyst Phone Chased #2, AnalystChasedPhone2, MenuHandler
Menu, Submenu6, Add, Analyst Phone Chased #3, AnalystChasedPhone3, MenuHandler
Menu, Submenu6, Add, Analyst E-Mail Chased #1, AnalystChasedEmail1, MenuHandler
Menu, Submenu6, Add, Analyst E-Mail Chased #2, AnalystChasedEmail2, MenuHandler
Menu, Submenu6, Add, Analyst E-Mail Chased #3, AnalystChasedEmail3, MenuHandler
Menu, Submenu6, Add, GCC Call Back V1, GCCCallBackV1, MenuHandler
Menu, Submenu6, Add, GCC Call Back V2, GCCCallBackV2, MenuHandler


; Create another menu destined to become a submenu of the above menu.
Menu, Submenu7, Add, Customer Chase Phone, CustomerChasePhone, MenuHandler
Menu, Submenu7, Add, Customer Chase E-Mail, CustomerChaseEmail, MenuHandler
Menu, Submenu7, Add, Customer Chase WebChat, CustomerChaseWebChat, MenuHandler
Menu, Submenu7, Add, Password Reset, PasswordReset, MenuHandler
Menu, Submenu7, Add, BitLocker Recovery, BitlockerRecoveryV1, MenuHandler
Menu, Submenu7, Add, BitLocker Recovery, BitlockerRecoveryV2, MenuHandler
Menu, Submenu7, Add, Account Unlock, AccountUnlock, MenuHandler
Menu, Submenu7, Add, Iphone Passcode Reset, iPhonePasscodeReset, MenuHandler
Menu, Submenu7, Add, iPhone Network Connection, iPhoneNetwork, MenuHandler
Menu, Submenu7, Add, iPhone Carsafe Camera Permissions, iPhoneCamera, MenuHandler
Menu, Submenu7, Add, iPhone Setup, iPhoneSetup, MenuHandler
Menu, Submenu7, Add, iPhone E-Mails, iPhoneEMails, MenuHandler
Menu, Submenu7, Add, Form Required, FormRequired, MenuHandler
Menu, Submenu7, Add, Outlook Disconnected, OutlookDisconnected, MenuHandler
Menu, Submenu7, Add, Computer Login Issue, ComputerLoginIssue, MenuHandler
Menu, Submenu7, Add, Slow Overall Performance, SlowOverallPerformance, MenuHandler


; Create another menu destined to become a submenu of the above menu.
Menu, Submenu8, Add, GCC LM Authorisation Required, GCCLineManagerAuth, MenuHandler
Menu, Submenu8, Add, GCC Avaya First Response, GCCAvaya, MenuHandler
Menu, Submenu8, Add, GCC Password Rejection, PasswordRejection, MenuHandler
Menu, Submenu8, Add, 90 Day Lockout, GCC90DayLockout, MenuHandler
Menu, Submenu8, Add, GCC Further Information Required, GCCFurtherInformationRequired, MenuHandler
Menu, Submenu8, Add, GCC Outdated Forms, GCCOutdatedForms, MenuHandler
Menu, Submenu8, Add, GCC Sympathy, GCCSympathy, MenuHandler
Menu, Submenu8, Add, GCC Complaint, GCCComplaint, MenuHandler
Menu, Submenu8, Add, GCC AFR Authorisation Required, GCCAFRAuthorisationRequired, MenuHandler


; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
Menu, MyMenu, Add, CMD Commands, :Submenu1
Menu, MyMenu, Add ; Add a separator line below the submenu.
Menu, MyMenu, Add, PowerShell Commands, :Submenu2
Menu, MyMenu, Add ; Add a separator line below the submenu.
Menu, MyMenu, Add, PSExec Commands, :Submenu3
Menu, MyMenu, Add ; Add a separator line below the submenu.
Menu, MyMenu, Add, RUN Commands, :Submenu4
Menu, MyMenu, Add ; Add a separator line below the submenu.
Menu, MyMenu, Add, URL's, :Submenu5
Menu, MyMenu, Add ; Add a separator line below the submenu.
Menu, MyMenu, Add, DQM, :Submenu6
Menu, MyMenu, Add ; Add a separator line below the submenu.
Menu, MyMenu, Add, Customer Chase - Phone, :Submenu7
Menu, MyMenu, Add ; Add a separator line below the submenu.
Menu, MyMenu, Add, Customer Chase - E-Mail, :Submenu8
Menu, MyMenu, Add ; Add a separator line below the submenu.
;================================================================================================================
; GUI - Welcome Page
;================================================================================================================
GUI() ;Assigning GUI to Function.
	{

	Gui, Add, Tab3, BackgroundTrans x0 y0 w690 h450 -wrap,      Welcome      |      Known Issues      |      Patch Notes      |      FAQ's      |


	;Tab 1 is Welcome Page
	
	Gui, Tab, 1
	Gui, Font,, Segoe UI Semibold
	Gui, Font, s38 c44D62C w900
	Gui, Add, Text, x140 y40, NEU ;This Line and the 2 previous lines assign the properties of the word 'CGI'
	Gui, Font,, Arial Nova
	Gui, Font, s15 c999999 w400
	Gui, Add, Text, x250 y45, Welcome to the ;This Line and the 2 previous lines assign the properties of the sentence 'Welcome to the'
	Gui, Font, s17 c999999 w800
	Gui, Add, Text, x250 y70, Neu's Edition of Toolkit Mini ;This Line and the previous line assign the properties of the sentence 'GCC Service Desk Toolkit Mini'
	Gui, Font, s6 Black w400
	Gui, Add, Text, x545 y433, Copyright © 2020 by Aneurin Weale ;This Line and the previous line assign the properties of the sentence 'GCC Service Desk Toolkit Mini'
	Gui, Color, Black, BackgroundTrans
	Gui, Font,, Arial Nova
	Gui, Font, s15 cE11937 w400
	Gui, Font, s10 Black w400

	;The below line is the Read-Only Text box you see on the Welcome page. It's properties are defined in it's existing line and the previous 4 lines. 
	Gui, Add, Edit, readonly r15 hscroll x15 y150 w660 h275, What is the Toolkit Mini? `n`nThe Toolkit Mini is a script designed to launch other scripts to assist GCC Service Desk Analysts to`nprovide better customer service. `n`nHow Does the Toolkit Mini Work? `n`nWhy not try it out yourself by pressing the "CTRL" & "1" keys together. `nA drop down menu should appear allowing you to choose the many scripts built into the Toolkit Mini. `nAnother HotKey is "CTRL" & "0", this allows you to bring up this Welcome Page in case you would like to see the latest updates. `n`nTo name a few script Examples: `nCMD/RUN Commands - For when you would like to ping, tracert, hostname, etc. `nURL's - For when you would like to connect to a web application to support clients or to navigate to a webpage for information. `nE-Mails - For when you're writing an E-Mail that has been commonly sent to clients saving you time on call. `n`nSupport `n`nPlease contact myself on aneurin.weale@cgi.com for support or refer to the AutoHotKey Manual.
	
	;Tab 2 is Known Issues

	Gui, Tab, 2
	Gui, Font,, Segoe UI Semibold
	Gui, Font, s38 c44D62C w900
	Gui, Add, Text, x140 y40, NEU
	Gui, Font,, Arial Nova
	Gui, Font, s15 c999999 w400
	Gui, Add, Text, x250 y45, Welcome to the
	Gui, Font, s17 c999999 w800
	Gui, Add, Text, x250 y70, Neu's Edition of Toolkit Mini
	Gui, Font, s6 Black w400
	Gui, Add, Text, x545 y433, Copyright © 2020 by Aneurin Weale
	Gui, Color, 222222
	Gui, Font,, Arial Nova
	Gui, Font, s15 cE11937 w400
	Gui, Font, s10 Black w400
	;The below line is the Read-Only Text box you see on the Known Issues page. It's properties are defined in it's existing line and the previous 4 lines. 
	Gui, Add, Edit, readonly r15 hscroll x15 y150 w660 h275, Known Issues: `n`nUsing Scripts directly on Avaya E-Mails or Avaya WebChat, will not paragraph sentences.
	
	;Tab 3 is Patch Notes

	Gui, Tab, 3
	Gui, Font,, Segoe UI Semibold
	Gui, Font, s38 c44D62C w900
	Gui, Add, Text, x140 y40, NEU
	Gui, Font,, Arial Nova
	Gui, Font, s15 c999999 w400
	Gui, Add, Text, x250 y45, Welcome to the
	Gui, Font, s17 c999999 w800
	Gui, Add, Text, x250 y70, Neu's Edition of Toolkit Mini
	Gui, Font, s6 Black w400
	Gui, Add, Text, x545 y433, Copyright © 2020 by Aneurin Weale
	Gui, Color, 222222
	Gui, Font,, Arial Nova
	Gui, Font, s15 cE11937 w400
	Gui, Font, s10 Black w400
	;The below line is the Read-Only Text box you see on the Patch Notes page. It's properties are defined in it's existing line and the previous 4 lines. 
	Gui, Add, Edit, readonly r15 hscroll x15 y150 w660 h275, Patch Notes: `n`n1.0.0    16/12/2020  GCC SD Toolkit Mini developed and released to Team 6.`n1.0.1    16/02/2021  Welcome to The Toolkit Mini Neu's Edition. The main change for Neu's Edition is that all signatures have been modified to have the Author's name instead of the generic FIRSTNAME. Separate to Neu's Edition, Short-Keys have been added to output common E-Mails faster than ever before.`n1.0.2    24/05/2021  Added new submenus to support DLM (PowerShell & PSExec).
	
	;Tab 4 is FAQ's

	Gui, Tab, 4
	Gui, Font,, Segoe UI Semibold
	Gui, Font, s38 c44D62C w900
	Gui, Add, Text, x140 y40, NEU
	Gui, Font,, Arial Nova
	Gui, Font, s15 c999999 w400
	Gui, Add, Text, x250 y45, Welcome to the
	Gui, Font, s17 c999999 w800
	Gui, Add, Text, x250 y70, Neu's Edition of Toolkit Mini
	Gui, Font, s6 Black w400
	Gui, Add, Text, x545 y433, Copyright © 2020 by Aneurin Weale
	Gui, Color, 222222
	Gui, Font,, Arial Nova
	Gui, Font, s15 cE11937 w400
	Gui, Font, s10 Black w400
	;The below line is the Read-Only Text box you see on the FAQ's page. It's properties are defined in it's existing line and the previous 4 lines. 
	Gui, Add, Edit, readonly r15 hscroll x15 y150 w660 h275, FAQ's: `n`nHow does the script work? `nThe script works by using the HotKey, which displays a selections of scripts to choose from. `nBefore selecting any of the scripts please make sure your device is currently focused on an area that you would like to output the script. `nThis does not mean that it outputs to where the cursor is but where your device is currently focusing on.
	
	Gui, show, w690 h450, Neu's Edition of Toolkit Mini ;This Outputs the GUI with all the Tabs properties.
	return
	
	}

GUI() ;Launches Function, which launches GUI.

;================================================================================================================
; CONTROLS
;================================================================================================================
; Loads Welcome Page
^0::
Gui, Destroy ;Destroys previous GUI to prevent current GUI clashing with previous GUI.
GUI() ;Launches Function, which launches GUI.
return

; Loads Menu
^1::Gosub, ShowPop
ShowPop:
Menu MyMenu, Show
return


;================================================================================================================
; SHORT-KEYS
;================================================================================================================
		;//REFERENCE - CALL BACK\\
^+0::
		SetKeyDelay, -1
                
            		    	if(A_hour < 12)
                         		        {
                         		             Send Good Morning,{Enter}{Enter}
                			        }
                		Else if (A_hour >=12)
                	       	                {
                			             Send Good Afternoon,{Enter}{Enter}
                		                }
		sleep 100
		Send Please contact the service desk at your earliest convenience regarding ticket – REFERENCE - SUMMARY {Enter}
                Send Tel: 0330 123 5569 {Enter}{Enter}
                Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
                Send Kind Regards {Enter}{Enter}
		Send Aneurin @ Service Desk {Enter}
		Send CGI | Glasgow City Council Service Desk {Enter}
		Send T: | 03301235569 {Enter}
		Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
		Send Did you know..{Enter}
		Send You can get updates on Incidents & Service Requests by using our Live WebChat?
                Return

                ;//MYPORTAL REQUEST REJECTION\\
^+9::
		SetKeyDelay, -1
                
            		    	if(A_hour < 12)
                         		        {
                         		             Send Good Morning,{Enter}{Enter}
                			        }
                		Else if (A_hour >=12)
                	       	                {
                			             Send Good Afternoon,{Enter}{Enter}
                		                }
		sleep 100
		Send Unfortunately, this form has been rejected due to [NAME] not being in scope for MyPortal. Please contact Deanna Morgan (Deanna.Morgan@glasgow.gov.uk) to see if you can get this changed. {Enter}{Enter}
		Send We apologise for the inconvenience. If you require further information, then please contact the service desk at your earliest convenience regarding ticket – REFERENCE - SUMMARY {Enter}
                Send Tel: 0330 123 5569 {Enter}{Enter}
                Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
                Send Kind Regards {Enter}{Enter}
		Send Aneurin @ Service Desk {Enter}
		Send CGI | Glasgow City Council Service Desk {Enter}
		Send T: | 03301235569 {Enter}
		Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
		Send Did you know..{Enter}
		Send You can get updates on Incidents & Service Requests by using our Live WebChat?
                Return
                
		;//SOFTWARE REQUEST REJECTION\\
^+8::
		SetKeyDelay, -1
                
            		    	if(A_hour < 12)
                         		        {
                         		             Send Good Morning,{Enter}{Enter}
                			        }
                		Else if (A_hour >=12)
                	       	                {
                			             Send Good Afternoon,{Enter}{Enter}
                		                }
		sleep 100
		Send The request for SOFTWARE has been deployed to your device. Please keep your device connected to the network for up to 4 hours for the software to install. {Enter}{Enter}
		Send If you decide to shut down/restart your device or disconnect in any way, then the install will stop and restart from the beginning the next time you reconnect to the network. {Enter}{Enter}
		Send If you have kept your device connected to the network for 4 hours or more and the software has still not installed, then please contact the Service Desk. {Enter}{Enter}
		Send For more information, please contact the service desk at your earliest convenience regarding ticket – REFERENCE - SUMMARY {Enter}
                Send Tel: 0330 123 5569 {Enter}{Enter}
                Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
                Send Kind Regards {Enter}{Enter}
		Send Aneurin @ Service Desk {Enter}
		Send CGI | Glasgow City Council Service Desk {Enter}
		Send T: | 03301235569 {Enter}
		Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
		Send Did you know..{Enter}
		Send You can get updates on Incidents & Service Requests by using our Live WebChat?
                Return

;================================================================================================================
; CMD COMMANDS
;================================================================================================================

Flushdns:
Sleep 500
clipboard := "ipconfig /flushdns"
send ^v
send {Enter}
return

gpupdate:
Sleep 500
clipboard := "gpupdate /force"
send ^v
send {Enter}
return

hostname:
Sleep 500
clipboard := "hostname"
send ^v
send {Enter}
return

ipconfig:
Sleep 500
clipboard := "ipconfig"
send ^v
send {Enter}
return

NetUse:
Sleep 500
clipboard := "net use"
send ^v
send {Enter}
return

ping:
Sleep 500
clipboard := "ping "
send ^v
return

ProfileDeletion:
Sleep 500
clipboard := "delprof2 /u /c:\\ASSET /id:USERNAME"
send ^v
return

tracert:
Sleep 500
clipboard := "tracert "
send ^v
return


;================================================================================================================
; POWERSHELL COMMANDS
;================================================================================================================

applicationDeploymentEvaluationCycle:
Sleep 500
clipboard := "WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule ""{00000000-0000-0000-0000-000000000121}"" /NOINTERACTIVE"
send ^v
send {Enter}
return

bitlockerStatus:
Sleep 500
clipboard := "manage-bde -status C:"
send ^v
send {Enter}
return

findInstalledProgram:
Sleep 500
clipboard := "product get name"
send ^v
send {Enter}
return

hardwareInventoryCycle:
Sleep 500
clipboard := "WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule ""{00000000-0000-0000-0000-000000000001}"" /NOINTERACTIVE"
send ^v
send {Enter}
return

machinePolicyEvaluationCycle:
Sleep 500
clipboard := "WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule ""{00000000-0000-0000-0000-000000000022}"" /NOINTERACTIVE"
send ^v
send {Enter}
return

machinePolicyRetrievalCycle:
Sleep 500
clipboard := "WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule ""{00000000-0000-0000-0000-000000000021}"" /NOINTERACTIVE"
send ^v
send {Enter}
return

remoteSignedPowershell:
Sleep 500
clipboard := "Set-ExecutionPolicy RemoteSigned"
send ^v
send {Enter}
return

suspendBitlocker:
Sleep 500
clipboard := "manage-bde -protectors -disable C:"
send ^v
send {Enter}
return

uninstallProgram:
Sleep 500
clipboard := "product where name=[Application] call uninstall /nointeractive"
send ^v
return

userPolicyEvaluationCycle:
Sleep 500
clipboard := "WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule ""{00000000-0000-0000-0000-000000000027}"" /NOINTERACTIVE"
send ^v
return

userPolicyRetrievalCycle:
Sleep 500
clipboard := "WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule ""{00000000-0000-0000-0000-000000000026}"" /NOINTERACTIVE"
send ^v
return


;================================================================================================================
; PSEXEC COMMANDS
;================================================================================================================

checkUpTime:
Sleep 500
clipboard := "systeminfo | findstr /i ""boot"""
send ^v
send {Enter}
return

currentLoggedOnUser:
Sleep 500
clipboard := "quser"
send ^v
send {Enter}
return

customReboot:
Sleep 500
clipboard := "shutdown -i"
send ^v
send {Enter}
return

forceReboot:
Sleep 500
clipboard := "shutdown -r -t 60 -f"
send ^v
send {Enter}
return

getGUID:
Sleep 500
clipboard := "powershell -ep bypass wmic product list"
send ^v
send {Enter}
return

installSCCMClient:
Sleep 500
clipboard := "ccmsetup.exe /mp:CPSCMAPP02S.user.ad.glasgow.gov.uk SMSSITECODE=CRP"
send ^v
send {Enter}
return

runPS1File:
Sleep 500
clipboard := "powershell -ep bypass -f [Filename]"
send ^v
return

singlePowershellCommand:
Sleep 500
clipboard := "psexec \\machine powershell -ep bypass -Command ""&{PUT YOUR COMMAND HERE}"""
send ^v
return

uninstallSCCMClient:
Sleep 500
clipboard := "ccmsetup.exe /uninstall"
send ^v
send {Enter}
return


;================================================================================================================
; RUN COMMANDS
;================================================================================================================

ClearCacheAndCookies:
Sleep 500
clipboard := "RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255"
send ^v
return

DeviceManager:
Sleep 500
clipboard := "devmgmt.msc"
send ^v
return

explorer:
Sleep 500
clipboard := "explorer.exe"
send ^v
return

ncpa:
Sleep 500
clipboard := "ncpa.cpl"
send ^v
return

RUNDLL:
Sleep 500
clipboard := "rundll32.exe keymgr.dll, KRShowKeyMgr"
send ^v
return

temp:
Sleep 500
clipboard := "`%temp`%"
send ^v
return


;================================================================================================================
; URL Links
;================================================================================================================

AirWatch:
Sleep 500
clipboard := "https://cn532.awmdm.com/AirWatch/Login"
send ^v
return

AppleID:
Sleep 500
clipboard := "school.apple.com"
send ^v
return

BitlockerCORP:
Sleep 500
clipboard := "https://cpmbmcon01s.user.ad.glasgow.gov.uk/HelpDesk/KeyRecoveryPage.aspx"
send ^v
return

BitlockerGL:
Sleep 500
clipboard := "https://csg-cpmbamw01.csglasgow.local/helpdesk/KeyRecoveryPage.aspx"
send ^v
return

Carefirst:
Sleep 500
clipboard := "http://cfrlive.glasgow.gov.uk/cfi/application_store/"
send ^v
return

CordiaSQ:
Sleep 500
clipboard := "https://cda-iis1/CarerSearch/"
send ^v
return

Equitrac:
Sleep 500
clipboard := "https://cpxerequ01s:2941/webtools"
send ^v
return

GCCEnsemble:
Sleep 500
clipboard := "https://ensemble.ent.cgi.com/client/29204/GCCITO/BAUService/ServiceDesk/SitePages/Home.aspx"
send ^v
return

SIMandLIM:
Sleep 500
clipboard := "http://connect.glasgow.gov.uk/article/21720/Key-Contacts"
send ^v
return

GLOW:
Sleep 500
clipboard := "https://glow.rmunify.com/"
send ^v
return

GOLD:
Sleep 500
clipboard := "https://tracking.brightwave.co.uk/LNT/BWMC/Login.aspx?cid=uHEn67S1mn%252f%252fbm1GFV1MCw%253d%253d&cn=Nwz6XyTRmhtW%252b1r5H%252fxEKQ%253d%253d&ts=637001829440377333&currentPage=1"
send ^v
return

ITCorpForms:
Sleep 500
clipboard := "http://connect.glasgow.gov.uk/index.aspx?articleid=19594"
send ^v
return

ITEduForms:
Sleep 500
clipboard := "http://www.goglasgow.org.uk/pages/show/2253"
send ^v
return

iWorld:
Sleep 500
clipboard := "https://iwapp/iworld/iwlive.html"
send ^v
return

jamf:
Sleep 500
clipboard := "https://gccedu.jamfcloud.com/"
send ^v
return

MyPortal:
Sleep 500
clipboard := "http://connect.glasgow.gov.uk/article/12291/My-Portal"
send ^v
return

OWA.CORP:
Sleep 500
clipboard := "http://outlook.office365.com/owa/"
send ^v
return

OWA.EDU:
Sleep 500
clipboard := "https://email.gsn.local/owa/"
send ^v
return

Pulse:
Sleep 500
clipboard := "http://pulse.glasgow.gov.uk/logon.aspx"
send ^v
return

QStory:
Sleep 500
clipboard := "https://cgi.qstory.co.uk/login"
send ^v
return

ExtRemedy:
Sleep 500
clipboard := "https://itsm-uk.cgi.com"
send ^v
return

IntRemedy:
Sleep 500
clipboard := "itsm-uk.ent.cginet/arsys/shared/login.jsp"
send ^v
return

SAPFiori:
Sleep 500
clipboard := "https://engage.glasgow.gov.uk/sap/bc/ui5_ui5/ui2/ushell/shells/abap/FioriLaunchpad.html"
send ^v
return

Verint:
Sleep 500
clipboard := "http://lhwton360app01/wfo/control/signin"
send ^v
return


;============================================
;  DESK QUEUE MANAGEMENT
;============================================

AnalystChasedPhone1:
SetKeyDelay, -1
send SD - Chased User via Telephone {#}1 - (VM left - Y/N)
return

AnalystChasedPhone2:
SetKeyDelay, -1
send SD - Chased User via Telephone {#}2 - (VM left - Y/N)
return

AnalystChasedPhone3:
SetKeyDelay, -1
send SD - Chased User via Telephone {#}3 - (VM left - Y/N)
return

AnalystChasedEmail1:
SetKeyDelay, -1
send SD - Chased User via E-Mail {#}1 - Attached
return

AnalystChasedEmail2:
SetKeyDelay, -1
send SD - Chased User via E-Mail {#}2 - Attached
return

AnalystChasedEmail3:
SetKeyDelay, -1
send SD - Chased User via E-Mail {#}3 - Attached
return

3StrikeRule:
SetKeyDelay, -1
send SD - Final - Resolved based on 3 strike rule
return


GCCCallBackV1:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Please contact the service desk at your earliest convenience regarding ticket – REFERENCE - SUMMARY {Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return


GCCCallBackV2:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send We tried contacting you earlier today but were unable to reach you.{Enter}{Enter}
Send Please contact the service desk at your earliest convenience regarding ticket – REFERENCE - SUMMARY {Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return


;================================================================
;============================================
;  CUSTOMER CHASE - PHONE
;============================================
;================================================================

CustomerChasePhone:
SetKeyDelay, -1
Send SD - User Chase ({#}) - {Space}
return

CustomerChaseEmail:
SetKeyDelay, -1
Send SD - User Chase ({#}) - Email - Attached
return

CustomerChaseWebChat:
SetKeyDelay, -1
Send SD - User Chase ({#}) - WebChat Full Transcript:{Enter}
return

PasswordReset:
SetKeyDelay, -1
sleep 100
Send User called for a DOMAIN\APPLICATION password reset. Passed Security: (Y/N - If yes, please include SAP number. If no, please explain why), Password reset.
Return 

BitlockerRecoveryV1:
SetKeyDelay, -1
Send User called for a Bitlocker Recovery. Passed Security: (Y/N - If yes, please include SAP number. If no, please explain why), Bitlocker Recovery Provided.
Return 

BitlockerRecoveryV2:
SetKeyDelay, -1
Send User called for a Bitlocker Recovery. User had error code 0xc0000001 therefore Passing Security is not required. Bitlocker Recovery Provided.
Return 

AccountUnlock:
SetKeyDelay, -1
sleep 100
Send User called for a DOMAIN\APPLICATION Account Unlock. Passed Security: (Y/N - If yes, please include SAP number), Account Unlocked.
Return 

iPhonePasscodeReset:
SetKeyDelay, -1
Send User called for a iPhone passcode reset, Passed Security: (Y/N - If no, please explain why), passcode wiped.
Return

iPhoneNetwork:
SetKeyDelay, -1
Send User called to inform that they are unable to connect to the GCC Network.{enter}
Send Troubleshooting:{enter}
Send Checked that Airplane was disabled{enter}
Send Checked User is connected to 4G and not WiFi{enter}
Send Checked if user has signal{enter}
Send Airwatch Profile Refresh{enter}
Send Got user to enter Password when password prompt appears after refreshing the profile{enter}
Send (If user is not using the iPhone to call the Service Desk) Rebooted iPhone{enter}{enter}
Send IMEI Number: (Log onto Airwatch, copy and paste SIM Card Info here){enter}
Send Assigned to procurement to check if SIM Card is not activated of if data cap requires increasing.
Return

iPhoneCamera:
SetKeyDelay, -1
Send User called and mentions that they are unable to scan in clients using the Caresafe Application.{enter}
Send Troubleshooting:{enter}
Send Got user to enable Camera Permissions within the iPhone Settings under Caresafe.{enter}
Send User confirms scanning now works.
Return

iPhoneSetup:
SetKeyDelay, -1
Send User called and mentions that their iPhone has been reset and requires assistance in setting up their iPhone.{enter}
Send Troubleshooting:{enter}
Send Provided user clear instructions on how to setup iPhone. iPhone setup complete , Airwtch synced, E-Mails and contacts synced.
Return


iPhoneEMails:
SetKeyDelay, -1
send User informs that they are unable to receive their latest E-Mails.{enter}{enter}
Send Troubleshooting:{enter}
Send Checked that Airplane was disabled{enter}
Send Checked User is connected to 4G and not WiFi{enter}
Send Checked if user has signal{enter}
Send Airwatch Profile Refresh{enter}
Send Got user to enter Password when password prompt appears after refreshing the profile{enter}
Send Password Prompt not accepting users password. Passed Security: (Y/N - If yes, please include SAP number, ignore if homecarer. If no, please explain why), Password reset.{enter}
Send (If user is not using the iPhone to call the Service Desk) Rebooted iPhone{enter}{enter}
Send IMEI Number: (Log onto Airwatch, copy and paste SIM Card Info here){enter}
Send Assigned to Level 2 for further investigation.
Return

FormRequired:
SetKeyDelay, -1
Send User called to inform that they require access to REQUEST.{enter}{enter}
Send Advised user that a FORM is required to be completed and submitted to us to gain access to REQUEST.{enter}
Send Redirected user to the Intranet to find our IT forms and advised that the form may require LM Authorisation before submitting. 
Return

ComputerLoginIssue:
SetKeyDelay, -1
Send User called to inform that an error message occurs when attempting to logon to their device.{Enter}{Enter}
Send Error: "Trust Relationship Error" or "No Logon Servers available"{Enter}{Enter}
Send Troubleshooting: {Enter}
Send Checked Network cable is connected{Enter}
Send Checked Different Network Port{Enter}
Send Checked different Network Cable{Enter}
Send Checked AD Account and Asset {Enter}{Enter}
Send (If issue still persists please follow the below)
Send Rebooted Device{Enter}
Send Asked user if able to log onto another device
Return

SlowOverallPerformance:
SetKeyDelay, -1
Send User called to inform that the overall performance on their device is very slow.{enter}{enter}
Send Troubleshooting:{Enter}
Send Cleared Recycling Bin {Enter}
Send Cleared Temp Files {Enter}
Send Flushdns{Enter}
Send Gpupdate{Enter}
Send Overall System Performance - Best Performance (Don't untick "Show thumbnails instead of icons"){Enter}
Send Checked Task Manager (Check if anything is consuming too much memory){Enter}
Send Restarted PC{Enter}
Send Advised user to monitor system performance. If performance of device has not improved to call back.
Return

OutlookDisconnected:
SetKeyDelay, -1
Send User called to inform that they are unable to send or receive E-Mails.{enter}{enter}
Send Troubleshooting steps:{enter}
Send Checked Network Status{enter}
Send Backed up Drafts, Outbox and Shared Mailboxes{enter}
Send Cleared Temp Files{enter}
Send Cleared cached credentials{enter}
Send Flushdns{enter}
Send Gpupdate{enter}
Send Profile Refresh{enter}
Send (If none of the above worked please perform the below){enter}
Send Checked OWA - Connected to OWA: (Y/N - If yes, Issue is local and requires further troubleshooting. If no, Assign to E-Mail Team)
Return

;================================================================================================================
; CUSTOMER CHASE - E-MAIL
;================================================================================================================

GCCLineManagerAuth:
  SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Thank you for contacting the Glasgow City Council IT Service Desk.{Enter}
Send In order to process the request below, it must be authorised by your Line Manager or equivalent, which must also include a valid email signature at the bottom of the email.{Enter}
Send Once we have received an E-Mail from your Line Manager, we will create a ticket for you and a reference number will be provided.{Enter}
Send We apologise for the inconvenience but if you require further information, then please contact the service desk at your earliest convenience.{Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return 
   
GCCAvaya:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
send Thank you for contacting the Glasgow City Council IT Service Desk, I hope I can help you with your issue and resolve it in a timely manner.{enter}{enter}
send [YOUR MESSAGE]{enter}{enter}
send If you have any further questions or concerns, let us know. We are here from 7am to 7pm Monday to Friday.{enter}{enter}
Send If calling the Service Desk regarding this current issue and it already has a ticket reference number then please quote the ticket reference number assigned to this issue at the start of the call.{enter}
Send Tel: 0330 123 5569{enter}{enter}
Send Kind Regards{enter}{enter}
Send Aneurin @ Service Desk{enter}
Send CGI | Glasgow City Council Service Desk{enter}
Send T: | 03301235569{enter}
Send E: | GCCServiceDesk@cgi.com{enter}{enter}
Send Did you know..{enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return 

PasswordRejection:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Thank you for contacting the Glasgow City Council IT Service Desk.{enter}
Send Unfortunately, we are unable to process this request via E-Mail as we require passing you through security over the phone.{Enter}
Send We apologise for the inconvenience but if you require further information, then please contact the service desk at your earliest convenience.{Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return 


GCC90DayLockout:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Thank you for contacting the Glasgow City Council IT Service Desk.{enter}
Send The relevant GCC Business Partner must approve any devices that have been disabled due to long periods of inactivity before they can be re-enabled.{Enter}{Enter}
Send Please contact the relevant Business Partner for your department, explaining why the device has not been connected to the network for more than 90 days and why it is now required.{Enter}{Enter}
Send Your departments Business Partner is: BUSINESS PARTNER{Enter}{Enter}
Send We apologise for the inconvenience but if you require further information, then please contact the service desk at your earliest convenience.{Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return


GCCAFRAuthorisationRequired:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Thank you for contacting the Glasgow City Council IT Service Desk.{enter}
Send In order to request the below, you will need to contact your Authorised Fault Reporter within your department so they can raise this on your behalf.{enter}
Send Please ensure to follow this process in going forward to avoid any future delays for yourself.{enter}{enter}
Send We apologise for the inconvenience but if you require further information, then please contact the service desk at your earliest convenience.{Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return

GCCFurtherInformationRequired:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Thank you for contacting the Glasgow City Council IT Service Desk.{enter}{enter}
Send Please can you provide further information of the issue/request so that we can log this accordingly. Once more information has been provided we will then be able to log your request. {enter}{enter}
Send Please ensure to follow this process in going forward to avoid any future delays for yourself.  {enter}{enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return


GCCOutdatedForms:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Thank you for contacting the Glasgow City Council IT Service Desk.{enter}
Send The form you have provided is no longer accepted by our resolver teams and will not be processed due to the form submitted being out-of-date.{enter}{enter}
Send To find our up-to-date IT forms please click on one of the links below:{enter}{enter}
Send http://connect.glasgow.gov.uk/index.aspx?articleid=19594 - For Corporate and GlasgowLife{enter}{enter}
Send http://www.goglasgow.org.uk/pages/show/2253 - For Education{enter}{enter}
Send Once you have submitted your form to us, we will raise a new work order for you and we will provide you the reference number as soon as it has been raised.{enter}{enter}
Send We apologise for the inconvenience but if you require further information, then please contact the service desk at your earliest convenience.{Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return


GCCSympathy:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Thank you for contacting the Glasgow City Council IT Service Desk.{enter}
Send We are sorry to hear that your ticket [REFERENCE] is not yet resolved.{enter}{enter} 
Send I have updated your ticket informing the relevant team to advise them of the issues you are currently experiencing to which they will continue to investigate and update us accordingly.{enter}
Send We apologise for the inconvenience but if you require further information, then please contact the service desk at your earliest convenience.{Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return


GCCComplaint:
SetKeyDelay, -1
               
                if(A_hour < 12)
                                {
                                Send Good Morning,{Enter}{Enter}
                                }
                Else if (A_hour >=12)
                                {
                                Send Good Afternoon,{Enter}{Enter}
                                }
sleep 100
Send Thank you for contacting the Glasgow City Council IT Service Desk.{enter}{enter}
Send We're sorry to hear that your experience with CGI has not been satisfactory. We do take this seriously and we will continue to investigate further so that we can deliver the best customer service possible.{Enter}{Enter}
Send We apologise for the inconvenience but if you require further information, then please contact the service desk at your earliest convenience.{Enter}
Send Tel: 0330 123 5569 {Enter}{Enter}
Send Please quote the reference shown in the subject line of this email. {Enter}{Enter}
Send Kind Regards {Enter}{Enter}
Send Aneurin @ Service Desk {Enter}
Send CGI | Glasgow City Council Service Desk {Enter}
Send T: | 03301235569 {Enter}
Send E: | GCCServiceDesk@cgi.com {Enter}{Enter}
Send Did you know..{Enter}
Send You can get updates on Incidents & Service Requests by using our Live WebChat?
Return
