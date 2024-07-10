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
echo                                         v0.92 [BETA]
echo -----------------------------------------------------------------------------------------------
ping -n 1 127.0.0.1 >nul
cls
goto anamenu


:anamenu
cls
echo -----------------------------------------------------------------------------------------------
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.   
echo  Created by    .86.......868...86.86.......86....86.86.......86.....86.86....86  
echo                .86.......8686..86.86.......86.......86.......86.....86.86......
echo                .868686...86.86.86.868686....868686..868686...868686868..868686.
echo                .86.......86..8686.86.............86.86.......86.....86.......86
echo                .86.......86...868.86.......86....86.86.......86.....86.86....86
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.    with ♥
echo -----------------------------------------------------------------------------------------------
echo                                         v0.92 [BETA]
echo -----------------------------------------------------------------------------------------------
echo                 [1] Optimize the Operating System.
echo                 [2] Manually Optimize the Operating System.
echo                 [3] Clean Unnecessary Files.
echo                 [4] Windows Tweaks.
echo                 [5] Windows License Activation. [BETA]
echo                 [6] About.
echo                 [7] Exit.
echo -----------------------------------------------------------------------------------------------
echo.
set /p secim="Enter the Number of the Operation You Want to Perform: "

if %secim%==1 goto sistem_optimize
if %secim%==2 goto sistem_optimize_manuel
if %secim%==3 goto gereksiz_dosyalar
if %secim%==4 goto ozel_ayarlar
if %secim%==5 goto windows_etkinlestir
if %secim%==6 goto hakkında
if %secim%==7 goto nul

echo You Have Made an Invalid Selection. Please Try Again!!
ping -n 2 127.0.0.1 >nul
cls
goto anamenu

:sistem_optimize_manuel
cls
echo -----------------------------------------------------------------------------------------------
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.   
echo  Created by    .86.......868...86.86.......86....86.86.......86.....86.86....86  
echo                .86.......8686..86.86.......86.......86.......86.....86.86......
echo                .868686...86.86.86.868686....868686..868686...868686868..868686.
echo                .86.......86..8686.86.............86.86.......86.....86.......86
echo                .86.......86...868.86.......86....86.86.......86.....86.86....86
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.    with ♥
echo -----------------------------------------------------------------------------------------------
echo                                         v0.92 [BETA]
echo -----------------------------------------------------------------------------------------------
echo                        Note: Does Not Work with Windows 8.1 Build 2351!
echo -----------------------------------------------------------------------------------------------
echo                 [1] Automatically Optimize the Operating System.
echo                 [2] Disk Cleanup.
echo                 [3] Disk Repair.
echo                 [4] Windows Missing File Repair.
echo                 [5] Windows Patches.
echo                 [6] Virus Scan.
echo                 [7] Optimize Random Access Memory.
echo                 [8] System Temperature Control.
echo                 [9] SSD/HDD Error Check.
echo                 [10] Return to Main Menu...
echo -----------------------------------------------------------------------------------------------
echo.
set /p secim="Enter the Number of the Operation You Want to Perform: "

if %secim%==1 goto sistem_optimize2
if %secim%==2 goto disk_temizleme2
if %secim%==3 goto disk_onarimi2
if %secim%==4 goto sistem_eksik_dosya_onarimi2
if %secim%==5 goto guncelleme_kontrol2
if %secim%==6 goto antivirus_taramasi2
if %secim%==7 goto ram_optimize2
if %secim%==8 goto sistem_sicakligi2
if %secim%==9 goto bellek_kontrol2
if %secim%==10 goto anamenu

echo You Have Made an Invalid Selection. Please Try Again!
ping -n 2 127.0.0.1 >nul
cls
goto sistem_optimize_manuel


