@echo off
REM cls
mode con cols=100 lines=45 >nul
color A

echo Username: %2
echo Asset Tag: %1
ECHO.

:BEGIN

SET cpath=\\%1\c$\Users\
SET pathname="\\%1\HKEY_LOCAL_MACHINE\Software\microsoft\windows NT\currentversion\profilelist"

@echo Please ensure the user(%2) is not currently logged in to "%1"
ECHO.

set /p=Once user is logged out hit ENTER to continue...
ECHO.

::----------------------------------------------::
:: 		Folder Name Change		::
::----------------------------------------------::

REM @echo Renaming folder to .old

IF NOT EXIST %cpath%%2 (
	@echo Unable to find user folder in C:\. Exiting.......
	PING 1.1.1.1 -n 1 -w 1500 > NUL
	exit
)

IF EXIST %cpath%%2.old (
	del /f /s /q %cpath%%2_old
)	

IF EXIST %cpath%%2 (
	del /f /s /q %cpath%%2\*.*
	MOVE %cpath%%2 %cpath%%2_old
	@echo Removed User profile %2 from %1
	SET drive=C
	PING 1.1.1.1 -n 1 -w 100 > NUL
	ECHO.
)

@echo Profile refresh has been completed. Exiting.....

PING 1.1.1.1 -n 1 -w 15000 > NUL