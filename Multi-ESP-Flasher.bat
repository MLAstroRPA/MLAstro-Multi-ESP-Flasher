@echo off
chcp 65001 >nul
setlocal
title Multi-ESP-Flasher
cd /d "%~dp0"

where py >nul 2>nul
if %errorlevel%==0 goto :have_py

where python >nul 2>nul
if %errorlevel%==0 goto :have_python

goto :no_python

:have_py
set "PYEXE=py -3"
goto :verify

:have_python
set "PYEXE=python"
goto :verify

:verify
%PYEXE% -c "import sys; raise SystemExit(0 if sys.version_info.major==3 else 1)" >nul 2>nul
if errorlevel 1 goto :bad_python
goto :run

:run
%PYEXE% "Multi-ESP-Flasher.py"
set "RC=%ERRORLEVEL%"
exit /b %RC%

:no_python
echo.
echo ============================================================
echo  Multi-ESP-Flasher
echo  Python 3 was NOT found on this machine.
echo  This tool needs Python 3 to run.
echo ============================================================
echo.
set /p ANS=Install Python 3 now? (y/n):
if /i "%ANS%"=="y" goto :install_python
echo.
echo You chose not to install Python. Closing window.
timeout /t 6 /nobreak >nul
exit /b 1

:install_python
where winget >nul 2>nul
if %errorlevel%==0 goto :install_winget
echo Opening the official Python download page in your browser...
start "" "https://www.python.org/downloads/"
echo.
echo After installing Python 3, run MLAstro-Multi-ESP-Flasher.bat again.
timeout /t 6 /nobreak >nul
exit /b 1

:install_winget
echo Installing Python 3 via winget (this may take a few minutes)...
winget install --id Python.Python.3.12 -e --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo.
    echo winget install failed. Please install Python 3 manually from:
    echo https://www.python.org/downloads/
    timeout /t 6 /nobreak >nul
    exit /b 1
)
echo.
echo Python 3 installed. Please run MLAstro-Multi-ESP-Flasher.bat again.
timeout /t 6 /nobreak >nul
exit /b 1

:bad_python
echo.
echo The detected Python is not version 3.
echo Please install Python 3 from https://www.python.org/downloads/
echo and run this tool again.
timeout /t 6 /nobreak >nul
exit /b 1
