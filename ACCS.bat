@echo off

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: This script is designed for easy deployment of CDIR Collector execution.
:: It's worth noting that I have also written cdir-go.exe in Golang to resolve the issue of requiring user input to exit the program after CDIR Collector execution.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal enabledelayedexpansion

PUSHD %~DP0 & cd /d "%~dp0"
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof
:runas

echo Automated CDIR Collector Script v1.0.0
echo Author: Dylan Wu
echo Github: github.com/dylanwu-trender/Automated-CDIR-Collector-Script

set "modulesDir=.\Modules"
set "cdirEXE=.\Modules\cdir\cdir-collector.exe"
set "cdirGoEXE=.\Modules\cdir-go.exe"
set "outputDir=.\Output"

if not exist "%cdirEXE%" (
    echo [^^!] The file "%cdirEXE%" does not exist.
    pause
    exit
)

if not exist "%cdirGoEXE%" (
    echo [^^!] The file "%cdirGoEXE%" does not exist.
    pause
    exit
)

echo [*] Evidence collection in progress ...

if not exist "%outputDir%" (
    echo [+] Creating the output directory "%outputDir%"...
    mkdir "%outputDir%"
    echo [*] Output directory created.
)

%cdirGoEXE%

for /d %%I in ("%outputDir%\*") do (
    set "subOutputDir=%%~nxI"
    .\Modules\7z\32bit\7za.exe a -pVirus -r -y -t7z -mx=9 -mmt4 "!subOutputDir!".7z !outputDir!\!subOutputDir!
)

if exist "%outputDir%" (
    echo [-] Deleting the output directory "%outputDir%"...
    rmdir /s /q "%outputDir%"
    echo [*] Output directory deleted.
) else (
    echo [^^!] The output directory "%outputDir%" does not exist.
)

if exist "%modulesDir%" (
    echo [-] Deleting the modules directory "%modulesDir%"...
    rmdir /s /q "%modulesDir%"
    echo [*] Modules directory deleted.
) else (
    echo [^^!] The modules directory "%modulesDir%" does not exist.
)

exit