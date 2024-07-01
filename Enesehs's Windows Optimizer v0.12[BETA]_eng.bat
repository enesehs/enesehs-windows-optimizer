@echo off
chcp 65001 > nul
title Enesehs's Windows Optimizer
mode con: cols=95 lines=30
cls

color 4
timeout /t 1 /nobreak > NUL
openfiles > NUL 2>&1
if %errorlevel%==0 (
    color a
) else (
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo.
    echo                                             Please Run as Administrator!
    echo.
    echo                                               Press any key to exit...
    pause > NUL
    exit
)



:hosgeldin
echo -----------------------------------------------------------------------------------------------
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.   
echo  Created by    .86.......868...86.86.......86....86.86.......86.....86.86....86  
echo                .86.......8686..86.86.......86.......86.......86.....86.86......
echo                .868686...86.86.86.868686....868686..868686...868686868..868686.
echo                .86.......86..8686.86.............86.86.......86.....86.......86
echo                .86.......86...868.86.......86....86.86.......86.....86.86....86
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.    with ♥
echo -----------------------------------------------------------------------------------------------
echo                                         v0.12 [BETA]
echo -----------------------------------------------------------------------------------------------
ping -n 2 127.0.0.1 >nul
cls
goto anamenu


:anamenu

echo -----------------------------------------------------------------------------------------------
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.   
echo  Created by    .86.......868...86.86.......86....86.86.......86.....86.86....86  
echo                .86.......8686..86.86.......86.......86.......86.....86.86......
echo                .868686...86.86.86.868686....868686..868686...868686868..868686.
echo                .86.......86..8686.86.............86.86.......86.....86.......86
echo                .86.......86...868.86.......86....86.86.......86.....86.86....86
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.    with ♥
echo -----------------------------------------------------------------------------------------------
echo                                         v0.12 [BETA]
echo -----------------------------------------------------------------------------------------------
echo                [1] Optimize the Operating System.
echo                [2] Clean Up Unnecessary Files.
echo                [3] Custom Cleanup.
echo                [4] About.
echo                [5] Exit.
echo -----------------------------------------------------------------------------------------------
echo.
set /p secim="Enter the Number of the Operation You Want to Perform: "

if %secim%==1 goto sistem_optimize
if %secim%==2 goto gereksiz
if %secim%==3 goto ozel_temizlik
if %secim%==4 goto hakkinda
if %secim%==5 goto nul


echo You Have Made an Invalid Selection. Please Try Again!
ping -n 2 127.0.0.1 >nul
cls
goto anamenu

rem --------------------------------------------------------------------------------------------------------------
:bitti
cls
echo.
echo                            WİNDOWS SUCCESSFULLY OPTIMIZED...
ping -n 5 127.0.0.1 >nul
cls
goto anamenu

:bitti2
cls
echo.
echo                            SUCCESSFULLY CLEANED UP UNNECESSARY FILES...
ping -n 5 127.0.0.1 >nul
cls
goto anamenu
rem -----------------------------------------------------------------------------------------------------


:hakkinda
cls
echo.
echo                             Enesehs's Windows Optimizer v0.12 [BETA]
echo.
echo Enesehs's Windows Optimizer is a software developed to optimize Windows operating systems and improve their performance. This software allows users to run their computers faster and more efficiently. By cleaning up unnecessary files, it frees up disk space, provides access to ****************************************.This software enhances your computer's performance. Enesehs's Windows Optimizer provides all the tools you need to ensure that your Windows operating system runs smoothly.
echo.
echo.
echo Lisans: GPL-3.0®  Licence
echo Copyright (C) 2007 Free Software Foundation, Inc.
echo Everyone is permitted to copy and distribute verbatim copies
echo of this license document, but changing it is not allowed.
echo.
echo Contact: enesehs@protonmail.com
pause >nul
cls
goto anamenu
rem-----------------------------------------------------------------------------------------------------
:sistem_optimize
cls
:disk_temizleme
color 8&echo Starting Disk Cleanup Process...                   (1/8)
cleanmgr /sagerun:1
color a&echo The Disk Cleanup Process was Successful!
ping -n 2 127.0.0.1 >nul
cls

