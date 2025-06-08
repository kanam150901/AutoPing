@echo off
title Auto Ping Monitor with Response Time
color 0a
mode con:cols=62 lines=40
setlocal enabledelayedexpansion

:: Host list for monitoring
set hosts=google.com youtube.com 1.1.1.1 8.8.8.8

:: Ping interval in seconds
set interval=5

:main_loop
cls

:: Get current datetime
for /f "tokens=1-3 delims=/: " %%a in ('time /t') do set waktu=%%a:%%b:%%c
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set tanggal=%%a/%%b/%%c

echo ==============================================================
echo    AAAAA  U   U  TTTTT  OOOOO     PPPPP  II  NN   N  GGGGG
echo    A   A  U   U    T    O   O     P   P  II  NN   N  G 
echo    AAAAA  U   U    T    O   O     PPPPP  II  N  N N  G GGG
echo    A   A  U   U    T    O   O     P      II  N   NN  G   G
echo    A   A  UUUUU    T    OOOOO     P      II  N   NN  GGGGG
echo =================== Auto Ping 1.0 by Namm ====================
echo.
echo   Last update: %tanggal% %waktu%
echo   Ping interval: %interval% seconds
echo   Press CTRL+C to stop
echo. 
echo ==============================================================

:: Ping each host and extract response time
for %%h in (%hosts%) do (
    echo  [HOST] %%h
    ping -n 1 %%h > ping_temp.txt
    
    :: Check if host is reachable
    find "TTL=" ping_temp.txt >nul
    if !errorlevel! equ 0 (
        for /f "tokens=7 delims== " %%t in ('find "time=" ping_temp.txt') do (
            set response_time=%%t
        )
        echo  Status: ONLINE
        echo Response Time: !response_time!
    ) else (
        echo  Status: OFFLINE
        echo  Response Time: N/A
    )
    echo --------------------------------------------------------------
)
:: Cleanup
del ping_temp.txt >nul 2>&1
 color 0a
:: Countdown before next ping
echo Next ping in: 
for /l %%i in (%interval%,-1,1) do (
    <nul set /p "=%%i "
    timeout /t 1 /nobreak >nul
)
echo.
goto main_loop