@echo off
cls
mode con cols=100 lines=45 >nul
color A

echo Asset Tag: %1

echo Copying Gold Link to %1 Desktop
echo *****************************
ECHO.
	
xcopy "C:\Users\Public\Desktop\Service_Desk_Toolkit\links\Gold.url" "\\%1\c$\users\public\desktop\" /y /s /i

ECHO.
echo %1 Copy Complete!
echo *****************************