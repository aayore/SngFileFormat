# SNG File Format

`.sng` is a simple and generic binary container format that groups a list of files and metadata into a single file.

This repository includes several components: a reference tool for converting SNG files to and from the designated format, the file specification, a registry of frequently used metadata keys, and a registry of file names.

## Fork Information

This repository was forked from the upstream with the explicit purpose of enabling macOS support and cross-platform compatibility.

**Important Notes:**
- AI was used to create Dockerfiles and tests for Linux and Windows builds
- These automated builds and tests have not been manually verified
- Use with caution in production environments
- Manual testing is recommended before deployment

The following automated test infrastructure was added:
- Docker containers for Linux and Windows builds
- Cross-platform build validation scripts
- Automated test suites for different platforms

# SngCli
The SngCli tool is a basic command line tool that has a couple of operating commands each with their own set of command line flags:

```
Usage: SngCli [command] [options]
Options:
  -h, --help            Show help message
  -v, --version         Display version information
      --verbose         Display more information such as audio encoder output.

encode:
  -o, --out FOLDER      Specify output folder location for SNG files
  -i, --in FOLDER       Specify input folder to search for song folders
  -t, --threads         Set how many songs will be encoded in parallel. Can also be useful to set to 1 when a song has an error along with --verbose.
      --noStatusBar     Disable rendering of the status bar. Can reduce cpu usage.
      --skipExisting    If the song to be encoded already exists as an sng in the output folder skip it
      --skipUnknown     Skip unknown files.By default unknown files are included (All audio and images of supported formats are transcoded)
      --videoExclude    Exclude video files
      --opusEncode      Encode all audio to opus
      --opusBitrate     Set opus encoder bitrate, default: 80
      --jpegEncode      Encode all images to JPEG
      --jpegQuality     JPEG encoding quality, default: 75
      --albumUpscale    Enable upscaling album art, by default images are only shrunk.
      --albumResize     Resize album art to set size. Smaller resolutions load faster in-game, Default size: 512x512
                            Supported Sizes:
                                Nearest - This uses next size below the image size
                                256x256
                                384x384
                                512x512
                                768x768
                                1024x1024
                                1536x1536
                                2048x2048

decode:
  -o, --out FOLDER      Specify output folder location for extracted song folders
  -i, --input FOLDER    Specify input folder to search for SNG files
  -t, --threads         Set how many songs will be encoded in parallel.
      --noStatusBar     Disable rendering of the status bar. Can reduce cpu usage.
```

When encoding this tool can also do audio transcoding to opus, and image transcoding to JPEG. Opus encoding takes a significant amount of time for larger song libraries. The more cpu cores you have, the tool can take advantage of this, and encode multiple songs in parallel speeding up the process significantly.

# Installation

## Automated Test Infrastructure

**Note:** This fork includes automated test infrastructure created with AI assistance. These tests have not been manually verified and should be used with caution:

- **Cross-platform tests**: Located in `tests/` directory
- **Docker containers**: `Dockerfile` (Linux) and `Dockerfile.windows` (Windows)
- **Build validation**: `test-windows-build.sh` and other validation scripts
- **Platform-specific tests**: Organized by platform in subdirectories

## Prerequisites

- **.NET 10.0 SDK** or later
- **opus-tools** (for Opus audio encoding) - optional, only needed if using `--opusEncode` flag

### Installing .NET SDK

#### macOS
```bash
# Using Homebrew (recommended)
brew install dotnet

# Verify installation
dotnet --version
```

#### Windows

##### Method 1: Download installer (recommended)
Download and install from https://dotnet.microsoft.com/download

##### Method 2: Chocolatey (package manager)
```powershell
# Install Chocolatey first (if not already installed)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install .NET 10.0 SDK
choco install dotnet-10.0-sdk -y
```

##### Method 3: Winget (Windows Package Manager)
```powershell
# Install .NET 10.0 SDK
winget install Microsoft.DotNet.SDK.10
```

