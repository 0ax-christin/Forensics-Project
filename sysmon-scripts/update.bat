@echo off

copy /y "\\WINSERVER2016\SYSVOL\project.forensics.com\Sysmon\sysmonconfig-export.xml" "C:\Windows\" sysmon64 -c C:\Windows\sysmonconfig-export.xml

:: Variables
set FileServer=WINSERVER2016.project.forensics.com
set SysmonSharePath=SYSVOL\project.forensics.com\Sysmon
set SysmonConfig=sysmonconfig-export.xml
set SysmonExe=Sysmon64.exe
:: CHeck running as admin
net.exe session 1>NUL 2>NUL || ( echo This script requires elevated rights. & exit /b 1 )

sc query "Sysmon64" | find "RUNNING"
if "%ERRORLEVEL%" EQU "0" (
    goto StartSysmon
) else (
    goto UpdateSysmon
)

:StartSysmon
net start Sysmon64
if %ERRORLEVEL% GTR 0 (
    goto InstallSysmon
) else (
    goto UpdateSysmon
)

:UpdateSysmon
"\\%FileServer%\%SysmonSharePath%\%SysmonExe%" -c "\\%FileServer%\%SysmonSharePath%\%SysmonConfig%"
if %ERRORLEVEL% GTR 0 (
    echo "An Error occured while installing sysmon." & exit /b 1
) else (
    exit /b 0
)

:InstallSysmon
"\\%FileServer%\%SysmonSharePath%\%SysmonExe%" -accepteula -i "\\%FileServer%\%SysmonSharePath%\%SysmonConfig%"
if %ERRORLEVEL% GTR 0 (
    echo "An Error occured while install the SysMon." & exit /b 1
) else ( 
    exit /b 0 
)

exit /b 0