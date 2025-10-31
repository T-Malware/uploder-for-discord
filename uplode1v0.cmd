@echo off
setlocal enabledelayedexpansion

:: --- Files ---
set "USERFILE=%~dp0username.txt"
set "CONFIG=%~dp0webhooks.txt"

:: --- Username ---
if exist "%USERFILE%" (
    set /p USERNAME=<"%USERFILE%"
)
if "%USERNAME%"=="" (
    set /p USERNAME=Please enter your name: 
    if "%USERNAME%"=="" (
        echo [ERROR] No name entered.
        pause
        exit /b
    )
    >"%USERFILE%" echo %USERNAME%
)

:: --- Check for webhook file ---
if not exist "%CONFIG%" (
    echo [INFO] No webhooks found. Creating new webhook file.
    echo Please add a webhook manually in "%CONFIG%" using this format:
    echo WebhookName=https://discord.com/api/webhooks/YOUR_WEBHOOK_URL
    pause
    exit /b
)

:: --- Load webhooks ---
set count=0
for /f "usebackq tokens=1,* delims==" %%A in ("%CONFIG%") do (
    if not "%%A"=="" if not "%%B"=="" (
        set /a count+=1
        set "hookname[!count!]=%%A"
        set "hookurl[!count!]=%%B"
    )
)
if %count%==0 (
    echo [ERROR] No valid webhooks found.
    pause
    exit /b
)
echo [INFO] %count% webhook(s) loaded.
echo.

:: --- List files in folder ---
set "filecount=0"
for %%F in (*.*) do (
    set /a filecount+=1
    set "file[!filecount!]=%%F"
    echo !filecount!: %%F
)
if %filecount%==0 (
    echo [ERROR] No files found in the current folder.
    pause
    exit /b
)

:: --- Select files ---
set "selectedfiles="
:selectfiles
set "choice="
set /p choice=Enter file number (or press ENTER when done):
if "%choice%"=="" goto donefiles
for %%i in (%choice%) do (
    if defined file[%%i] (
        set "selectedfiles=!selectedfiles! %%i"
    ) else (
        echo [ERROR] Invalid selection: %%i
    )
)
goto selectfiles
:donefiles

if "%selectedfiles%"=="" (
    echo [ERROR] No files selected.
    pause
    exit /b
)

:: --- Select webhooks ---
echo.
echo Available webhooks:
for /L %%i in (1,1,%count%) do echo %%i: !hookname[%%i]!
set "selectedhooks="
:selecthooks
set "hchoice="
set /p hchoice=Enter webhook number (or press ENTER when done):
if "%hchoice%"=="" goto donehooks
for %%i in (%hchoice%) do (
    if defined hookurl[%%i] (
        set "selectedhooks=!selectedhooks! %%i"
    ) else (
        echo [ERROR] Invalid webhook selection: %%i
    )
)
goto selecthooks
:donehooks

if "%selectedhooks%"=="" (
    echo [ERROR] No webhook selected.
    pause
    exit /b
)

:: --- Upload ---
echo.
for %%f in (%selectedfiles%) do (
    set "FILE=!file[%%f]!"
    echo [INFO] Uploading file: !FILE!
    for %%h in (%selectedhooks%) do (
        set "WEBHOOK=!hookurl[%%h]!"
        echo [INFO] Sending to webhook !hookname[%%h]! ...
        curl -s --ssl-no-revoke -X POST "!WEBHOOK!" ^
            -F "payload_json={\"content\":\"New file from %USERNAME%\",\"username\":\"UploaderBot\"}" ^
            -F "file1=@!FILE!"
        if errorlevel 1 (
            echo [ERROR] Upload of !FILE! to !hookname[%%h]! failed.
        ) else (
            echo [OK] Upload of !FILE! to !hookname[%%h]! successful.
        )
    )
)

pause
endlocal