##### Method 4: Docker Windows container (for testing)
```powershell
# Build Windows container
docker build -f Dockerfile.windows -t sngtool-windows-test .

# Run tests
docker run --rm sngtool-windows-test
```

##### Verify installation
```powershell
dotnet --version
```

#### Linux

##### Ubuntu/Debian (20.04, 22.04, 24.04)
```bash
# First, ensure required tools are installed
sudo apt update
sudo apt install -y wget lsb-release

# Install .NET 10.0 SDK
wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-10.0

# Verify installation
dotnet --version
```

##### Fedora/RHEL (Fedora 38+, RHEL 8+)
```bash
# Install .NET 10.0 SDK
sudo rpm -Uvh https://packages.microsoft.com/config/fedora/$(rpm -E %fedora)/packages-microsoft-prod.rpm
sudo dnf install dotnet-sdk-10.0

# Verify installation
dotnet --version
```

##### Alternative: Install via Snap (all Linux distributions)
```bash
# Install .NET SDK via Snap
sudo snap install dotnet-sdk --classic --channel=10.0

# Or install just the runtime
sudo snap install dotnet-runtime-10.0

# Verify installation
dotnet --version
```

##### Alternative: Manual installation
```bash
# Download the .NET SDK binary
wget https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 10.0

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools

# Verify installation
dotnet --version
```

### Installing opus-tools (optional)

Opus encoding is optional but recommended for smaller file sizes. The tool will fall back to original audio formats if opusenc is not available.

#### macOS
```bash
brew install opus-tools

# Verify installation
opusenc --help
```

#### Windows

##### Method 1: Download installer
Download from https://opus-codec.org/downloads/

##### Method 2: Chocolatey (package manager)
```powershell
choco install opus-tools -y
```

##### Method 3: Manual installation
1. Download opus-tools from https://opus-codec.org/downloads/
2. Extract to a directory (e.g., `C:\Program Files\opus-tools`)
3. Add to PATH environment variable

##### Method 4: Docker Windows container
The Docker Windows image includes opus-tools via Chocolatey.

##### Verify installation
```powershell
opusenc --help
```

#### Linux

##### Ubuntu/Debian
```bash
sudo apt update
sudo apt install opus-tools

# Verify installation
opusenc --help
```

##### Fedora/RHEL
```bash
sudo dnf install opus-tools

# Verify installation
opusenc --help
```

##### Arch Linux
```bash
sudo pacman -S opus-tools

# Verify installation
opusenc --help
```

##### openSUSE
```bash
sudo zypper install opus-tools

# Verify installation
opusenc --help
```

##### If opus-tools is not available in your distribution's repositories:
```bash
# Build from source (requires development tools)
sudo apt install build-essential autoconf automake libtool pkg-config
git clone https://gitlab.xiph.org/xiph/opus-tools.git
cd opus-tools
./autogen.sh
./configure
make
sudo make install

# Verify installation
opusenc --help
```

## Building from Source

### Clone the repository
```bash
git clone https://github.com/yourusername/SngFileFormat.git
cd SngFileFormat
```

### Build the project
```bash
# Build all projects
cd SngTool
dotnet build

# Or build just the CLI tool
dotnet build SngTool.sln

# For development (no self-contained binaries)
dotnet build -c Debug
```

### Using the provided build scripts

#### Root directory script (recommended)
```bash
# From the repository root
chmod +x build-macos.sh
./build-macos.sh

# Executables will be at:
# - ./SngTool/bin/build/osx-arm64/SngCli (Apple Silicon)
# - ./SngTool/bin/build/osx-x64/SngCli (Intel Mac)
```

#### SngTool directory script (alternative)
```bash
# From within SngTool directory
cd SngTool
chmod +x build-macos.sh
./build-macos.sh

# Executables will be at:
# - ./bin/build/osx-arm64/SngCli (Apple Silicon)
# - ./bin/build/osx-x64/SngCli (Intel Mac)
```

