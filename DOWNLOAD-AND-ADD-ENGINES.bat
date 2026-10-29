@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "LOG=%~dp0GET-IT-ENGINE-INSTALL-LOG.txt"
>"%LOG%" echo GET IT! optional Windows engine setup started %DATE% %TIME%
echo.
echo GET IT! - Download and Add aria2, gallery-dl and Streamlink
echo Download output and errors are written to:
echo "%LOG%"
echo.
where node >nul 2>nul
if errorlevel 1 (
  echo ERROR: Node.js is not installed or not on PATH.
  >>"%LOG%" echo ERROR: Node.js unavailable
  goto :failed
)
where npm >nul 2>nul
if errorlevel 1 (
  echo ERROR: npm is not installed or not on PATH.
  >>"%LOG%" echo ERROR: npm unavailable
  goto :failed
)
echo [1/2] Installing project dependency packages...
call npm install --no-audit --no-fund >>"%LOG%" 2>&1
if errorlevel 1 goto :failed
echo [2/2] Downloading, checking SHA-256 and preparing engines...
call node scripts\provision-optional.mjs win32 x64 >>"%LOG%" 2>&1
if errorlevel 1 goto :failed
if not exist "vendor\win32-x64\aria2\aria2c.exe" goto :failed
if not exist "vendor\win32-x64\gallery\gallery-dl.exe" goto :failed
if not exist "vendor\win32-x64\streamlink\bin\streamlink.exe" if not exist "vendor\win32-x64\streamlink\streamlink.exe" goto :failed
echo.
echo SUCCESS - All three portable engines are present and passed version probes.
echo They have been added to vendor\win32-x64 and will be bundled by BUILD-WINDOWS.bat.
echo To update the installed GET IT!, run BUILD-WINDOWS.bat and install the generated EXE.
>>"%LOG%" echo SUCCESS: All 3 engines ready.
pause
exit /b 0
:failed
echo.
echo ENGINE INSTALL FAILED. No successful installation is claimed.
echo Check this log:
echo "%LOG%"
powershell -NoProfile -Command "Get-Content -LiteralPath $env:LOG -Tail 35" 2>nul
pause
exit /b 1
