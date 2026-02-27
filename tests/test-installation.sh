#!/bin/bash

echo "Testing SngTool installation..."
echo "================================"

# Check .NET installation
echo "1. Checking .NET SDK..."
if command -v dotnet &> /dev/null; then
    dotnet_version=$(dotnet --version)
    echo "   ✓ .NET SDK found: $dotnet_version"
    
    # Check if it's .NET 10.0 or later
    if [[ $dotnet_version == 10.* ]]; then
        echo "   ✓ .NET 10.0+ detected"
    else
        echo "   ⚠ .NET version $dotnet_version found (10.0+ recommended)"
    fi
else
    echo "   ✗ .NET SDK not found. Please install .NET 10.0 SDK"
    exit 1
fi

# Check opusenc installation (optional)
echo "2. Checking opusenc (optional)..."
if command -v opusenc &> /dev/null; then
    echo "   ✓ opusenc found"
else
    echo "   ⚠ opusenc not found (optional for Opus encoding)"
    echo "   Install with: brew install opus-tools (macOS) or apt install opus-tools (Linux)"
fi

# Check if we're in the right directory
echo "3. Checking project structure..."
if [ -f "SngTool/SngTool.sln" ]; then
    echo "   ✓ Solution file found"
else
    echo "   ✗ Not in SngFileFormat directory or solution file missing"
    echo "   Make sure you're in the SngFileFormat directory"
    exit 1
fi

# Try to build the project
echo "4. Building project..."
cd SngTool
if dotnet build -c Debug 2>&1 | tee build.log; then
    echo "   ✓ Build successful"
    
    # Check for warnings
    warning_count=$(grep -c "warning" build.log || true)
    if [ "$warning_count" -gt 0 ]; then
        echo "   ⚠ Build completed with $warning_count warning(s)"
    fi
else
    echo "   ✗ Build failed. Check build.log for details"
    exit 1
fi

# Test the CLI help
echo "5. Testing CLI tool..."
if dotnet run --project SngCli/SngCli.csproj -- --help 2>&1 | grep -q "Usage:"; then
    echo "   ✓ CLI tool works"
else
    echo "   ✗ CLI tool failed to run"
    exit 1
fi

echo ""
echo "================================"
echo "Installation test PASSED! 🎉"
echo ""
echo "Next steps:"
echo "1. Run './build-macos.sh' to create standalone executables"
echo "2. Try encoding a test folder:"
echo "   mkdir -p test_song/{audio,images}"
echo "   SngCli encode --in ./test_song --out ./output --verbose"
echo "3. Check the README.md for more examples and documentation"
echo ""
echo "For help: SngCli --help"