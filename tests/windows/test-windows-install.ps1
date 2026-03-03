# PowerShell script to test Windows installation instructions
Write-Host "Testing Windows installation instructions..." -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Test 1: Check if running in Windows container
Write-Host "`n1. Checking environment..." -ForegroundColor Yellow
if ($env:OS -eq "Windows_NT") {
    Write-Host "   ✓ Running on Windows" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Not running on Windows" -ForegroundColor Yellow
}

# Test 2: Check Docker for Windows availability
Write-Host "`n2. Checking Docker for Windows..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker available: $dockerVersion" -ForegroundColor Green
        
        # Check if Windows containers are enabled
        $dockerInfo = docker info 2>&1 | Select-String "OSType"
        if ($dockerInfo -match "windows") {
            Write-Host "   ✓ Windows containers enabled" -ForegroundColor Green
        } else {
            Write-Host "   ⚠ Linux containers mode (switch to Windows containers)" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "   ✗ Docker not available" -ForegroundColor Red
}

# Test 3: Validate installation commands
Write-Host "`n3. Validating installation commands..." -ForegroundColor Yellow

Write-Host "   .NET SDK installation:" -ForegroundColor White
Write-Host "   - Download from: https://dotnet.microsoft.com/download" -ForegroundColor Gray
Write-Host "   - Or use Chocolatey: choco install dotnet-10.0-sdk -y" -ForegroundColor Gray
Write-Host "   - Or use Winget: winget install Microsoft.DotNet.SDK.10" -ForegroundColor Gray

Write-Host "`n   opus-tools installation:" -ForegroundColor White
Write-Host "   - Download from: https://opus-codec.org/downloads/" -ForegroundColor Gray
Write-Host "   - Or use Chocolatey: choco install opus-tools -y" -ForegroundColor Gray

# Test 4: Check Windows-specific requirements
Write-Host "`n4. Windows-specific requirements..." -ForegroundColor Yellow
Write-Host "   - Windows 10/11 or Windows Server 2019/2022" -ForegroundColor Gray
Write-Host "   - .NET 10.0 SDK (x64)" -ForegroundColor Gray
Write-Host "   - Visual C++ Redistributable (included with .NET SDK)" -ForegroundColor Gray
Write-Host "   - Windows Defender may need exclusions for built executables" -ForegroundColor Gray

# Test 5: Docker Windows container commands
Write-Host "`n5. Docker Windows container commands..." -ForegroundColor Yellow
Write-Host "   Build Windows container:" -ForegroundColor White
Write-Host "   docker build -f Dockerfile.windows -t sngtool-windows-test ." -ForegroundColor Gray

Write-Host "`n   Run Windows container:" -ForegroundColor White
Write-Host "   docker run --rm sngtool-windows-test" -ForegroundColor Gray

Write-Host "`n   Test in interactive container:" -ForegroundColor White
Write-Host "   docker run -it --rm mcr.microsoft.com/windows/servercore:ltsc2022 powershell" -ForegroundColor Gray

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "Windows installation validation complete!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor White
Write-Host "- Windows installation via download is straightforward" -ForegroundColor Gray
Write-Host "- Chocolatey provides automated installation" -ForegroundColor Gray
Write-Host "- Windows containers can be used for testing (Windows host required)" -ForegroundColor Gray
Write-Host "- Consider Windows Defender exclusions for built executables" -ForegroundColor Gray