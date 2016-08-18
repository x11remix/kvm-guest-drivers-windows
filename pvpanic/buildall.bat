@echo off

setlocal

set _MAJORVERSION_=%_BUILD_MAJOR_VERSION_%
set _MINORVERSION_=%_BUILD_MINOR_VERSION_%
set _NT_TARGET_MIN=%_RHEL_RELEASE_VERSION_%

for %%O in (Vista Win7 Win8 Win10) do for %%P in (Win32 x64) do call :build_driver %%O %%P

endlocal

goto :eof

:set_os_and_platform
if "%1"=="Vista" set OS=wlh
if "%1"=="Wlh" set OS=wlh
if "%1"=="Win7" set OS=win7
if "%1"=="Win8" set OS=win8
if "%1"=="Win10" set OS=win10
if "%2"=="Win32" set PLAT=x86
if "%2"=="x64" set PLAT=amd64
goto :eof

:set_out_filename
call :set_os_and_platform %1 %2
set OUT_FILENAME=buildfre_%OS%_%PLAT%.log
goto :eof

:fix_wdfcoinstaller_name
call :set_os_and_platform %1 %2
pushd Install\%OS%\%PLAT%\
for %%V in (01009 01011) do if exist WdfCoinstaller%%V.dll rename WdfCoinstaller%%V.dll WdfCoInstaller%%V.dll
popd
goto :eof

:build_driver
call :set_out_filename %1 %2
call ..\tools\callVisualStudio.bat 14 pvpanic.sln /Rebuild "%1 Release|%2" /Out %OUT_FILENAME%
call :fix_wdfcoinstaller_name %1 %2
goto :eof
