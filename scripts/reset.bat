@echo off

:: Check for admin privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
  echo This script requires admin privileges. Please run as administrator.
  exit /b
)

:: Check if firewall rule exists
netsh advfirewall firewall show rule name="Winux" >nul 2>&1
if not errorlevel 1 (
  echo Deleting Firewall rule "Winux"...
  netsh advfirewall firewall delete rule name="Winux" >nul 2>&1
)

:: Forwarding port message
echo Resetting Winux Port Forwarding...

:: Delete all the port forwarding
netsh interface portproxy reset >nul 2>&1

echo Winux Port Forwarding Resetted successfully.