:ozel_ayarlar
cls
echo -----------------------------------------------------------------------------------------------
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.   
echo  Created by    .86.......868...86.86.......86....86.86.......86.....86.86....86  
echo                .86.......8686..86.86.......86.......86.......86.....86.86......
echo                .868686...86.86.86.868686....868686..868686...868686868..868686.
echo                .86.......86..8686.86.............86.86.......86.....86.......86
echo                .86.......86...868.86.......86....86.86.......86.....86.86....86
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.    with ♥
echo -----------------------------------------------------------------------------------------------
echo                                         v0.92 [BETA]
echo -----------------------------------------------------------------------------------------------
echo                 [1] Update All Applications on Windows.
echo                 [2] Fix Internet Issues.
echo                 [3] Install Ad Blocker.
echo                 [4] Remove Ad Blocker / Clear DNS.
echo                 [5] Fix MSI Installer 2502/2503 Errors.
echo                 [6] Return to Main Menu...
echo -----------------------------------------------------------------------------------------------
echo.
set /p secim="Enter the Number of the Operation You Want to Perform: "

if %secim%==1 goto guncelle
if %secim%==2 goto internet_sorun_gider
if %secim%==4 goto dns_temizle
if %secim%==3 goto ozel_dns
if %secim%==5 goto msi_bug
if %secim%==6 goto anamenu

echo You Have Made an Invalid Selection. Please Try Again!
ping -n 2 127.0.0.1 >nul
cls
goto ozel_ayarlar



:windows_etkinlestir
cls
echo -----------------------------------------------------------------------------------------------
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.   
echo  Created by    .86.......868...86.86.......86....86.86.......86.....86.86....86  
echo                .86.......8686..86.86.......86.......86.......86.....86.86......
echo                .868686...86.86.86.868686....868686..868686...868686868..868686.
echo                .86.......86..8686.86.............86.86.......86.....86.......86
echo                .86.......86...868.86.......86....86.86.......86.....86.86....86
echo                .86868686.86....86.86868686..868686..86868686.86.....86..868686.    with ♥
echo -----------------------------------------------------------------------------------------------
echo                                         v0.92 [BETA]
echo -----------------------------------------------------------------------------------------------
echo          The user is solely responsible for any liability arising from the use of this program.
echo -----------------------------------------------------------------------------------------------
echo                 [1] Activate Windows License.
echo                 [2] Activate Windows License with KMS. [Not Recommended]
echo                 [3] Show License Information.
echo                 [4] Backup and Restore License.
echo                 [5] Remove License.
echo                 [6] Set Activation Server.
echo                 [7] Renew Activation Period. [BETA]
echo                 [8] Return to Main Menu...
echo -----------------------------------------------------------------------------------------------
echo.
set /p secim="Enter the Number of the Operation You Want to Perform: "

if "%secim%"=="1" goto etkinlestir
if "%secim%"=="2" goto etkinlestir_kms
if "%secim%"=="3" goto bilgiler
if "%secim%"=="4" goto yedekle
if "%secim%"=="5" goto kaldır
if "%secim%"=="6" goto sunucu_ayarla
if "%secim%"=="7" goto etkinlestirme_yenile
if %secim%==8 goto anamenu

echo You Have Made an Invalid Selection. Please Try Again!
ping -n 2 127.0.0.1 >nul
cls
goto windows_etkinlestir

rem --------------------------------------------------------------------------------------------------------------
:hakkında
cls
echo.
echo                             Enesehs's Windows Optimizer v0.95 Beta
echo.
echo Enesehs's Windows Optimizer is a open-source software developed to optimize Windows operating systems and improve their performance. This software allows users to run their computers faster and more efficiently. It cleans unnecessary files to free up disk space, provides access to hidden Windows features, and facilitates easier activation of Windows. This software enhances your computer's performance. Enesehs's Windows Optimizer provides all the tools you need to ensure that your Windows operating system runs smoothly.
echo.
echo.
echo Lisans: GPL-3.0®  Licence
echo  Copyright (C) 2007 Free Software Foundation, Inc.
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
echo.
echo Contact: enesehs@protonmail.com
pause > NUL
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
rem -------------------------------------------------------------------------------------------------------
:disk_temizleme2
color 8&echo Starting Disk Cleanup Process...                   
cleanmgr /sagerun:1
color a&echo The Disk Cleanup Process was Successful!
ping -n 2 127.0.0.1 >nul
cls
goto sistem_optimize_manuel