### Run the tool
```bash
# Run directly with dotnet (development)
cd SngTool/SngCli
dotnet run -- encode --help
dotnet run -- decode --help

# Or use the built executable
./SngTool/bin/build/osx-arm64/SngCli encode --help
```

### Build standalone executables for distribution
```bash
# macOS ARM64 (Apple Silicon)
dotnet publish SngTool/SngCli/SngCli.csproj -c Release --self-contained -r osx-arm64 --output ./dist/osx-arm64

# macOS x64 (Intel)
dotnet publish SngTool/SngCli/SngCli.csproj -c Release --self-contained -r osx-x64 --output ./dist/osx-x64

# Windows x64
dotnet publish SngTool/SngCli/SngCli.csproj -c Release --self-contained -r win-x64 --output ./dist/win-x64

# Linux x64
dotnet publish SngTool/SngCli/SngCli.csproj -c Release --self-contained -r linux-x64 --output ./dist/linux-x64
```

## Quick Start Examples

### Encode a folder of songs to SNG format
```bash
# Basic encoding (preserves original audio and image formats)
SngCli encode --in ./songs --out ./output

# With Opus encoding and JPEG conversion (recommended for size optimization)
SngCli encode --in ./songs --out ./output --opusEncode --jpegEncode

# With parallel processing (4 threads) and custom bitrate
SngCli encode --in ./songs --out ./output --threads 4 --opusEncode --opusBitrate 96 --jpegEncode --jpegQuality 85

# Skip existing SNG files and resize album art
SngCli encode --in ./songs --out ./output --skipExisting --albumResize 512x512

# Encode with verbose output for debugging
SngCli encode --in ./songs --out ./output --verbose
```

### Decode SNG files back to folders
```bash
# Basic decoding
SngCli decode --in ./sng_files --out ./extracted_songs

# With parallel processing
SngCli decode --in ./sng_files --out ./extracted_songs --threads 4

# Decode with verbose output
SngCli decode --in ./sng_files --out ./extracted_songs --verbose
```

## Platform-Specific Notes

### macOS
- The tool is fully compatible with macOS (both Intel and Apple Silicon)
- Use `osx-arm64` for Apple Silicon (M1/M2/M3) or `osx-x64` for Intel Macs
- Homebrew installation of `opus-tools` is recommended for Opus encoding support
- The project includes platform-specific handling for executable detection

### Windows
- Use `win-x64` runtime identifier
- The tool includes security hardening against unsafe serialization and encoding
- Windows Defender may flag the executable initially - add it to exclusions if needed
- Multiple installation methods available:
  - Direct download from Microsoft
  - Chocolatey package manager
  - Winget (Windows Package Manager)
  - Docker Windows containers (for testing)
- Windows containers require Windows host with Windows containers enabled

### Linux
- Use `linux-x64` runtime identifier
- Tested on Ubuntu, Fedora, Arch, and other major distributions
- May require additional dependencies for audio/video processing:
  - Ubuntu/Debian: `sudo apt install libasound2 libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good`
  - Fedora/RHEL: `sudo dnf install alsa-lib gstreamer1 gstreamer1-plugins-base`
  - For video processing, GStreamer plugins may be required

## Troubleshooting

### Common Issues

**"Could not find opusenc" error**
- Install opus-tools as shown in the prerequisites section
- Or run without `--opusEncode` flag to use original audio formats

**"Permission denied" when running executable**
```bash
# Make the executable executable
chmod +x SngCli

# Or run with dotnet
dotnet SngTool/SngCli/SngCli.dll encode --help
```

**Build errors related to .NET version**
- Ensure you have .NET 10.0 SDK installed: `dotnet --version`
- Update the SDK if needed: `dotnet update`

**"System.IO.FileNotFoundException" when running**
- Make sure you're in the correct directory
- Try building the project first: `dotnet build`

**Linux-specific issues**