:disk_onarimi
color 8&echo Starting Disk Repair...                            (2/8)
chkdsk /f
color a&echo Disk Repair Successful!
ping -n 2 127.0.0.1 >nul
cls

:sistem_eksik_dosya_onarimi                                    
echo Fixing System Missing Files... (this may take a while)     (3/8)
color 8&sfc /scannow
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /startcomponentcleanup
color a&echo System File Repair Successful!
ping -n 2 127.0.0.1 >nul
cls

:guncelleme_kontrol
color 8&echo Checking for Updates Process Started...            (4/8)
wuauclt /detectnow /updatenow
color a&echo Check for Updates Process Successful!
ping -n 2 127.0.0.1 >nul
cls

:antivirus_taramasi
color 8&echo Starting Antivirus Scan...                         (5/8)
start /wait "Windows Defender" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3
color a&echo Antivirus Scan Process Successful!
ping -n 2 127.0.0.1 >nul
cls

:ram_optimize
color 8&echo Optimizing RAM... (restart may be required)        (6/8)       
mdsched.exe
color a&echo RAM Optimization Successful!
ping -n 2 127.0.0.1 >nul
cls

:sistem_sicakligi
color 8&echo Checking System Temperature...                     (7/8)
color 4&echo System Temperature: 
wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature
color a&echo System Temperature Check Successful!
ping -n 10 127.0.0.1 >nul
cls

:bellek_kontrol
color 8&echo HDD/SSD Error Check Started...                     (8/8)
chkdsk /f C:
color a&echo HDD/SSD Error Check Successful!
ping -n 2 127.0.0.1 >nul
cls

goto bitti
rem-----------------------------------------------------------------------------------------------------
:gereksiz
cls
:gecici_dosyalar
del /s /f /q %WinDir%\Temp\*.*
del /s /f /q %WinDir%\Prefetch\*.*
del /s /f /q %Temp%\*.*
del /s /f /q %AppData%\Temp\*.*
del /s /f /q %HomePath%\AppData\LocalLow\Temp\*.*
cls
echo Temporary Files Cleaned!                                   (1/4)
ping -n 5 127.0.0.1 >nul

:gecici_klasorler
rd /s /q %WinDir%\Temp
rd /s /q %WinDir%\Prefetch
rd /s /q %Temp%
rd /s /q %AppData%\Temp
rd /s /q %HomePath%\AppData\LocalLow\Temp
cls
echo Temporary Folders Cleaned!                                 (2/4)
ping -n 5 127.0.0.1 >nul


:driver_dosyalari
del /s /f /q %SYSTEMDRIVE%\AMD\*.*
del /s /f /q %SYSTEMDRIVE%\NVIDIA\*.*
del /s /f /q %SYSTEMDRIVE%\INTEL\*.*
rd /s /q %SYSTEMDRIVE%\AMD
rd /s /q %SYSTEMDRIVE%\NVIDIA
rd /s /q %SYSTEMDRIVE%\INTEL
cls
echo Unused Driver Files Cleaned!                               (3/4)
ping -n 5 127.0.0.1 >nul


:geri_olustur
md %WinDir%\Temp
md %WinDir%\Prefetch
md %Temp%
md %AppData%\Temp
md %HomePath%\AppData\LocalLow\Temp
cls
echo Recent Fixes...!                                           (4/4)
ping -n 5 127.0.0.1 >nul

cls
goto bitti2
rem -------------------------------------------------------------------------------------------------------------
:ozel_temizlik
echo This feature is still in BETA stage...
ping -n 3 127.0.0.1 >nul
cls
goto anamenu

