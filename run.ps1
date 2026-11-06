# Cloud Voyage & Inventory Auditing System - Unified Runner (PowerShell)

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "   Cloud Voyage & Inventory Auditing System - Unified Runner" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Environment configuration
if (-not $env:DB_PASSWORD) {
    $env:DB_PASSWORD = "Password123"
    Write-Host "[INFO] Using default DB_PASSWORD: Password123" -ForegroundColor Yellow
}

$rootDir = $PSScriptRoot
$frontendDir = Join-Path $rootDir "frontend"
$backendDir = Join-Path $rootDir "backend"
$staticDir = Join-Path $backendDir "src\main\resources\static"

# 2. Build Frontend
Write-Host "`n[1/3] Building frontend production bundle..." -ForegroundColor Green
Set-Location $frontendDir
cmd.exe /c "npm.cmd run build"

# 3. Copy dist into Spring Boot static resources
Write-Host "`n[2/3] Syncing frontend into Spring Boot static resources..." -ForegroundColor Green
if (-not (Test-Path $staticDir)) {
    New-Item -ItemType Directory -Path $staticDir -Force | Out-Null
}
Copy-Item -Path (Join-Path $frontendDir "dist\*") -Destination $staticDir -Recurse -Force
Write-Host "[OK] Unified package ready!" -ForegroundColor Green

# 4. Launch Spring Boot
Write-Host "`n[3/3] Launching Full-Stack Application..." -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "   Application is starting up!" -ForegroundColor Cyan
Write-Host "   Unified App URL: http://localhost:8080" -ForegroundColor Yellow
Write-Host "   Press Ctrl+C to stop the application." -ForegroundColor Gray
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $backendDir
& ".\mvnw.cmd" spring-boot:run