**"error while loading shared libraries" on Linux**
- Install required system dependencies:
  ```bash
  # Ubuntu/Debian
  sudo apt install libc6 libgcc1 libstdc++6 zlib1g
  
  # Fedora/RHEL
  sudo dnf install glibc libgcc libstdc++ zlib
  ```

**"GStreamer" related errors on Linux**
- Install GStreamer for audio/video processing:
  ```bash
  # Ubuntu/Debian
  sudo apt install gstreamer1.0-plugins-base gstreamer1.0-plugins-good
  
  # Fedora/RHEL
  sudo dnf install gstreamer1-plugins-base gstreamer1-plugins-good
  ```

**"lsb_release not found" error on Linux**
- Install lsb-release before running .NET installation:
  ```bash
  sudo apt install lsb-release  # Ubuntu/Debian
  sudo dnf install redhat-lsb-core  # Fedora/RHEL
  ```

**Performance issues with large libraries**
- Use the `--threads` flag to parallelize encoding/decoding
- Consider using `--skipExisting` to avoid re-encoding existing files
- Use `--noStatusBar` to reduce CPU usage on resource-constrained systems

### Verifying Installation

#### Quick verification
```bash
# Check .NET installation
dotnet --version

# Check opusenc installation (optional)
opusenc --help

# Test the tool
SngCli --version
SngCli --help
```

#### Comprehensive installation test
A test script is provided to verify your installation:
```bash
# Make the test script executable
chmod +x test-installation.sh

# Run the test
./test-installation.sh

# The script will check:
# 1. .NET SDK installation and version
# 2. opusenc availability (optional)
# 3. Project structure
# 4. Build success
# 5. CLI tool functionality
```

## Security Notes

This project includes security hardening:
- Disabled unsafe BinaryFormatter serialization
- Disabled unsafe UTF7 encoding
- Updated dependencies to address known vulnerabilities (SixLabors.ImageSharp 3.1.12)
- Cross-platform safe file path handling
- Input validation and sanitization
- No external network calls or telemetry

### Dependency Security
- **SixLabors.ImageSharp**: Updated to 3.1.12 to address CVE-2024-32035, CVE-2024-32036, and other vulnerabilities
- **BinaryEx**: Version 0.4.0 (latest, no known vulnerabilities)
- **NLayer/NVorbis**: Custom audio decoders with no external dependencies

## Performance Tips

1. **Parallel Processing**: Use `--threads` to match your CPU core count
2. **Skip Existing**: Use `--skipExisting` to avoid re-processing unchanged files
3. **Opus Encoding**: Use `--opusEncode` for significantly smaller file sizes (80-90% reduction)
4. **JPEG Conversion**: Use `--jpegEncode` with `--jpegQuality 75-85` for good quality/size balance
5. **Album Resizing**: Use `--albumResize 512x512` for optimal in-game performance
6. **Disable Status Bar**: Use `--noStatusBar` on headless servers or resource-constrained systems

## Testing and Verification

### Quick Test
```bash
# Create a test directory structure
mkdir -p test_song/{audio,images}
cp some_audio_file.mp3 test_song/audio/guitar.mp3
cp some_image.jpg test_song/images/album.jpg

# Encode the test song
SngCli encode --in ./test_song --out ./test_output --opusEncode --jpegEncode

# Verify the SNG file was created
ls -la ./test_output/*.sng

# Decode back to verify round-trip
SngCli decode --in ./test_output --out ./test_decoded --verbose

# Compare original and decoded files
diff -r test_song test_decoded/test_song
```

### Docker Testing

#### Linux Container Testing
If you have Docker installed, you can test the Linux installation in an isolated environment:

```bash
# Test using the provided Dockerfile
docker build -t sngtool-test .

# Or test manually in a container
docker run --rm -it -v $(pwd):/app ubuntu:22.04 bash
# Inside container:
apt update && apt install -y wget lsb-release
wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt update && apt install -y dotnet-sdk-10.0 opus-tools
cd /app/SngTool
dotnet build
dotnet run --project SngCli/SngCli.csproj -- --help
```

