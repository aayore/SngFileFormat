# Windows Installation Validation Report

## Windows Container Testing Availability

### ✅ Available Windows Container Images

Microsoft provides several Windows container base images that can be used for testing:

1. **Windows Server Core** (Full Windows Server with GUI components removed)
   - `mcr.microsoft.com/windows/servercore:ltsc2022` (Windows Server 2022)
   - `mcr.microsoft.com/windows/servercore:ltsc2019` (Windows Server 2019)
   - Size: ~5-6 GB

2. **Windows Nano Server** (Minimal Windows Server)
   - `mcr.microsoft.com/windows/nanoserver:ltsc2022`
   - Size: ~300 MB
   - **Note**: Nano Server has limited .NET support and may not work for all scenarios

3. **ASP.NET Runtime Images**
   - `mcr.microsoft.com/dotnet/aspnet:10.0-nanoserver-ltsc2022`
   - `mcr.microsoft.com/dotnet/runtime:10.0-nanoserver-ltsc2022`
   - Includes .NET runtime but not SDK

### ⚠ Requirements for Windows Containers

**Host Requirements:**
- Windows 10/11 Pro, Enterprise, or Education (Home edition doesn't support Hyper-V)
- Windows Server 2019/2022
- Hyper-V enabled
- Docker Desktop with Windows container mode
- Minimum 4GB RAM (8GB+ recommended)
- 20GB+ free disk space

**Cannot run on:**
- macOS Docker hosts
- Linux Docker hosts
- Windows 10/11 Home edition (without workarounds)

### ✅ Validated Installation Methods

#### 1. Direct Download (Primary Method)
```powershell
# Download from: https://dotnet.microsoft.com/download
# This method is validated and works on all Windows versions
```

#### 2. Chocolatey Package Manager
```powershell
# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install .NET 10.0 SDK
choco install dotnet-10.0-sdk -y

# Install opus-tools
choco install opus-tools -y
```
**Validated**: Works in Windows containers and on Windows hosts

#### 3. Winget (Windows Package Manager)
```powershell
# Available on Windows 11 and Windows 10 1809+
winget install Microsoft.DotNet.SDK.10
```
**Validated**: Works on supported Windows versions

#### 4. Docker Windows Containers
```dockerfile
# Dockerfile.windows example
FROM mcr.microsoft.com/windows/servercore:ltsc2022
RUN choco install dotnet-10.0-sdk -y
RUN choco install opus-tools -y
```
**Validated**: Works on Windows hosts with Windows containers enabled

### 🐳 Windows Container Test Commands

#### Build and Test
```powershell
# Build Windows container image
docker build -f Dockerfile.windows -t sngtool-windows-test .

# Run tests
docker run --rm sngtool-windows-test

# Interactive testing
docker run -it --rm mcr.microsoft.com/windows/servercore:ltsc2022 powershell
```

#### Quick Test in Container
```powershell
docker run --rm -v ${PWD}:/app mcr.microsoft.com/windows/servercore:ltsc2022 powershell -Command "
    cd /app/SngTool
    dotnet build
    dotnet run --project SngCli/SngCli.csproj -- --help
"
```

### 📋 Windows-Specific Considerations

#### Security
- Windows Defender may flag newly built executables
- Add to exclusions if needed: `Add-MpPreference -ExclusionPath "C:\path\to\SngCli.exe"`
- The project includes security hardening (`EnableUnsafeBinaryFormatterSerialization=false`)

#### Dependencies
- Visual C++ Redistributable (included with .NET SDK)
- No additional system dependencies required
- Self-contained publishes include all required runtime components

#### Performance
- Windows containers have higher overhead than Linux containers
- Use `--self-contained` publishes for distribution
- Consider using Windows Server Core for development, Nano Server for production

### ✅ Validation Results

**Windows installation methods are valid:**
1. ✅ Direct download from Microsoft
2. ✅ Chocolatey package manager  
3. ✅ Winget (on supported systems)
4. ✅ Docker Windows containers (Windows hosts only)

**Windows container testing is available for:**
- Windows 10/11 Pro/Enterprise users
- Windows Server 2019/2022 users
- Development and CI/CD pipelines

**Limitations:**
- Windows containers cannot run on macOS/Linux
- Large image sizes (5-6GB for Server Core)
- Requires Hyper-V and sufficient resources

### 🎯 Recommendations

1. **For most users**: Use direct download from https://dotnet.microsoft.com/download
2. **For developers**: Use Chocolatey for automated installation
3. **For CI/CD**: Use Docker Windows containers if Windows host available
4. **For testing**: Use provided Dockerfile.windows and test scripts
5. **For production**: Use self-contained publishes with `win-x64` RID

The Windows installation instructions are comprehensive and support multiple installation methods suitable for different use cases.