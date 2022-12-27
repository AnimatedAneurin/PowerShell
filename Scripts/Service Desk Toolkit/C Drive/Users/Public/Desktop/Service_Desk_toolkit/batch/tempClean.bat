@echo off
REM cls
mode con cols=100 lines=45 >nul
color A

echo Asset Tag: %1
ECHO.

REM ?-Find OS?
echo.

echo Temporary File Deletion
ECHO.
pushd "\\%1\c$\Users"

echo Please close all applications on the user's device, no need to log off.
ECHO.
PAUSE

REM ?-Clean Temp Folder?
echo Cleaning Temp Folder
echo ******************************************************
ECHO.
for /D %%a in (*.*) do DEL /F /S /Q "%%a\AppData\Local\Temp\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("%%a\AppData\Local\Temp\*.*") DO RMDIR /S /Q "%%b"
ECHO.

echo Cleaning Temp Folder
echo ******************************************************
ECHO.
for /D %%a in (*.*) do DEL /F /S /Q "\\%1\c$\temp\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("\\%1\c$\temp\*.*") DO RMDIR /S /Q "%%b"
ECHO.

echo Cleaning Windows Temp Folder
echo ******************************************************
ECHO.
for /D %%a in (*.*) do DEL /F /S /Q "\\%1\c$\Windows\temp\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("\\%1\c$\Windows\temp\*.*") DO RMDIR /S /Q "%%b"
ECHO.

echo Cleaning Prefetch Folder
echo ******************************************************
ECHO.
for /D %%a in (*.*) do DEL /F /S /Q "\\%1\c$\Windows\Prefetch\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("\\%1\c$\Windows\Prefetch\*.*") DO RMDIR /S /Q "%%b"
ECHO.

REM ?-Clean IE Cache?
echo Cleaning IE Cache
echo ******************************************************
ECHO.
for /D %%a in (*.*) do DEL /F /S /Q "%%a\AppData\Local\Microsoft\Windows\Temporary Internet Files\Low\Content.IE5\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("%%a\AppData\Local\Microsoft\Windows\Temporary Internet Files\Low\Content.IE5\*.*") DO RMDIR /S /Q "%%b"
ECHO.

for /D %%a in (*.*) do DEL /F /S /Q "%%a\AppData\Local\Microsoft\Windows\Temporary Internet Files\Low\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("%%a\AppData\Local\Microsoft\Windows\Temporary Internet Files\Low\*.*") DO RMDIR /S /Q "%%b"
ECHO.

for /D %%a in (*.*) do DEL /F /S /Q "%%a\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("%%a\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*") DO RMDIR /S /Q "%%b"
ECHO.

REM ?-Clean Chrome Install Files?
echo Cleaning Chrome Install Files
echo ******************************************************
ECHO.
for /D %%a in (*.*) do RD /S /Q "%%a\AppData\Local\Google\Chrome"
for /D %%a in (*.*) do FOR /D %%b IN ("%%a\AppData\Local\Google\Chrome") DO RMDIR /S /Q "%%b"
ECHO.
for /D %%a in (*.*) do RD /S /Q "%%a\AppData\Local\Google\Update"
for /D %%a in (*.*) do FOR /D %%b IN ("%%a\AppData\Local\Google\Update") DO RMDIR /S /Q "%%b"
ECHO.

echo Clearing Java Cache
echo ******************************************************
ECHO.
javaws -uninstall
ECHO.

echo Clearing Cookies
echo ******************************************************
ECHO.
for /D in (*.*) do DEL /F /S /Q "\\%1\c$\Users\Default\AppData\Roaming\Microsoft\Windows\Cookies\*.*"
for /D in (*.*) do FOR /D %%b IN (\\%1\c$\Users\Default\AppData\Roaming\Microsoft\Windows\Cookies\*.*") DO RMDIR /S /Q "%%b"
ECHO.


echo Clearing Chrome Cache
echo ******************************************************
ECHO.
for /D %%a in (*.*) do DEL /F /S /Q "%%a\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("%%a\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*") DO RMDIR /S /Q "%%b"
ECHO.

echo Clearing Firefox Cache
echo ******************************************************
ECHO.
for /D %%a in (*.*) do DEL /F /S /Q "%%a\AppData\Local Settings\Application Data\Mozilla\Firefox\Profiles\%%a\Cache\*.*"
for /D %%a in (*.*) do FOR /D %%b IN ("%%a\AppData\Local Settings\Application Data\Mozilla\Firefox\Profiles\%%a\Cache\*.*") DO RMDIR /S /Q "%%b"
ECHO.

ECHO.
echo Deletion has completed.... Exiting.
PING 1.1.1.1 -n 1 -w 15000 > NUL

:end
echo.