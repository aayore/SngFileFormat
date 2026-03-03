#!/bin/bash

echo "Building SngTool for macOS..."

# Build for macOS ARM64 (Apple Silicon)
echo "Building for macOS ARM64..."
dotnet publish SngCli/SngCli.csproj -c Release --self-contained -r osx-arm64 --output ./bin/build/osx-arm64

# Also build for macOS x64 (Intel) for compatibility
echo "Building for macOS x64..."
dotnet publish SngCli/SngCli.csproj -c Release --self-contained -r osx-x64 --output ./bin/build/osx-x64

echo "Build complete!"
echo "ARM64 build: ./bin/build/osx-arm64/SngCli"
echo "x64 build: ./bin/build/osx-x64/SngCli"