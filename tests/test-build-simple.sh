#!/bin/bash

echo "Testing .NET build process..."
echo "=============================="

# Try to build locally first
echo "1. Testing local .NET build..."
cd SngTool

if dotnet build -c Debug 2>&1; then
    echo "✓ Local build successful"
else
    echo "✗ Local build failed"
    exit 1
fi

echo ""
echo "2. Testing Windows cross-compilation..."
if dotnet publish SngCli/SngCli.csproj -c Release -r win-x64 --self-contained --output /tmp/sngtool-win-test 2>&1; then
    echo "✓ Windows cross-compilation successful"
    echo "  Build output: /tmp/sngtool-win-test"
    ls -la /tmp/sngtool-win-test/ | head -10
else
    echo "✗ Windows cross-compilation failed"
    exit 1
fi

echo ""
echo "3. Testing Linux cross-compilation..."
if dotnet publish SngCli/SngCli.csproj -c Release -r linux-x64 --self-contained --output /tmp/sngtool-linux-test 2>&1; then
    echo "✓ Linux cross-compilation successful"
    echo "  Build output: /tmp/sngtool-linux-test"
    ls -la /tmp/sngtool-linux-test/ | head -10
else
    echo "✗ Linux cross-compilation failed"
    exit 1
fi

echo ""
echo "=============================="
echo "Build tests PASSED! 🎉"
echo ""
echo "The project successfully builds for:"
echo "- Local development (Debug)"
echo "- Windows (win-x64, self-contained)"
echo "- Linux (linux-x64, self-contained)"
echo ""
echo "Note: Windows containers cannot run on macOS, but the .NET code"
echo "can be cross-compiled for Windows targets from macOS/Linux."