@echo off
REM cls
mode con cols=100 lines=45 >nul
color A

echo URL: %1
ECHO.

start " " %1
ECHO.
echo .... Exiting.
PING 1.1.1.1 -n 1 -w 200 > NUL

:end
echo. 