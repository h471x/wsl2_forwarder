@echo off

:: Check for admin privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
  echo This script requires admin privileges. Please run as administrator.
  exit /b
)

:: Check port forwarding status and handle empty output
for /f "tokens=*" %%A in ('netsh interface portproxy show all ^| find /v ""') do (
  set "outputFound=1"
  echo %%A
)

if not defined outputFound (
  echo No Port Forwarding Active Right Now
)