#### Windows Container Testing (Windows host required)
Windows containers require a Windows host with Windows containers enabled:

```powershell
# Build Windows container
docker build -f Dockerfile.windows -t sngtool-windows-test .

# Run tests
docker run --rm sngtool-windows-test

# Test in interactive Windows container
docker run -it --rm mcr.microsoft.com/windows/servercore:ltsc2022 powershell
# Inside container:
choco install dotnet-10.0-sdk -y
choco install opus-tools -y
dotnet --version
opusenc --help
```

**Note**: Windows containers cannot run on macOS or Linux Docker hosts. They require:
- Windows 10/11 Pro/Enterprise or Windows Server 2019/2022
- Docker Desktop with Windows containers enabled
- Hyper-V enabled (for Windows 10/11)

### Running Tests
```bash
# Build and run tests (if test projects exist)
dotnet test

# Or run specific test projects
cd SngTool
dotnet test SngLib.Tests/SngLib.Tests.csproj
```

## Development

### Project Structure
```
SngFileFormat/
├── SngTool/                    # Main tool implementation
│   ├── SngCli/                # Command line interface
│   ├── SngLib/                # Core SNG format library
│   ├── SongLib/               # Song processing library
│   ├── NLayer/                # MP3 decoder library
│   └── NVorbis/               # Ogg Vorbis decoder library
├── build-macos.sh             # macOS build script
└── README.md                  # This file
```

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Code Style
- Follow existing C# coding conventions
- Use meaningful variable and method names
- Add XML documentation comments for public APIs
- Include unit tests for new functionality

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- **Issues**: Report bugs or feature requests on GitHub
- **Documentation**: Refer to this README and the file specification
- **Community**: Check related GuitarGame_ChartFormats projects for compatibility

# SNG File Specification


The following are definitions of the data types used in this file specification

| Data Type      | Description                                                                                                                         |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| byte           | 8-bit unsigned integer                                                                                                              |
| uint32         | 32-bit unsigned integer                                                                                                             |
| uint64         | 64-bit unsigned integer                                                                                                             |
| int32          | 32-bit signed integer                                                                                                               |
| string         | A sequence of utf-8 characters a byte[] array excluding NULL 0x00 characters as many languages use these as end of string sequences |
| SngIdentify    | The SNGPKG file identifier. `0x53 0x4E 0x47 0x50 0x4b 0x47` as bytes. Used to identify the file format                              |
| byte[]         | An array of bytes                                                                                                                   |
| MetadataPair[] | An array of metadataPair objects                                                                                                    |
| FileMeta[]     | An array of fileMeta objects                                                                                                        |
| File[]         | An array of file objects                                                                                                            |
| maskedByte[]   | An array of bytes representing masked file data                                                                                     |

## Structure Overview

Before delving into the full SNG specification, the following is a brief overview of the structure. The format consists of a header followed by three sections, each adhering to this format:

| Field         | Data Type | Size          | Description                                 |
| ------------- | --------- | ------------- | ------------------------------------------- |
| sectionLength | uint64    | 8             | Length of section in bytes after this field |
| sectionData   | byte[]    | sectionLength | Bytes that make up the section              |

These is the required ordering of each of these components:

| Section Type | Description                                                                        |
| ------------ | ---------------------------------------------------------------------------------- |
| Header       | The file header contains important details needed to parse the format              |
| Metadata     | Metadata information for applications that cover the specific song data stored     |
| FileIndex    | Defines information about what files are within the container and how to read them |
| FileData     | Contains the actual file data                                                      |


## Sections

### `Header`
| Field          | Data Type   | Size | Description                               |
| -------------- | ----------- | ---- | ----------------------------------------- |
| fileIdentifier | SngIdentify | 6    | SNGPKG sequence to identify the file type |
| version        | uint32      | 4    | The .sng format version                   |
| xorMask        | byte[]      | 16   | Random bytes for masking files            |


