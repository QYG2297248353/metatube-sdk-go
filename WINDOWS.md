# Windows Build Guide

This document provides detailed instructions for building MetaTube SDK Go on Windows.

## Prerequisites

- Go 1.23 or later installed
- Git installed (for version information)
- Windows 10/11 or Windows Server

## Build Methods

### Method 1: PowerShell Script (Recommended)

The PowerShell script provides the most flexible and user-friendly building experience on Windows.

```powershell
# Build for current Windows architecture
.\build-windows.ps1

# Build for specific architecture
.\build-windows.ps1 -Target amd64
.\build-windows.ps1 -Target amd64-v3
.\build-windows.ps1 -Target arm64

# Build all Windows architectures
.\build-windows.ps1 -Target all

# Custom output directory
.\build-windows.ps1 -Target amd64 -OutputDir dist
```

### Method 2: Batch Script

Simple batch script for quick builds.

```cmd
# Build for current Windows architecture
build.bat

# Build all Windows architectures
build-windows.bat all

# Build specific architecture
build-windows.bat amd64
build-windows.bat amd64-v3
build-windows.bat arm64
```

### Method 3: Makefile (with WSL or MinGW)

If you have Windows Subsystem for Linux (WSL) or MinGW installed, you can use the Makefile:

```sh
# Build for Windows AMD64
make windows-amd64

# Build for all Windows architectures
make windows-amd64 windows-amd64-v3 windows-arm64

# Build all platforms
make all-arch
```

### Method 4: Manual Go Build

For maximum control, you can build manually using go build:

```cmd
# Windows AMD64
set GOOS=windows
set GOARCH=amd64
set CGO_ENABLED=0
go build -v -ldflags "-w -s -X github.com/metatube-community/metatube-sdk-go/internal/version.Version=%VERSION% -X github.com/metatube-community/metatube-sdk-go/internal/version.GitCommit=%COMMIT%" -o build/metatube-server.exe cmd/server/main.go
```

## Output Files

All build methods place executables in the `build/` directory:

- `metatube-server.exe` - Current architecture build
- `metatube-server-windows-amd64.exe` - Windows AMD64 build
- `metatube-server-windows-amd64-v3.exe` - Windows AMD64 v3 build
- `metatube-server-windows-arm64.exe` - Windows ARM64 build

## Version Information

Builds automatically include version and commit information. To view the version:

```cmd
metatube-server.exe --version
```

Example output:
```
v1.2.3-a1b2c3d
```

If no git tags are available, it will show:
```
v-a1b2c3d
```

## Build Configuration

The builds use the following configuration:

- **CGO_ENABLED=0** - Static linking for better portability
- **LDFLAGS** - Strip debug information and reduce binary size
- **Version injection** - Automatic version and commit hash embedding
- **Trimpath** - Remove file system paths from binary

## Troubleshooting

### Permission Issues
If you get permission errors running PowerShell scripts:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Git Not Found
Ensure Git is installed and in your PATH. The build scripts use Git to get version information.

### Build Failures
Common issues and solutions:

1. **Go version too old**: Ensure you have Go 1.23+
2. **Missing dependencies**: Run `go mod download` first
3. **Network issues**: Check your internet connection for dependency downloads

## Running the Application

After building, you can run the server:

```cmd
# Basic usage
metatube-server.exe

# With configuration
metatube-server.exe --bind 0.0.0.0 --port 8080

# Show version
metatube-server.exe --version
```

## Environment Variables

The application supports several environment variables:

- `VERSION` - Override version information
- `BIND` - Default bind address (default: 127.0.0.1)
- `PORT` - Default port (default: 8080)

## Support

For issues related to Windows builds, please:

1. Check this documentation first
2. Verify your Go version and installation
3. Check the main project README.md
4. Open an issue on the project GitHub repository