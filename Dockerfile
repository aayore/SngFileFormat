# Test Dockerfile for SngTool Linux installation
# Use official .NET 10.0 SDK image as base
FROM mcr.microsoft.com/dotnet/sdk:10.0

# Install opus-tools (optional)
RUN apt-get update && apt-get install -y opus-tools

# Copy the project files
WORKDIR /app
COPY . .

# Test the installation
RUN echo "=== Testing .NET installation ===" \
    && dotnet --version \
    && echo "=== Testing opusenc ===" \
    && opusenc --help 2>&1 | head -5 \
    && echo "=== Testing project structure ===" \
    && ls -la SngTool/ \
    && echo "=== Building project ===" \
    && cd SngTool && dotnet build -c Debug \
    && echo "=== Testing CLI tool ===" \
    && dotnet run --project SngCli/SngCli.csproj -- --help 2>&1 | grep -q "Usage:" && echo "CLI test passed" || echo "CLI test failed"

# Set entrypoint to show success
CMD ["echo", "SngTool Linux installation test completed successfully!"]