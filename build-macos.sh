#!/bin/bash

echo "Building SngTool for macOS..."

# Detect architecture
DETECTED_ARCH=$(uname -m)
case "$DETECTED_ARCH" in
    arm64)
        DEFAULT_ARCH="arm64"
        ;;
    x86_64)
        DEFAULT_ARCH="x64"
        ;;
    *)
        echo "Warning: Unknown architecture '$DETECTED_ARCH', defaulting to arm64"
        DEFAULT_ARCH="arm64"
        ;;
esac

# Parse command line arguments
BUILD_ARM64=true
BUILD_X64=true

for arg in "$@"; do
    case $arg in
        --arch=*)
            ARCH="${arg#*=}"
            case $ARCH in
                arm64)
                    BUILD_ARM64=true
                    BUILD_X64=false
                    ;;
                x64)
                    BUILD_ARM64=false
                    BUILD_X64=true
                    ;;
                all)
                    BUILD_ARM64=true
                    BUILD_X64=true
                    ;;
                *)
                    echo "Error: Unknown architecture '$ARCH'"
                    echo "Valid options: arm64, x64, all"
                    exit 1
                    ;;
            esac
            ;;
        --help|-h)
            echo "Usage: build-macos.sh [options]"
            echo ""
            echo "Options:"
            echo "  --arch=<type>  Build for specific architecture"
            echo "                 Valid values: arm64, x64, all"
            echo "                 Default: arm64 on Apple Silicon, x64 on Intel"
            echo "  --help, -h     Show this help message"
            exit 0
            ;;
        *)
            echo "Error: Unknown argument '$arg'"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Build for macOS ARM64 (Apple Silicon)
if [ "$BUILD_ARM64" = true ]; then
    echo "Building for macOS ARM64..."
    dotnet publish SngTool/SngCli/SngCli.csproj -c Release --self-contained -r osx-arm64 --output ./SngTool/bin/build/osx-arm64
fi

# Also build for macOS x64 (Intel) for compatibility
if [ "$BUILD_X64" = true ]; then
    echo "Building for macOS x64..."
    dotnet publish SngTool/SngCli/SngCli.csproj -c Release --self-contained -r osx-x64 --output ./SngTool/bin/build/osx-x64
fi

echo "Build complete!"
if [ "$BUILD_ARM64" = true ]; then
    echo "ARM64 build: ./SngTool/bin/build/osx-arm64/SngCli"
fi
if [ "$BUILD_X64" = true ]; then
    echo "x64 build: ./SngTool/bin/build/osx-x64/SngCli"
fi