:disk_onarimi2
color 8&echo Starting Disk Repair...                           
chkdsk /f
color a&echo Disk Repair Successful!
ping -n 2 127.0.0.1 >nul
cls
goto sistem_optimize_manuel

:sistem_eksik_dosya_onarimi2                                    
echo Fixing System Missing Files... (this may take a while)   
color 8&sfc /scannow
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /startcomponentcleanup
color a&echo System File Repair Successful!
ping -n 2 127.0.0.1 >nul
cls
goto sistem_optimize_manuel

:guncelleme_kontrol2
color 8&echo Checking for Updates Process Started...          
wuauclt /detectnow /updatenow
color a&echo Check for Updates Process Successful!
ping -n 2 127.0.0.1 >nul
cls
goto sistem_optimize_manuel

:antivirus_taramasi2
color 8&echo Starting Antivirus Scan...                         
start /wait "Windows Defender" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3
color a&echo Antivirus Scan Process Successful!
ping -n 2 127.0.0.1 >nul
cls
goto sistem_optimize_manuel

:ram_optimize2
color 8&echo Optimizing RAM... (restart may be required)               
mdsched.exe
color a&echo RAM Optimization Successful!
ping -n 2 127.0.0.1 >nul
cls
goto sistem_optimize_manuel

:sistem_sicakligi2
color 8&echo Checking System Temperature...                    
color 4&echo System Temperature: 
wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature
color a&echo System Temperature Check Successful!
ping -n 10 127.0.0.1 >nul
cls
goto sistem_optimize_manuel

:bellek_kontrol2
color 8&echo HDD/SSD Error Check Started...                     
chkdsk /f C:
color a&echo HDD/SSD Error Check Successful!
ping -n 2 127.0.0.1 >nul
cls
goto sistem_optimize_manuel

rem-----------------------------------------------------------------------------------------------------
:gereksiz_dosyalar
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

:guncelle
cls
echo Updating applications process initiated...
start powershell -NoExit -Command "& {winget upgrade --all --accept-package-agreements}"
cls
pause > NUL
ping -n 3 127.0.0.1 >nul
echo Application update process completed.
ping -n 3 127.0.0.1 >nul
cls
color a
goto ozel_ayarlar

:msi_bug
cls
echo Fixing MSI Installer 2502/2503 Errors...
takeown /f “%systemroot%\Temp” /R /A /D Y
icacls “%systemroot%\Temp” /inheritance:r /grant:r Users:(OI)(CI)F /T
icacls “%systemroot%\Temp” /inheritance:r /grant:r Everyone:(OI)(CI)F /T
icacls “%systemroot%\Temp” /grant Administrators:F /T
icacls “%systemroot%\Temp” /grant Users:F /T
icacls “%systemroot%\Temp” /grant SYSTEM:F /T
icacls “%systemroot%\Temp” /grant Everyone:F /T

takeown /f “%temp%” /R /A /D Y
icacls “%temp%” /inheritance:r /grant:r Users:(OI)(CI)F /T
icacls “%temp%” /inheritance:r /grant:r Everyone:(OI)(CI)F /T
icacls “%temp%” /grant Administrators:F /T
icacls “%temp%” /grant Users:F /T
icacls “%temp%” /grant SYSTEM:F /T
icacls “%temp%” /grant Everyone:F /T
cls
Echo Complete! 
echo Press any key to continue
pause > NUL
goto ozel_ayarlar

:internet_sorun_gider
 cls
echo Checking internet connection...
    ping -n 1 8.8.8.8 > nul
    if errorlevel 1 (
        echo Internet connection lost. Initiating fix...
        netsh interface ip set dns "Ethernet" dhcp
	netsh winsock reset
	netsh int ip reset
	ipconfig /release
	ipconfig /renew
 	ipconfig /flushdns
        echo Internet connection fix process completed.
    ) else (
        echo Internet connection available.
    )
ping -n 3 127.0.0.1 >nul
cls
goto ozel_ayarlar


