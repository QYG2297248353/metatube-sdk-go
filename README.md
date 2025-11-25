# MetaTube SDK Go

[![Build Status](https://img.shields.io/github/actions/workflow/status/metatube-community/metatube-sdk-go/docker.yml?branch=main&style=flat-square&logo=github-actions)](https://github.com/metatube-community/metatube-sdk-go/actions/workflows/release.yml)
[![Go Report Card](https://goreportcard.com/badge/github.com/metatube-community/metatube-sdk-go?style=flat-square)](https://github.com/metatube-community/metatube-sdk-go)
[![Require Go Version](https://img.shields.io/badge/go-%3E%3D1.23-30dff3?style=flat-square&logo=go)](https://github.com/metatube-community/metatube-sdk-go/blob/main/go.mod)
[![GitHub License](https://img.shields.io/github/license/metatube-community/metatube-sdk-go?color=e4682a&logo=apache&style=flat-square)](https://github.com/metatube-community/metatube-sdk-go/blob/main/LICENSE)
[![Tag](https://img.shields.io/github/v/tag/metatube-community/metatube-sdk-go?color=%23ff8936&logo=fitbit&style=flat-square)](https://github.com/metatube-community/metatube-sdk-go/tags)

Metadata Tube SDK in Golang.

## Contents

- [MetaTube SDK Go](#metatube-sdk-go)
    - [Contents](#contents)
    - [Features](#features)
    - [Installation](#installation)
    - [Building](#building)
    - [Credits](#credits)
    - [License](#license)

## Features

- Supported platforms
    - Linux
    - Darwin
    - Windows
    - BSD(s)
- Supported Databases
    - [SQLite](https://gitlab.com/cznic/sqlite)
    - [PostgreSQL](https://github.com/jackc/pgx)
- Image processing
    - Auto cropping
    - Badge support
    - Face detection
    - Image hashing
- RESTful API
- 20+ providers
- Text translation

## Installation

To install this package, you first need [Go](https://golang.org/) installed (**go1.23+ is required**), then you can use
the below Go command to install SDK.

```sh
go get -u github.com/metatube-community/metatube-sdk-go
```

## Building

### Build from Source

#### Makefile (Cross-platform)

The project includes a comprehensive Makefile that supports building for multiple platforms:

```sh
# Build for current platform
make development

# Build for Windows (current architecture)
make windows-amd64

# Build for all Windows architectures
make windows-amd64 windows-amd64-v3 windows-arm64

# Build all supported platforms
make all-arch
```

All built binaries are placed in the `build/` directory with appropriate naming and extensions.

#### Windows Build Scripts

For Windows users, several build scripts are provided:

**PowerShell Script (Recommended):**
```powershell
# Build for current Windows architecture
.\build-windows.ps1

# Build for specific architecture
.\build-windows.ps1 -Target amd64
.\build-windows.ps1 -Target amd64-v3
.\build-windows.ps1 -Target arm64

# Build all Windows architectures
.\build-windows.ps1 -Target all
```

**Batch Script:**
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

#### Manual Go Build

You can also build manually using `go build`:

```sh
# Windows AMD64
GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -v -ldflags "-w -s -X github.com/metatube-community/metatube-sdk-go/internal/version.Version=$(git describe --abbrev=0 --tags HEAD | cut -d'v' -f 2) -X github.com/metatube-community/metatube-sdk-go/internal/version.GitCommit=$(git rev-parse --short HEAD)" -o build/metatube-server.exe cmd/server/main.go

# Linux AMD64
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -ldflags "-w -s -X github.com/metatube-community/metatube-sdk-go/internal/version.Version=$(git describe --abbrev=0 --tags HEAD | cut -d'v' -f 2) -X github.com/metatube-community/metatube-sdk-go/internal/version.GitCommit=$(git rev-parse --short HEAD)" -o build/metatube-server cmd/server/main.go
```

### Build Information

All builds include version and commit information that can be viewed using:

```sh
./metatube-server --version
```

The build process automatically injects:
- Version from git tags
- Git commit hash
- Build timestamp

### Output Directory

All built executables are placed in the `build/` directory:
- Windows executables have `.exe` extension
- Other platforms use binary names without extension
- Cross-platform builds include platform and architecture in filename

For detailed Windows-specific build instructions, see [WINDOWS.md](WINDOWS.md).

## Credits

| Library                                                                                                   | Description                                                                                                                                                            |
|-----------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| [gocolly/colly](https://github.com/gocolly/colly)                        | Elegant Scraper and Crawler Framework for Golang                                                                                            |
| [gin-gonic/gin](https://github.com/gin-gonic/gin)                        | Gin is a HTTP web framework written in Go                                                                                                         |
| [gorm.io/gorm](https://gorm.io/)                                                        | The fantastic ORM library for Golang                                                                                                                 |
| [esimov/pigo](https://github.com/esimov/pigo)                               | Fast face detection, pupil/eyes localization and facial landmark points detection library in pure Go |
| [robertkrimen/otto](https://github.com/robertkrimen/otto)       | A JavaScript interpreter in Go (golang)                                                              |
| [modernc.org/sqlite](https://gitlab.com/cznic/sqlite)                 | Package sqlite is a CGo-free port of SQLite/SQLite3                                                                                      |
| [corona10/goimagehash](https://github.com/corona10/goimagehash) | Go Perceptual image hashing package                                                                                                                  |
| [antchfx/xpath](https://github.com/antchfx/xpath)                        | XPath package for Golang, supports HTML, XML, JSON document query                                                               |
| [gen2brain/jpegli](https://github.com/gen2brain/jpegli)         | Go encoder/decoder for JPEG based on jpegli                                                          |

## License

[Apache-2.0 License](https://github.com/metatube-community/metatube-sdk-go/blob/main/LICENSE)