### `Metadata`
| Field             | Data Type      | Size            | Description                                     |
| ----------------- | -------------- | --------------- | ----------------------------------------------- |
| metadataLen       | uint64         | 8               | Number of bytes in the section after this field |
| metadataCount     | uint64         | 8               | Number of MetadataPair sections                 |
| metadataPairArray | MetadataPair[] | metadataLen - 8 | Array of MetadataPair sections                  |

### `MetadataPair` (represents a single metadata string key/value pair)
| Field    | Data Type | Size     | Description                              |
| -------- | --------- | -------- | ---------------------------------------- |
| keyLen   | int32     | 4        | The number of bytes in the key           |
| key      | string    | keyLen   | utf-8 byte string for the metadata's key |
| valueLen | int32     | 4        | The number of bytes in the value         |
| value    | string    | valueLen | The metadata's value                     |

### `FileIndex`
| Field         | Data Type  | Size            | Description                                     |
| ------------- | ---------- | --------------- | ----------------------------------------------- |
| fileMetaLen   | uint64     | 8               | Number of bytes in the section after this field |
| fileCount     | uint64     | 8               | Number of FileMeta (and FileData) sections      |
| fileMetaArray | FileMeta[] | fileMetaLen - 8 | Array of FileMeta sections                      |

### `FileMeta` (contains the file index metadata for each `File` section)
| Field         | Data Type | Size        | Description                                                                                 |
| ------------- | --------- | ----------- | ------------------------------------------------------------------------------------------- |
| filenameLen   | byte      | 1           | The number of bytes in the filename                                                         |
| filename      | string    | filenameLen | Relative file path within song folder. Folders are denoted by the '/' character following each folder. The filename follows all folders. |
| contentsLen   | uint64    | 8           | The number of bytes in the file's contents                                                  |
| contentsIndex | uint64    | 8           | The first byte index from the start of the file of the corresponding file section           |

### `FileData`
| Field         | Data Type | Size        | Description                            |
| ------------- | --------- | ----------- | -------------------------------------- |
| fileDataLen   | uint64    | 8           | Total length in bytes of all file data |
| fileDataArray | File[]    | fileDataLen | Concatenated file sections             |

### `File` (contains the binary contents of a single file)
| Field           | Data Type    | Size        | Description                       |
| --------------- | ------------ | ----------- | --------------------------------- |
| maskedFileBytes | maskedByte[] | contentsLen | The file's binary contents masked |

## Masking
File Data is masked using a fairly simple algorithm which utilizes the xorMask field from the file header and the byte pos within that file. The following is example pseudo code to convert to the file's true contents.
```js
 // Iterate through the indices of the maskedFileBytes array
 for i = 0 to size(maskedFileBytes) - 1:

    // Calculate the XOR key based on the current index and xorMask array
    xorKey = xorMask[i % 16] XOR (i AND 0xFF)    // You can cast to a byte instead of "AND 0xFF" if your language supports it

    // XOR each byte in maskedFileBytes with the xorKey
    fileBytes[i] = maskedFileBytes[i] XOR xorKey
```
## Metadata Strings
Some characters in metadata strings have restrictions to simplify serialization into INI files, affecting both keys and values. To include data with these characters, it's recommended to replace or remove them before converting into the SNG format.
- Semicolon (;)
  - Semicolons are used to denote comments in INI files. If a semicolon is allowed in a key, it will create confusion between a key-value pair and a comment, making it difficult to parse the INI file correctly.
- Newline characters (\r\n)
  - Newline characters mark the end of a line in a text file. Allowing newline characters in values makes it hard to tell where one key-value pair finishes and the next starts, causing problems when reading the file.

### Characters only disallowed for keys

- Equal sign (=)
  - In an INI file, an equal sign (=) separates keys and values. Allowing an equal sign in a key can cause confusion about where the key stops and  the value starts. This issue doesn't affect values, as only the  first equal sign on a line separates the key from the value. For instance, some song.ini tags use equal signs in values, like `<color=#00FF00>`, to indicate the color of a metadata string.

