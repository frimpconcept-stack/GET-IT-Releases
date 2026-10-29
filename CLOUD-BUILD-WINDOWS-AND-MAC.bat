@echo off
setlocal EnableExtensions DisableDelayedExpansion
cd /d "%~dp0"
title GET IT! - Windows and Mac cloud builder

echo.
echo =========================================================
echo  GET IT! - BUILD WINDOWS EXE AND MAC DMG USING GITHUB
 echo =========================================================
echo.
echo The actual Mac build happens on GitHub's Mac computers.
echo The project will be uploaded to a PRIVATE repository with
 echo your approval. This script requires Git and GitHub CLI.
echo.
where git >nul 2>&1
if errorlevel 1 (
 echo [ERROR] Git for Windows is required: https://git-scm.com/downloads/win
 goto :failed
)
where gh >nul 2>&1
if errorlevel 1 (
 echo [ERROR] GitHub CLI is required: https://cli.github.com/
 goto :failed
)
gh auth status >nul 2>&1
if errorlevel 1 (
 echo.
 echo You are not signed in to GitHub CLI.
 echo In this window run: gh auth login
 echo Then rerun this BAT file.
 goto :failed
)
if not exist ".github\workflows\build-installers.yml" (
 echo [ERROR] GitHub Actions workflow is missing from this project folder.
 goto :failed
)

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
 echo Initializing a local Git repository...
 git init -b main
 if errorlevel 1 goto :failed
)

echo.
echo Local repository: %CD%
git remote get-url origin >nul 2>&1
if errorlevel 1 (
 echo.
 echo No GitHub repository is connected yet.
 echo A new PRIVATE repository will be created and project files
 echo uploaded to your GitHub account. Review files first.
 choice /c YN /m "Create the private repo and upload GET IT! source"
 if errorlevel 2 goto :cancelled
 git add -A
 if errorlevel 1 goto :failed
 git diff --cached --quiet
 if errorlevel 1 (
  git commit -m "Configure GET IT! cloud installers"
  if errorlevel 1 (
   echo.
   echo [ERROR] Git commit failed. Set your Git identity first:
   echo   git config --global user.name "Your Name"
   echo   git config --global user.email "you@example.com"
   goto :failed
  )
 )
 echo.
 echo GitHub CLI may ask you to confirm the repository name.
 gh repo create --private --source=. --remote=origin --push
 if errorlevel 1 goto :failed
) else (
 echo.
 echo Existing GitHub repository:
 git remote get-url origin
 echo The script will commit and push your local project changes.
 choice /c YN /m "Upload these project files to this existing repository"
 if errorlevel 2 goto :cancelled
 git add -A
 if errorlevel 1 goto :failed
 git diff --cached --quiet
 if errorlevel 1 (
  git commit -m "Update GET IT! cloud installers"
  if errorlevel 1 goto :failed
 )
 git push -u origin HEAD
 if errorlevel 1 goto :failed
)

echo.
echo Select which installers to build:
echo   A = Windows EXE + Mac Intel DMG + Mac Apple Silicon DMG
echo   M = Mac Intel and Apple Silicon only
echo   W = Windows EXE only
choice /c AMW /m "Build"
if errorlevel 3 goto :windows
if errorlevel 2 goto :mac
set "TARGET=all"
goto :launch
:mac
set "TARGET=mac"
goto :launch
:windows
set "TARGET=windows"
:launch
set "BRANCH="
for /f "usebackq delims=" %%B in (`git branch --show-current`) do set "BRANCH=%%B"
if not defined BRANCH (
 echo [ERROR] Could not detect the current Git branch.
 goto :failed
)
echo.
echo Requesting cloud build: %TARGET% on branch %BRANCH%
gh workflow run build-installers.yml --ref "%BRANCH%" -f target="%TARGET%"
if errorlevel 1 (
 echo.
 echo [ERROR] GitHub may not have recognized this newly pushed workflow yet.
 echo Go to your repository's Actions tab and select Build GET IT! installers.
 goto :failed
)
echo.
echo [OK] GitHub accepted your build request.
echo Go to Actions, open the newest GET IT! workflow run, and
 echo download the finished installers under Artifacts.
echo Mac Intel: GET-IT-macOS-Intel
echo Mac Apple Silicon: GET-IT-macOS-Apple-Silicon
echo Windows: GET-IT-Windows-x64
echo.
choice /c YN /m "Open your GitHub repository now"
if errorlevel 2 goto :done
set "REPO_SLUG="
for /f "usebackq delims=" %%R in (`gh repo view --json nameWithOwner --jq .nameWithOwner`) do set "REPO_SLUG=%%R"
if defined REPO_SLUG (
 start "" "https://github.com/%REPO_SLUG%/actions/workflows/build-installers.yml"
) else (
 gh repo view --web
)
:done
echo.
echo IMPORTANT: Mac installer is unsigned and may require manual
 echo trust approval. Bundled Mac optional engines are not yet included.
pause
exit /b 0
:cancelled
echo No upload or build was started at this step.
pause
exit /b 0
:failed
echo.
echo No successful cloud build was confirmed.
echo See BUILD-WINDOWS-AND-MAC-FROM-WINDOWS.md for manual instructions.
pause
exit /b 1
