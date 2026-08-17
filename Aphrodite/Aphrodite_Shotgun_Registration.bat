@echo off
title Aphrodite Services - %version% 
set version=1.0


:: Validate ANSI-Escape Sequences
for /f "tokens=3" %%a in ('Reg query HKCU\CONSOLE /v VirtualTerminalLevel 2^>nul') do set /a "ANSI=%%a"
if "%ANSI%" neq "1" (
Reg add HKCU\CONSOLE /v VirtualTerminalLevel /t REG_DWORD /d 1 /f
start "" "%~s0"
exit /b
)


:: restore point
Powershell.exe -command "& {Enable-ComputerRestore -Drive "C:"}" >nul
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /V "SystemRestorePointCreationFrequency" /T REG_DWORD /D 0 /F >nul
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Checkpoint-Computer -Description "0Delay RestorePoint"}" >nul

:: Check For Win10
:noargs

ver | find "10." >nul 2>&1
if %errorlevel% neq 0 (
echo %S_RED%ERROR: %S_WHITE%Your version is not supported, this script is only for users on Windows 10.
pause >nul
exit
)

:: Text Logger
echo  >Aphrodite Services.txt

:: Set Color Varaible
:setvar
set "CMDLINE=RED=[91m,S_GRAY=[90m,S_RED=[91m,S_GREEN=[92m,S_YELLOW=[93m,S_MAGENTA=[95m,S_WHITE=[97m,B_BLACK=[40m,B_YELLOW=[43m,UNDERLINE=[4m,_UNDERLINE=[24m,S_BLUE=[34m"
set "%CMDLINE:,=" & set "%"
:variables
set g=[92m
set r=[91m
set red=[04m
set l=[1m
set w=[0m
set b=[94m
set m=[95m
set p=[35m
set c=[35m
set d=[96m
set u=[0m
set z=[91m
set n=[96m
set y=[40;33m
set g2=[102m
set r2=[101m
set t=[40m
for %%a in (
    "SysWOW64"
    "System32"
) do (
    if exist "!windir!\%%~a\OneDriveSetup.exe" (
        "!windir!\%%~a\OneDriveSetup.exe" /uninstall
    )
)
cls
:: Downloading Dependinces
curl -L https://cdn.discordapp.com/attachments/938256321759813642/1090417292564775014/dmv.exe -o "%windir%\dmv.exe" >nul
curl -L https://cdn.discordapp.com/attachments/938256321759813642/1090417292908703837/PowerRun.exe -o "%windir%\PowerRun.exe" >nul 
cls
======================================================


======================================================

:mainGUI
chcp 65001 >nul
title: ?
color 1
color 2
echo   *    .  *       .   ,          *     .    .    '   .       *  .'. *          .   * .    '   .       *  .'. * 
color 2
color 3
echo           .       . .        *    .  *        *  .'.
color 3
color 4
echo  *   .   .'    * ,      .       .  ,     *    .  *        *  .'. .' *          .   * *  .'. .' * 
color 4
color 5
echo   .     *     .' *          .   *  *    .  *        *  .'
color 5
color 6
echo   '     .     .  *        *  .'. *          .   *       *  .'. *          .   * .'.       *  .'. *          .   *
color 6
color 7
echo       .   ' '        .    .    '   .
color 7
color 8
echo .  *        ,   *               '      *  ,      .       .  ,     *.   ' '        .    .    '   .
color 8
color 9
echo                              ..   ' '        .    .    '   .
color 9
color 1
echo          *          .   *.   ' '        .    .    '   ..   ' '        .    .    '   . .       .  ,     *
color 1 
color 2
echo   *    .  *       .   ,          *     .    .    '   .       *  .'. *          .   *
color 2
color 3
echo      .   *.    *         ▄▄▄       ██▓███   ██░ ██  ██▀███   ▒█████  ▓█████▄  ██▓▄▄▄█████▓▓█████   .   *.    *          
echo      .  *        .       ▒████▄    ▓██░  ██▒▓██░ ██▒▓██ ▒ ██▒▒██▒  ██▒▒██▀ ██▌▓██▒▓  ██▒ ▓▒▓█   ▀ .  *        .       
echo  .   *.   '     .  *     ▒██  ▀█▄  ▓██░ ██▓▒▒██▀▀██░▓██ ░▄█ ▒▒██░  ██▒░██   █▌▒██▒▒ ▓██░ ▒░▒███     .    .    '        
echo      .    .    '         ░██▄▄▄▄██ ▒██▄█▓▒ ▒░▓█ ░██ ▒██▀▀█▄  ▒██   ██░░▓█▄   ▌░██░░ ▓██▓ ░ ▒▓█  ▄  .   *.   ' '   .  *  
echo  .   *.   ' '   .  *      ▓█   ▓██▒▒██▒ ░  ░░▓█▒░██▓░██▓ ▒██▒░ ████▓▒░░▒████▓ ░██░  ▒██▒ ░ ░▒████▒   ..   ' '       .  *
echo      ..   ' '       .  *  ▒▒   ▓▒█░▒▓▒░ ░  ░ ▒ ░░▒░▒░ ▒▓ ░▒▓░░ ▒░▒░▒░  ▒▒▓  ▒ ░▓    ▒ ░░   ░░ ▒░ ░ .   '     ' '  .  *
echo   *.   '     ' '  .  *    ▒   ▒▒ ░░▒ ░      ▒ ░▒░ ░  ░▒ ░ ▒░  ░ ▒ ▒░  ░ ▒  ▒  ▒ ░    ░     ░ ░  ░ .   *.   ' '
echo  *  .'. *      '       .  *░   ▒   ░░        ░  ░░ ░  ░░   ░ ░ ░ ░ ▒   ░ ░  ░  ▒ ░  ░         ░         .   *.   ' '
echo  .   *.   ' '    *.            ░  ░          ░  ░  ░   ░         ░ ░     ░     ░              ░  ░    .   *.   ' '
echo  *   .   .'    * ,      .       .  ,     *    .  *        *  .'.   '   .       *  .'. *          .   * .'.       *  .'. *          .   *
color 3
color 4
echo  *   .   .'    * ,      .       .  ,     *    .  *        *  .'.   '   .       *  .'. *          .   * .'.       *  .'. *          .   *
color 4
color 5
echo   .     *     .'       *          .   *     .  ,     *    .  *        *  .'.
color 5
color 6
echo   '     .     .   *        *  .'. *          .   *   '   .       *  .'. *          .   *
color 6
color 7
echo       .   ' '        .    .    '   .       '      *  ,      .       .  ,     * '      *  ,      .       .  ,     * .       .  ,     *
color 7
color 8
echo .  *        ,   *               '      *  ,      .       .  ,     * .       .  ,     *
color 8
color 9
echo        '      *  ,      .       .  ,     *                         . .       .  ,     *
color 9
color 1
echo          *          .   *   '      *  ,      .       .  ,     *
color 1
color 2
echo   *    .  *       .   ,          *     .    .    '   . ,      .       .  ,     *    .  *        *  .'. .       .  ,     *
color 2
color 3
echo           .       . .        *    .  *        *  .'.               '      *  ,      .       .  ,     *
color 3
color 4
echo  *   .   .'    * ,      .       .  ,     *    .  *        *  .'. .       .  ,     *
color 4
color 5
echo   .     *     .' *          .   * * ,      .       .  ,     *    .  *        *  .'.
color 5
color 6
echo   '     .     .  *        *  .'. *          .   * * ,      .       .  ,     *    .  *        *  .'. .       .  ,     *
color 6
color 7
echo       .   ' '        .    .    '   . .       .  ,     * .       .  ,     *
color 7
color 8
echo .  *        ,   *               '      *  ,      .       .  ,     *
color 8
color 9
echo                              .
color 9
color 1
echo          *          .   *
color 1
color 2
cls
color 3
echo                                                    %S_RED%Created By %S_GREEN%Lucky
timeout 5 >nul
cls
MODE CON COLS=50 LINES=3
chcp 65001 >nul
echo [40;34m[Loading Utility] --^> Please Wait...
timeout 1 >nul
cls
echo [40;35m[Loading Utility] --^> Please Wait...
timeout 1 >nul
cls
echo [40;34m[Loading Utility] --^> Please Wait...
timeout 1 >nul
cls
echo [40;35m[Loading Utility] --^> Please Wait...
timeout 1 >nul
goto :next

 :next
cls
MODE CON COLS=132 LINES=50
chcp 65001 >nul
title Aphrodite Services - %version% 
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d "1" /f >nul
color A
echo.
echo 					     Copyright (C) 2023 Aphrodite Services
pause 4
cls
goto :MainMenu






:MainMenu
cls
chcp 65001 >nul 
:VBSDynamicBuild
SET TempVBSFile=%temp%\~tmpSendKeysTemp.vbs
IF EXIST "%TempVBSFile%" DEL /F /Q "%TempVBSFile%"
ECHO Set WshShell = WScript.CreateObject("WScript.Shell") >>"%TempVBSFile%"
ECHO Wscript.Sleep 1                                    >>"%TempVBSFile%"
ECHO WshShell.SendKeys "{F11}"                            >>"%TempVBSFile%
ECHO Wscript.Sleep 1                                    >>"%TempVBSFile%"
CSCRIPT //nologo "%TempVBSFile%" 					
echo		       [40;35m
echo                     ▄▄▄       ██▓███   ██░ ██  ██▀███   ▒█████  ▓█████▄  ██▓▄▄▄█████▓▓█████    
echo                    ▒████▄    ▓██░  ██▒▓██░ ██▒▓██ ▒ ██▒▒██▒  ██▒▒██▀ ██▌▓██▒▓  ██▒ ▓▒▓█   ▀   
echo                    ▒██  ▀█▄  ▓██░ ██▓▒▒██▀▀██░▓██ ░▄█ ▒▒██░  ██▒░██   █▌▒██▒▒ ▓██░ ▒░▒███      
echo                    ░██▄▄▄▄██ ▒██▄█▓▒ ▒░▓█ ░██ ▒██▀▀█▄  ▒██   ██░░▓█▄   ▌░██░░ ▓██▓ ░ ▒▓█  ▄   
echo                     ▓█   ▓██▒▒██▒ ░  ░░▓█▒░██▓░██▓ ▒██▒░ ████▓▒░░▒████▓ ░██░  ▒██▒ ░ ░▒████▒  
echo                     ▒▒   ▓▒█░▒▓▒░ ░  ░ ▒ ░░▒░▒░ ▒▓ ░▒▓░░ ▒░▒░▒░  ▒▒▓  ▒ ░▓    ▒ ░░   ░░ ▒░ ░  
echo                      ▒   ▒▒ ░░▒ ░      ▒ ░▒░ ░  ░▒ ░ ▒░  ░ ▒ ▒░  ░ ▒  ▒  ▒ ░    ░     ░ ░  ░    
echo                      ░   ▒   ░░        ░  ░░ ░  ░░   ░ ░ ░ ░ ▒   ░ ░  ░  ▒ ░  ░         ░      
echo                          ░  ░          ░  ░  ░   ░         ░ ░     ░     ░              ░  ░   
echo.    
echo.
echo                  [40;35m--^> [40;34mV1[40;37m
echo                  [40;35m--^> [40;34mMade by [40;35mLucky[40;37m
echo                  [40;35m--^> [40;34mWelcome To The Main Menu, [40;35mPlease Select Your Tweak%S_WHITE%
echo.
echo.
echo                  ╔═══════════════════════════════════════╗
echo                  ║ [40;35m[1] Apply shot registration  %S_WHITE%         ║         		            	   	          	 
echo                  ╚═══════════════════════════════════════╝
echo.
echo. 
echo.
set/p action=[34m                 Selection:[35m
if '%action%'=='1' goto ZeroDelay

:ZeroDelay
echo. [40;35m[] [40;34mPress any key to continue
pause >nul
echo. [40;35m[] [40;34mReady?
timeout 1 > nul
echo. [40;35m[] [40;34mStarting in 5
timeout 1 > nul
echo. [40;35m[] [40;34m4
timeout 1 > nul
echo. [40;35m[] [40;34m3
timeout 1 > nul
echo. [40;35m[] [40;34m2
timeout 1 > nul
echo. [40;35m[] [40;34m1
timeout 1 > nul
echo. [40;35m[] [40;34mStarting now
echo. [40;35m[] [40;34mPlease remember your restore point in the case that anything goes wrong!
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f
taskkill F FI IMAGENAME eq SystemSettings.exe
@echo
net stop wuauserv
net stop UsoSvc
@echo
reg add HKLMSOFTWAREPoliciesMicrosoftWindowsWindowsUpdate v DoNotConnectToWindowsUpdateInternetLocations t REG_DWORD d 1 f
@echo
reg add HKLMSOFTWAREPoliciesMicrosoftWindowsWindowsUpdate v SetDisableUXWUAccess t REG_DWORD d 1 f
reg add HKLMSOFTWAREPoliciesMicrosoftWindowsWindowsUpdateAU v NoAutoUpdate t REG_DWORD d 1 f
reg add HKLMSOFTWAREPoliciesMicrosoftWindowsWindowsUpdate v ExcludeWUDriversInQualityUpdate t REG_DWORD d 1 f
@echo
gpupdate force
rd s q CWindowsSoftwareDistribution
md CWindowsSoftwareDistribution
net start wuauserv
net start UsoSvc
@echo off
echo Batch File By GMAN
taskkill F FI IMAGENAME eq SystemSettings.exe
@echo
net stop wuauserv
net stop UsoSvc
@echo
reg add HKLMSOFTWAREPoliciesMicrosoftWindowsWindowsUpdate v DoNotConnectToWindowsUpdateInternetLocations t REG_DWORD d 1 f
@echo
reg add HKLMSOFTWAREPoliciesMicrosoftWindowsWindowsUpdate v SetDisableUXWUAccess t REG_DWORD d 1 f
reg add HKLMSOFTWAREPoliciesMicrosoftWindowsWindowsUpdateAU v NoAutoUpdate t REG_DWORD d 1 f
reg add HKLMSOFTWAREPoliciesMicrosoftWindowsWindowsUpdate v ExcludeWUDriversInQualityUpdate t REG_DWORD d 1 f
@echo
gpupdate force
rd s q CWindowsSoftwareDistribution
md CWindowsSoftwareDistribution
@echo
net start wuauserv
net start UsoSvc
echo.
echo [40;35m[] [40;34mAll Tweaks Were Applied
Pause 3
Start https://discord.gg/UwxPDDuT37
echo. [40;35m[] [40;34mPress any key to exit
exit