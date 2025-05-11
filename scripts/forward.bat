@echo off

:: Check for admin privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
  echo This script requires admin privileges. Please run as administrator.
  exit /b
)

:: Enables runtime variable expansion
setlocal enabledelayedexpansion

:: List of common ports used during CTFs
set ports=22 80 88 111 445 1337 1080 2049 3000 3001 3390 4444 44055 5000 5445 6047 7474 7687 8012 8080 9050 9999

:: Check if firewall rule exists
netsh advfirewall firewall show rule name="Winux" >nul 2>&1
if errorlevel 1 (
  echo Creating Firewall rule "Winux"...
  netsh advfirewall firewall add rule name="Winux" dir=in action=allow protocol=ANY >nul 2>&1
)

:: Dynamically assign the WSL IP
for /f "tokens=2 delims= " %%A in ('wsl ip addr show eth0 ^| findstr "inet "') do (
  for /f "tokens=1 delims=/" %%B in ("%%A") do (
    set "wslip=%%B"
    goto :forward_ports
  )
)


:: Loop through each port and create port forwarding rules
:forward_ports
echo.
echo Forwarding Winux Network port to Windows...
echo.

for %%p in (%ports%) do (
  set port=%%p
  echo|set /p="wsl:!port! <--> windows:!port!"
  netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=!port! connectaddress=%wslip% connectport=!port!
)

echo.
echo Winux Network Forwarded successfully.
