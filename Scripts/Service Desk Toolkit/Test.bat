@echo off
cls
mode con cols=100 lines=45 >nul
color A

echo Copying CGI.png to UK-L5S5B9H2
echo *****************************
ECHO.

for %%a in (UK-L5S5B9H2) do ( 
	xcopy "C:\Users\aneurin.weale\Desktop\SD Script Project\CGI.png" "C:\Users\aneurin.weale\Desktop\CGI.png" /y /s
	
	ECHO.
	echo %%a Copy Complete!
	echo *************
	ECHO.
	ECHO.	
)

echo Process Completed....	
PAUSE
