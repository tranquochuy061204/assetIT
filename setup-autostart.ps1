# Script dang ky Windows Task Scheduler tu dong chay AssetFlow khi Windows Server khoi dong
$ErrorActionPreference = 'Stop'

Write-Host ">>> Dang cau hinh Docker Service va Windows Task Scheduler cho AssetFlow..." -ForegroundColor Cyan

# 1. Bat Docker Service tu dong
Set-Service -Name "docker" -StartupType Automatic -ErrorAction SilentlyContinue
Set-Service -Name "com.docker.service" -StartupType Automatic -ErrorAction SilentlyContinue

# 2. Dang ky Windows Task Scheduler chay khi khoi dong may (AtStartup)
$scriptDir = $PSScriptRoot
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"Set-Location '$scriptDir'; docker compose up -d`""
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "AssetFlow_AutoStart" -Action $Action -Trigger $Trigger -Principal $Principal -Force | Out-Null

Write-Host ">>> Da dang ky thanh cong Windows Scheduled Task 'AssetFlow_AutoStart'!" -ForegroundColor Green
Write-Host ">>> He thong se tu dong khoi chay moi khi may chu Windows Server khoi dong." -ForegroundColor Green
