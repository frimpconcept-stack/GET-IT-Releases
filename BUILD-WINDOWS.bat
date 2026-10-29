@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "BUILD_LOG=%~dp0GET-IT-BUILD-LOG.txt"
>"%BUILD_LOG%" echo GET IT! build started %DATE% %TIME%
echo.
echo GET IT! Windows Installer Build
echo Build details will be saved to: "%BUILD_LOG%"
echo.
where node >nul 2>nul
if errorlevel 1 (
  echo ERROR: Node.js is not available on PATH.
  >>"%BUILD_LOG%" echo ERROR: Node.js missing from PATH
  goto :failed
)
where npm >nul 2>nul
if errorlevel 1 (
  echo ERROR: npm is not available on PATH.
  >>"%BUILD_LOG%" echo ERROR: npm missing from PATH
  goto :failed
)
echo [1/5] Checking Node and npm versions...
call node --version >>"%BUILD_LOG%" 2>&1
call npm --version >>"%BUILD_LOG%" 2>&1
echo [2/5] Installing dependencies...
call npm install --no-audit --no-fund >>"%BUILD_LOG%" 2>&1
if errorlevel 1 goto :failed
echo [3/5] Checking backend syntax...
call npm run check >>"%BUILD_LOG%" 2>&1
if errorlevel 1 goto :failed
echo [4/5] Running functional tests (including real local transfers)...
call npm test >>"%BUILD_LOG%" 2>&1
if errorlevel 1 goto :failed
echo [5/5] Provisioning native tools and creating installer...
call npm run package:win >>"%BUILD_LOG%" 2>&1
if errorlevel 1 goto :failed
echo.
echo SUCCESS: Check the release folder for GET-IT-Setup.exe
>>"%BUILD_LOG%" echo Build completed successfully.
pause
exit /b 0
:failed
echo.
echo BUILD FAILED. Details saved in:
echo %BUILD_LOG%
echo.
echo Most recent error messages:
powershell -NoProfile -Command "Get-Content -LiteralPath $env:BUILD_LOG -Tail 65" 2>nul
if errorlevel 1 type "%BUILD_LOG%"
echo.
echo Please send GET-IT-BUILD-LOG.txt so the exact failure can be repaired.
pause
exit /b 1
