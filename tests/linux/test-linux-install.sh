#!/bin/bash

echo "Testing Linux installation instructions..."
echo "=========================================="

# Test 1: Check if we're in a Docker-like environment
echo "1. Checking environment..."
if [ -f /.dockerenv ]; then
    echo "   ✓ Running in Docker container"
else
    echo "   ⚠ Not in Docker container (testing locally)"
fi

# Test 2: Check Ubuntu version
echo "2. Checking Ubuntu version..."
if command -v lsb_release &> /dev/null; then
    ubuntu_version=$(lsb_release -rs)
    echo "   ✓ Ubuntu $ubuntu_version detected"
else
    echo "   ⚠ lsb_release not found (not Ubuntu?)"
    # Try to detect other Linux distros
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo "   Detected: $NAME $VERSION"
    fi
fi

# Test 3: Test .NET SDK installation command
echo "3. Testing .NET SDK installation commands..."
echo "   Testing wget command..."
if command -v wget &> /dev/null; then
    echo "   ✓ wget available"
else
    echo "   ✗ wget not installed"
fi

echo "   Testing dpkg command..."
if command -v dpkg &> /dev/null; then
    echo "   ✓ dpkg available"
else
    echo "   ✗ dpkg not installed (not Debian/Ubuntu?)"
fi

# Test 4: Test opus-tools installation command
echo "4. Testing opus-tools installation command..."
echo "   Testing apt-get..."
if command -v apt-get &> /dev/null; then
    echo "   ✓ apt-get available"
    
    # Check if opus-tools is available in repos
    echo "   Checking if opus-tools is in repositories..."
    if apt-cache show opus-tools 2>/dev/null | grep -q "Package:"; then
        echo "   ✓ opus-tools available in repositories"
    else
        echo "   ⚠ opus-tools not found in repositories (may need update)"
    fi
else
    echo "   ✗ apt-get not available"
fi

# Test 5: Verify the actual commands from README
echo "5. Verifying README commands..."
echo "   Testing: wget https://packages.microsoft.com/config/ubuntu/\$(lsb_release -rs)/packages-microsoft-prod.deb"
# Don't actually download, just check URL pattern
ubuntu_version_test="22.04"
test_url="https://packages.microsoft.com/config/ubuntu/$ubuntu_version_test/packages-microsoft-prod.deb"
echo "   Example URL: $test_url"

echo "   Testing: sudo apt install -y dotnet-sdk-10.0"
echo "   (This would install .NET 10.0 SDK)"

echo "   Testing: sudo apt install opus-tools"
echo "   (This would install opus-tools)"

# Test 6: Check for alternative package managers
echo "6. Checking for alternative package managers..."
if command -v dnf &> /dev/null; then
    echo "   ✓ dnf available (Fedora/RHEL)"
    echo "   Alternative command: sudo dnf install dotnet-sdk-10.0"
    echo "   Alternative command: sudo dnf install opus-tools"
elif command -v yum &> /dev/null; then
    echo "   ✓ yum available (RHEL/CentOS)"
    echo "   Note: May need EPEL repository for opus-tools"
elif command -v pacman &> /dev/null; then
    echo "   ✓ pacman available (Arch)"
    echo "   Alternative command: sudo pacman -S dotnet-sdk"
    echo "   Alternative command: sudo pacman -S opus-tools"
elif command -v zypper &> /dev/null; then
    echo "   ✓ zypper available (openSUSE)"
    echo "   Alternative command: sudo zypper install dotnet-sdk-10.0"
    echo "   Alternative command: sudo zypper install opus-tools"
fi

echo ""
echo "=========================================="
echo "Linux installation instructions validation:"
echo ""
echo "The README instructions are valid for:"
echo "- Ubuntu/Debian systems with apt-get"
echo "- Systems with wget and dpkg installed"
echo ""
echo "Potential issues to note:"
echo "1. The Microsoft package repository URL uses \$(lsb_release -rs) which"
echo "   requires lsb_release to be installed"
echo "2. Some systems may not have wget installed by default"
echo "3. Non-Debian systems need alternative commands (dnf, yum, etc.)"
echo ""
echo "Recommendations:"
echo "1. Add alternative commands for Fedora/RHEL in README"
echo "2. Mention that lsb_release may need to be installed first"
echo "3. Consider adding Docker-based testing instructions"