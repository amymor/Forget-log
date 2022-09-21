@echo off & cd /d "%~dp0"
setlocal & set runState=user
whoami /groups | findstr /b /c:"Mandatory Label\High Mandatory Level" > nul && set runState=administrator
whoami /groups | findstr /b /c:"Mandatory Label\System Mandatory Level" > nul && set runState=TISYSTEM
echo [42m Running in state: "%runState%" [0m
if "%runState%"=="TISYSTEM" (goto gotTISYSTEM) else (nsudo -U:T -P:E -UseCurrentConsole "%~0" %* && exit /b)
:gotTISYSTEM
echo [42m Running as TtustesInstaller.[0m
echo [33m Auto-find and Disable all WINEVT [0m
echo.
echo [33m find all WINEVT and set Enabled to 0[0m
for /f "usebackq tokens=1*" %%a in (`reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT" /s /f "Enabled"^| findstr "HKEY"`) do reg add "%%a %%b" /v "Enabled" /t REG_DWORD /d 0 /f
echo.
pause
exit
