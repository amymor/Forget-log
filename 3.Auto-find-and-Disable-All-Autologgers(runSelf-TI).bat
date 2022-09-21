@echo off & cd /d "%~dp0"
setlocal & set runState=user
whoami /groups | findstr /b /c:"Mandatory Label\High Mandatory Level" > nul && set runState=administrator
whoami /groups | findstr /b /c:"Mandatory Label\System Mandatory Level" > nul && set runState=TISYSTEM
echo [42m Running in state: "%runState%" [0m
if "%runState%"=="TISYSTEM" (goto gotTISYSTEM) else (nsudo -U:T -P:E -UseCurrentConsole "%~0" %* && exit /b)
:gotTISYSTEM
echo [42m Running as TtustesInstaller.[0m
echo [33m Auto-find and Disable all WMI\AutoLogger [0m
echo.
echo [33m find all Auto-Loggers and set Enabled to 0[0m
for /f "usebackq tokens=1*" %%a in (`reg query "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" /s /f "Enabled"^| findstr "HKEY"`) do reg add "%%a %%b" /v "Enabled" /t REG_DWORD /d 0 /f
echo.
echo.
echo [33m find all Auto-Loggers and set Start to 0[0m
for /f "usebackq tokens=1*" %%a in (`reg query "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" /s /f "Start"^| findstr "HKEY"`) do reg add "%%a %%b" /v "Start" /t REG_DWORD /d 0 /f
echo.
echo [33m change back EventLog-System to 1 to keep working enable/disable Ethernet(lan) adapter [0m
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-System" /v "Start" /t REG_DWORD /d "1" /f
echo.
pause
exit
