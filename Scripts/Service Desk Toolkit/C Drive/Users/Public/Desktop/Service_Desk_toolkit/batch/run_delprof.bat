@echo off
REM cls
mode con cols=100 lines=45 >nul
color A

echo Asset Tag: %1
echo Username: %2
ECHO.

IF [%2%]==[] (
	echo ** BEASTMODE ACTIVATED **
	ECHO.
	echo Starting profile deletion.

	delprof2 /u /c:\\%1
) Else (
	echo Starting profile deletion.	

	delprof2 /u /c:\\%1 /id:%2
)


ECHO.
echo ** Finished! **
ECHO.
echo Please press enter to close.
TIMEOUT /T 10 /nobreak>nul
ECHO.
echo You can close me now, please. ;)
set /p=