:dns_temizle
cls
echo DNS Cleaning...
ipconfig /flushdns
netsh interface ipv4 set dns name="Wi-Fi" dhcp
netsh interface ipv4 delete dns name="Ethernet" all
echo DNS clearing process completed.
ping -n 3 127.0.0.1 >nul
cls
goto ozel_ayarlar


:ozel_dns
cls
echo Installing Ad Blocker (AdGuard)...
    netsh interface ipv4 set dns name=Wi-Fi static 94.140.14.14
    netsh interface ipv4 add dns name=Wi-Fi 94.140.15.15 index=2

    netsh interface ipv4 set dns name=Ethernet static 94.140.14.14
    netsh interface ipv4 add dns name=Ethernet 94.140.15.15 index=2
echo Succesfuly installed Ad Blocker (AdGuard)...
ping -n 3 127.0.0.1 >nul
cls
goto ozel_ayarlar


rem ----------------------------------------------------------------------------------------------------------------

:etkinlestir
cls
echo Activating Windows...
cscript //nologo c:\windows\system32\slmgr.vbs /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 3KHY7-WNT83-DGQKR-F7HPR-844BM
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk MH37W-N47XK-V7XM9-C7227-GCQG9
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk WNMTR-4C88C-JK8YV-HQ7T2-76DF9
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 2F77B-TNFGY-69QQF-B8YKP-D69TJ
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 8DVY4-NV2MW-3CGTG-XCBDB-2PQFM
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk NKJFK-GPHP7-G8C3J-P6JXR-HQRJR
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 44RPN-FTY23-9VTTB-MP9BX-T84FV
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 8N67H-M3CY9-QT7C4-2TR7M-TXYCV
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 6P99N-YF42M-TPGBG-9VMJP-YKHCF
cls
cscript //nologo c:\windows\system32\slmgr.vbs /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
cls

echo Windows Succesfully Activated...
ping -n 3 127.0.0.1 >nul
cls
goto windows_etkinlestir

:etkinlestir_kms
cls
set /p secim="You are about to activate Windows with KMSPico. Are you sure? (Y/N)"
if "%secim%"=="Y" goto etkinlestir_kms_onay
if "%secim%"=="N" goto windows_etkinlestir
if "%secim%"=="y" goto etkinlestir_kms_onay
if "%secim%"=="n" goto windows_etkinlestir

echo You Have Made an Invalid Selection. Please Try Again!
ping -n 2 127.0.0.1 >nul
cls
goto windows_etkinlestir

:etkinlestir_kms_onay
cls
echo Activating Windows with KMSPico...
slmgr /ipk
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms8.msguides.com
slmgr /ato
echo Activation Successful...
ping -n 3 127.0.0.1 >nul
cls
goto windows_etkinlestir

:bilgiler
cls
echo License Information:
slmgr /dlv
ping -n 3 127.0.0.1 >nul
cls
goto windows_etkinlestir

:yedekle
cls
echo Backing up activation information...
slmgr /rilc
ping -n 3 127.0.0.1 >nul
cls
goto windows_etkinlestir

:kaldır
cls
set /p secim="You are about to remove the Windows license. Are you sure? (Y/N)"

if "%secim%"=="Y" goto kaldır_onay
if "%secim%"=="N" goto windows_etkinlestir
if "%secim%"=="y" goto kaldır_onay
if "%secim%"=="n" goto windows_etkinlestir

echo You Have Made an Invalid Selection. Please Try Again!
ping -n 2 127.0.0.1 >nul
cls
goto windows_etkinlestir

:kaldır_onay
cls
echo Removing Windows license
slmgr /cpky
slmgr /upk
slmgr -dlv
ping -n 10 127.0.0.1 >nul
cls
goto windows_etkinlestir

:sunucu_ayarla
cls
set /p server=Enter activation server, e.g., kms8.msguides.com: 
slmgr /skms %server%
slmgr /ckms
ping -n 3 127.0.0.1 >nul
cls
goto windows_etkinlestir

:etkinlestirme_yenile
cls
slmgr /rearm
ping -n 3 127.0.0.1 >nul
echo Activation Period Renewal Successful.
cls
goto windows_etkinlestir

rem -----------------------------------------------------------------------------------


