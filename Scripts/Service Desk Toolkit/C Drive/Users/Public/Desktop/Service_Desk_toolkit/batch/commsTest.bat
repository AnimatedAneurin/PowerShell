@echo off
REM cls
mode con cols=100 lines=45 >nul
color A

echo Asset: %1
echo ********************
ECHO.


echo CONNECTION TESTING ON %1  > C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt



echo ***START PING TEST*** >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo Executing ping to: %1
ping %1  >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo ***END PING TEST*** >> C:\Users\%Username%\Desktop\commsTest.txt
ECHO.


echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt


echo ***START TRACERT TEST*** >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo Executing tracert to: %1
echo Tracert results: >> C:\Users\%Username%\Desktop\commsResults.txt
tracert %1  >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo ***END TRACERT TEST*** >> C:\Users\%Username%\Desktop\commsTest.txt
ECHO.


echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt


echo ***START NSLOOKUP TEST*** >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo Executing nslookup to: %1
echo DNS lookup results: >> C:\Users\%Username%\Desktop\commsTest.txt
nslookup %1  >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo ***END NSLOOKUP TEST*** >> C:\Users\%Username%\Desktop\commsTest.txt
ECHO.


echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt


echo ***START NET STAT TEST*** >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo Executing net stat to: %1
echo Net Stat results: >> C:\Users\%Username%\Desktop\commsTest.txt
psexec \\%1 netstat -aon -p TCP  >> C:\Users\%Username%\Desktop\commsTest.txt
echo. >> C:\Users\%Username%\Desktop\commsTest.txt
echo ***END NET STAT TEST*** >> C:\Users\%Username%\Desktop\commsTest.txt
ECHO.



echo Opening results file....

PING 1.1.1.1 -n 1 -w 3000 > NUL

%SystemRoot%\explorer.exe "C:\Users\%Username%\Desktop\commsTest.txt"
ECHO.

echo Comms check complete, exiting....

PING 1.1.1.1 -n 1 -w 9000 > NUL

exit 