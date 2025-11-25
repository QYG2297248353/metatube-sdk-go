@echo off
echo MetaTube SDK Go Windows Build Script
echo =====================================

REM Configuration
set MODULE=github.com/metatube-community/metatube-sdk-go
set SERVER_NAME=metatube-server
set SERVER_CODE=cmd/server/main.go
set BUILD_DIR=build

REM Create build directory
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

REM Get version info
for /f "tokens=*" %%i in ('git rev-parse --short HEAD 2^>nul') do set BUILD_COMMIT=%%i
for /f "tokens=*" %%i in ('git describe --abbrev=0 --tags HEAD 2^>nul') do set BUILD_TAG=%%i
for /f "tokens=1 delims=v" %%i in ("%BUILD_TAG%") do set BUILD_VERSION=%%i

if "%BUILD_COMMIT%"=="" set BUILD_COMMIT=unknown
if "%BUILD_VERSION%"=="" set BUILD_VERSION=unknown

echo Version: %BUILD_VERSION%
echo Commit:  %BUILD_COMMIT%
echo.

REM Set common build flags
set GO111MODULE=on
set CGO_ENABLED=0
set BUILD_FLAGS=-v -trimpath
set LDFLAGS_BASE=-w -s -buildid=
set LDFLAGS=%LDFLAGS_BASE% -X "%MODULE%/internal/version.Version=%BUILD_VERSION%" -X "%MODULE%/internal/version.GitCommit=%BUILD_COMMIT%"

REM Build function
:build_arch
set GOOS=%1
set GOARCH=%2
set GOAMD64=%3
set OUTPUT_NAME=%SERVER_NAME%-%1-%2

if not "%3"=="" set OUTPUT_NAME=%OUTPUT_NAME%-%3

if "%1"=="windows" (
    set OUTPUT_NAME=%OUTPUT_NAME%.exe
)

echo Building for %GOOS%/%GOARCH%/%GOAMD64%...
set GOOS=%GOOS%
set GOARCH=%GOARCH%

if not "%GOAMD64%"=="" (
    set GOAMD64=%GOAMD64%
    go build %BUILD_FLAGS% -ldflags "%LDFLAGS%" -o "%BUILD_DIR%\%OUTPUT_NAME%" %SERVER_CODE%
) else (
    go build %BUILD_FLAGS% -ldflags "%LDFLAGS%" -o "%BUILD_DIR%\%OUTPUT_NAME%" %SERVER_CODE%
)

if %ERRORLEVEL% EQU 0 (
    echo ✓ Success: %BUILD_DIR%\%OUTPUT_NAME%
) else (
    echo ✗ Failed: %BUILD_DIR%\%OUTPUT_NAME%
)
echo.

goto :eof

REM Main build logic
if "%1"=="all" (
    echo Building all Windows architectures...
    call :build_arch windows amd64
    call :build_arch windows amd64 v3
    call :build_arch windows arm64
    goto :end
)

if "%1"=="amd64" (
    call :build_arch windows amd64
    goto :end
)

if "%1"=="amd64-v3" (
    call :build_arch windows amd64 v3
    goto :end
)

if "%1"=="arm64" (
    call :build_arch windows arm64
    goto :end
)

REM Default: build for current architecture
echo Building for current Windows architecture...
go build %BUILD_FLAGS% -ldflags "%LDFLAGS%" -o "%BUILD_DIR%\%SERVER_NAME%.exe" %SERVER_CODE%

if %ERRORLEVEL% EQU 0 (
    echo ✓ Success: %BUILD_DIR%\%SERVER_NAME%.exe
) else (
    echo ✗ Failed: %BUILD_DIR%\%SERVER_NAME%.exe
)

:end
echo.
echo Build completed! Check the %BUILD_DIR% directory for output files.