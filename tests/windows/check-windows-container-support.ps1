# PowerShell script to check Windows container support
Write-Host "Windows Container Support Check" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Check OS version
$os = Get-CimInstance -ClassName Win32_OperatingSystem
Write-Host "`n1. Operating System:" -ForegroundColor Yellow
Write-Host "   Name: $($os.Caption)" -ForegroundColor White
Write-Host "   Version: $($os.Version)" -ForegroundColor White
Write-Host "   Build: $($os.BuildNumber)" -ForegroundColor White

# Check edition
$edition = $os.OperatingSystemSKU
$supportedEditions = @(1, 3, 4, 7, 8, 10, 12, 13, 14, 15, 17, 18, 19, 20, 21, 23, 24, 25, 27, 28, 29, 30, 31, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200)

if ($edition -in $supportedEditions) {
    Write-Host "   ✓ Supported edition for containers" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Edition may not support containers" -ForegroundColor Yellow
}

# Check Docker
Write-Host "`n2. Docker Check:" -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker installed: $dockerVersion" -ForegroundColor Green
        
        # Check container mode
        $dockerInfo = docker info 2>&1 | Select-String "OSType"
        if ($dockerInfo -match "windows") {
            Write-Host "   ✓ Windows containers enabled" -ForegroundColor Green
        } elseif ($dockerInfo -match "linux") {
            Write-Host "   ⚠ Linux containers mode" -ForegroundColor Yellow
            Write-Host "   Switch to Windows containers in Docker Desktop" -ForegroundColor White
        }
    }
} catch {
    Write-Host "   ✗ Docker not installed" -ForegroundColor Red
}

# Check Hyper-V
Write-Host "`n3. Hyper-V Check:" -ForegroundColor Yellow
$hyperv = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
if ($hyperv.State -eq "Enabled") {
    Write-Host "   ✓ Hyper-V enabled" -ForegroundColor Green
} else {
    Write-Host "   ✗ Hyper-V not enabled" -ForegroundColor Red
    Write-Host "   Enable via: Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All" -ForegroundColor White
}

# Check system resources
Write-Host "`n4. System Resources:" -ForegroundColor Yellow
$memory = Get-CimInstance -ClassName Win32_ComputerSystem
$disk = Get-PSDrive C

Write-Host "   RAM: $([math]::Round($memory.TotalPhysicalMemory / 1GB, 2)) GB" -ForegroundColor White
Write-Host "   Free disk (C:): $([math]::Round($disk.Free / 1GB, 2)) GB" -ForegroundColor White

if ($memory.TotalPhysicalMemory -ge 4GB) {
    Write-Host "   ✓ Sufficient RAM for containers" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Minimum 4GB RAM recommended" -ForegroundColor Yellow
}

if ($disk.Free -ge 20GB) {
    Write-Host "   ✓ Sufficient disk space" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Minimum 20GB free space recommended" -ForegroundColor Yellow
}

# Summary
Write-Host "`n=================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor White

$canRunContainers = $true
$issues = @()

if (-not ($dockerVersion -and $LASTEXITCODE -eq 0)) {
    $canRunContainers = $false
    $issues += "Docker not installed"
}

if ($hyperv.State -ne "Enabled") {
    $canRunContainers = $false
    $issues += "Hyper-V not enabled"
}

if ($memory.TotalPhysicalMemory -lt 4GB) {
    $issues += "Low RAM (4GB+ recommended)"
}

if ($disk.Free -lt 20GB) {
    $issues += "Low disk space (20GB+ recommended)"
}

if ($canRunContainers) {
    Write-Host "✅ Can run Windows containers!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor White
    Write-Host "1. Ensure Docker Desktop is in Windows container mode" -ForegroundColor Gray
    Write-Host "2. Run: docker build -f Dockerfile.windows -t sngtool-windows-test ." -ForegroundColor Gray
    Write-Host "3. Run: docker run --rm sngtool-windows-test" -ForegroundColor Gray
} else {
    Write-Host "⚠ Cannot run Windows containers" -ForegroundColor Yellow
    Write-Host "`nIssues found:" -ForegroundColor White
    foreach ($issue in $issues) {
        Write-Host "  - $issue" -ForegroundColor Gray
    }
    Write-Host "`nAlternative: Use Linux containers or native Windows installation" -ForegroundColor White
}

Write-Host "`nFor native Windows installation:" -ForegroundColor White
Write-Host "1. Download .NET SDK: https://dotnet.microsoft.com/download" -ForegroundColor Gray
Write-Host "2. Download opus-tools: https://opus-codec.org/downloads/" -ForegroundColor Gray
Write-Host "3. Build project: dotnet build SngTool\SngTool.sln" -ForegroundColor Gray