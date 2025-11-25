@echo off
echo Building MetaTube SDK Go for Windows...

REM Set build variables
set BUILD_DIR=build
set SERVER_NAME=metatube-server
set SERVER_CODE=cmd/server/main.go

REM Create build directory if it doesn't exist
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

REM Get version and commit info
for /f "tokens=*" %%i in ('git rev-parse --short HEAD') do set BUILD_COMMIT=%%i
for /f "tokens=*" %%i in ('git describe --abbrev=0 --tags HEAD') do set BUILD_TAG=%%i
for /f "tokens=1 delims=v" %%i in ("%BUILD_TAG%") do set BUILD_VERSION=%%i

echo Building version: %BUILD_VERSION% (%BUILD_COMMIT%)

REM Build for current Windows architecture
set GO111MODULE=on
set CGO_ENABLED=0
set LDFLAGS=-w -s -buildid= -X github.com/metatube-community/metatube-sdk-go/internal/version.Version=%BUILD_VERSION% -X github.com/metatube-community/metatube-sdk-go/internal/version.GitCommit=%BUILD_COMMIT%

go build -v -ldflags "%LDFLAGS%" -trimpath -o %BUILD_DIR%\%SERVER_NAME%.exe %SERVER_CODE%

if %ERRORLEVEL% EQU 0 (
    echo Build successful!
    echo Executable created: %BUILD_DIR%\%SERVER_NAME%.exe
) else (
    echo Build failed!
    exit /b 1
)