## Metadata values:

Metadata values are strings, but some are intended to be string representations of specific data types. Applications must decide how to parse the data type from the string. The following are a baseline of common types that should stay consistent between all applications:

### bool

Bool values take the form of 2 strings and they are case sensitive:

- True

- False

### integer

Integer values take the following form: (+/- sign)(digits)

1. sign  - Optional sign digit - or +

2. digits  - A sequence of digit characters 0 - 9

### float

Float values take the following form: (+/- sign)(integral_digits).(fractional_digits)

1. sign  - Optional sign digit - or +
2. integral_digits - A sequence of digit characters 0 - 9 representing whole numbers
3. period (.) - this is the delimiter between integral_digits and fractional_digits
4. fractional_digits - A sequence of digit characters 0 - 9 representing the fractional part of the number

### string

Strings are the final fallback data type any value that cannot be represented as above currently will be assumed as string as long as it follows the Metadata rules and the rules for the SNG utf-8 string type above (no null 0x00 characters).

## File Names
There are also some limitations to what is allowed for file names to prevent issues across operating systems when extracting files:

- `<` (less than)
- `>` (greater than)
- `:` (colon)
- `"` (double quote)
- `/` (forward slash)
- `\` (backslash)
- `|` (vertical bar or pipe)
- `?` (question mark)
- `*` (asterisk)
- Integer value characters below 31(`0x00 - 0x1F`), known as control characters
- `0x7f` (DEL character)
- `..` (Two consecutive periods)
- Do not end a file name with a period `.` or a space ` `
- the following names are prohibited due to windows reserved file name list, this includes when using file extensions. For example both CON and CON.txt are disallowed
  - `CON`
  - `PRN`
  - `AUX`
  - `NUL`
  - `COM0`
  - `COM1`
  - `COM2`
  - `COM3`
  - `COM4`
  - `COM5`
  - `COM6`
  - `COM7`
  - `COM8`
  - `COM9`
  - `LPT0`
  - `LPT1`
  - `LPT2`
  - `LPT3`
  - `LPT4`
  - `LPT5`
  - `LPT6`
  - `LPT7`
  - `LPT8`
  - `LPT9`

## Design Decisions
- The primary advantage of using a format like this is that it enables streaming audio data from the container without having to load the entire file into memory, thanks to the use of memory-mapped files. Since no compression is applied, the file offsets remain static, which simplifies reading data from the file.
  - In comparison, other projects often employ formats based on ZIP files. Although it's possible to seek within a ZIP file during runtime, the data typically needs to be decompressed and loaded into memory. In C#, this imposes a limit of 2GB of data per audio file. Additionally, because audio data is generally already compressed, using ZIP files introduces unnecessary overhead that slows down the process of loading audio. By opting for a format that does not rely on compression, these limitations can be avoided, allowing for more efficient streaming and access to audio data.
- The metadata is versatile and not confined to any particular application. It can encompass a multitude of properties, including those specific to individual applications. To prevent inadvertent property clashes among data from different applications, a metadata keys registry is also included in this repository. Metadata should be limited to what can be serialized into an INI file, as it must be capable of round-tripping to and from a song.ini file. For more complex metadata requiring additional data blobs, they should be managed as a separate file within the container.
- `.sng` is designed to be able to contain the binary contents of any set of files.
- File binaries are placed at the end of the format, and sections have lengths to allow programs to efficiently scan only the `.sng`'s `metadata` or `fileMeta` sections whichever may be required.
- The format has lengths defined in each major section to allow easily skipping over data that may not be required during parsing.
- The file binary is masked so that it can't be directly detected by programs that don't know how to parse the file.
- This format is exclusively in a LittleEndian byte ordering for efficiency on modern cpu architectures.
- File names are purposely limited to 255 bytes in length as most file systems have this length restriction.

## Registry

The registry is intended to be a helpful tool for anyone utilizing the format, participation ensures that others will not inadvertently use conflicting metadata keys. It is not required to register keys with the registry but it is in your best interest as an application developer to do so.

To submit a new entry for the registry submit a pull request to add any keys that your application may be making use of along with the recommended data type for this value. We recommend using a application prefix if it is something very specific to your application, however if it is a more general usage metadata value not including a prefix would make sense.

### Metadata registry

Currently there are no SNG specific metadata names registered but all the keys from these links should be considered taken thus far:

[GuitarGame_ChartFormats - Game Specific Tags](https://github.com/TheNathannator/GuitarGame_ChartFormats/blob/main/doc/FileFormats/song.ini/Game-Specific%20Tags.md)

[GuitarGame_ChartFormats - Typical Tags](https://github.com/TheNathannator/GuitarGame_ChartFormats/blob/main/doc/FileFormats/song.ini/Typical%20Tags.md)

### Filename Registry

The filename registry serves a similar purpose to the metadata one so that conflicting file names aren't utilized within the format that have different usages.

*note* that currently all registered file names are specified as lowercase, this is intentional. The reference encoding tool will force any files of these names to be lowercase within the output file, however any unknown file names will not be modified.

Additionally filenames can contain folders within the song seperated by the '/' character however currently there are no 'registered' folders as being used in the accepted format. The reference tool does support encoding folders when explicitly enabled.

- `notes.chart`
- `notes.mid`
- `song.ini` - Reserved, but will be not communicated through into sng file as this is the source of metadata in the SNG file
- `album.{png,jpg,jpeg}`
- `background.{png,jpg,jpeg}`
- `highway.{png,jpg,jpeg}`
- `video.{mp4,avi,webm,vp8,ogv,mpeg}`
- `guitar.{mp3,ogg,opus,wav}`
- `bass.{mp3,ogg,opus,wav}`
- `rhythm.{mp3,ogg,opus,wav}`
- `vocals.{mp3,ogg,opus,wav}`
- `vocals_1.{mp3,ogg,opus,wav}`
- `vocals_2.{mp3,ogg,opus,wav}`
- `drums.{mp3,ogg,opus,wav}`
- `drums_1.{mp3,ogg,opus,wav}`
- `drums_2.{mp3,ogg,opus,wav}`
- `drums_3.{mp3,ogg,opus,wav}`
- `drums_4.{mp3,ogg,opus,wav}`
- `keys.{mp3,ogg,opus,wav}`
- `song.{mp3,ogg,opus,wav}`
- `crowd.{mp3,ogg,opus,wav}`
- `preview.{mp3,ogg,opus,wav}`


## Testing

This fork includes automated test infrastructure created with AI assistance. These tests are provided as-is and have not been manually verified.

### Available Tests

#### Cross-Platform Build Validation
```bash
# Test Windows/Linux builds from macOS
./tests/windows/test-windows-build.sh
```

#### Docker Container Tests
```bash
# Linux Docker container
docker build -f Dockerfile -t sngtool-linux-test .
docker run --rm sngtool-linux-test

# Windows Docker container (requires Windows host)
docker build -f Dockerfile.windows -t sngtool-windows-test .
docker run --rm sngtool-windows-test
```

#### Platform-Specific Tests
- **Linux**: `tests/linux/test-linux-install.sh`
- **Windows**: `tests/windows/test-windows-install.ps1` (PowerShell) or `tests/windows/test-windows-install.bat` (Batch)
- **General**: `tests/test-installation.sh`

### Important Notes
- These tests were generated with AI assistance
- Manual verification is recommended before production use
- Test results and validation reports are in `tests/validation/` directory
- Use caution when running automated tests in production environments

### Test Organization
```
tests/
├── docker/          # Docker container tests
├── windows/         # Windows-specific tests
├── linux/           # Linux-specific tests
├── validation/      # Test validation reports
├── test-build-simple.sh     # General build tests
└── test-installation.sh     # General installation tests
```