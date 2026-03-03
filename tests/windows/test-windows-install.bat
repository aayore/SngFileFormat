@echo off
echo Testing Windows installation instructions...
echo =============================================

echo.
echo 1. Checking environment...
if "%OS%"=="Windows_NT" (
    echo    ✓ Running on Windows
) else (
    echo    ⚠ Not running on Windows
)

echo.
echo 2. Checking Docker...
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✓ Docker available
    docker --version
) else (
    echo    ✗ Docker not available
)

echo.
echo 3. Installation methods:
echo    Method 1: Download installer
echo        https://dotnet.microsoft.com/download
echo.
echo    Method 2: Chocolatey (package manager)
echo        choco install dotnet-10.0-sdk -y
echo        choco install opus-tools -y
echo.
echo    Method 3: Winget (Windows Package Manager)
echo        winget install Microsoft.DotNet.SDK.10
echo.
echo    Method 4: Docker Windows container
echo        docker build -f Dockerfile.windows -t sngtool-windows-test .
echo        docker run --rm sngtool-windows-test

echo.
echo 4. Windows-specific notes:
echo    - Use win-x64 runtime identifier
echo    - Windows Defender may flag executables initially
echo    - Add to exclusions if needed
echo    - Test with: SngCli --version

echo.
echo =============================================
echo Windows installation validation complete!
echo.
pause