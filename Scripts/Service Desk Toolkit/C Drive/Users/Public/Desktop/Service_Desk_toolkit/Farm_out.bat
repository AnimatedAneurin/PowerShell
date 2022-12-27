@echo off
cls
mode con cols=100 lines=45 >nul
color A

echo Copying Toolkit to all ASGA'S
echo *****************************
ECHO.

for %%a in (ASGA55689,ASGA61807,ASGA65905,ASGA61652,ASGA57415,ASGA61583,ASGA51045,ASGA56993,ASGA56868,ASGA51045,ASGA61772,ASGA61750,ASGA61583,ASGA55830,ASGA57415,ASGA52803,ASGA56993,ASGA68391,ASGA61652,ASGA65905,ASGA52702,ASGA55826,ASGA61706,ASGA62871,ASGA56577,ASGA55850,ASGA61807,ASGA52914,ASGA61731,ASGA61047,ASGA56666,ASGA52375,ASGA56695,ASGA59815,ASGA52783,ASGA57408,ASGA55689,ASGA65925,ASGA52698,ASGA55597,ASGA61779,ASGA65925) do ( 
	xcopy "C:\Users\Public\Desktop\Service_Desk_toolkit\tyzz_GCC.png" "\\%%a\c$\Users\Public\Desktop\Service_Desk_Toolkit\tyzz_GCC.png" /y /s
	xcopy "C:\Users\Public\Desktop\DO_NOT_CLICK.lnk" "\\%%a\c$\Users\Public\Desktop\DO_NOT_CLICK.lnk" /y /s
	xcopy "C:\Users\Public\Desktop\Service_Desk_toolkit\batch\*.*" "\\%%a\c$\Users\Public\Desktop\Service_Desk_Toolkit\batch\" /y /s /i
	xcopy "C:\Users\Public\Desktop\Service_Desk_toolkit\links\*.*" "\\%%a\c$\Users\Public\Desktop\Service_Desk_Toolkit\links\" /y /s /i
	xcopy "C:\Users\Public\Desktop\Service_Desk_toolkit\Level1_Toolkit_0.8.5.ps1" "\\%%a\c$\Users\Public\Desktop\Service_Desk_Toolkit\Level1_Toolkit_0.8.5.ps1" /y /s
	xcopy "C:\Users\Public\Desktop\Service_Desk_toolkit\gcc-sd-toolkit-help.docx" "\\%%a\c$\Users\Public\Desktop\Service_Desk_Toolkit\gcc-sd-toolkit-help.docx" /y /s
	REM xcopy "C:\windows\system32\delprof2.exe" "\\%%a\c$\Windows\System32\delprof2.exe" 
	
	ECHO.
	echo %%a Copy Complete!
	echo *************
	ECHO.
	ECHO.	
)

echo Process Completed....	
PAUSE
