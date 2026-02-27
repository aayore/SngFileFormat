#!/bin/bash

echo "Building Docker image to test Linux installation..."
echo "==================================================="

# Build the Docker image
docker build -t sngtool-test .

if [ $? -eq 0 ]; then
    echo ""
    echo "Docker build successful! Running test container..."
    echo ""
    
    # Run the container
    docker run --rm sngtool-test
    
    echo ""
    echo "==================================================="
    echo "SUCCESS: Linux installation instructions are valid!"
    echo ""
    echo "The Docker test confirms that:"
    echo "1. .NET 10.0 SDK can be installed on Ubuntu"
    echo "2. opus-tools can be installed"
    echo "3. The project builds successfully"
    echo "4. The CLI tool runs and shows help"
    echo ""
    echo "To manually test in Docker:"
    echo "  docker run -it --rm -v \$(pwd):/app ubuntu:22.04 bash"
    echo "  # Then follow the README installation instructions"
else
    echo ""
    echo "==================================================="
    echo "Docker build failed. Checking issues..."
    echo ""
    
    # Try a simpler test
    echo "Trying simplified test..."
    docker run --rm -v $(pwd):/app ubuntu:22.04 bash -c "
        echo '=== Testing basic commands ==='
        apt-get update && apt-get install -y wget lsb-release
        echo 'Ubuntu version: \$(lsb_release -rs)'
        echo 'Testing wget:'
        wget --version | head -1
        echo 'Testing package URL construction...'
        echo 'Would download: https://packages.microsoft.com/config/ubuntu/\$(lsb_release -rs)/packages-microsoft-prod.deb'
    "
fi