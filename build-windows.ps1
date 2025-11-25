# MetaTube SDK Go Windows Build Script (PowerShell)
# ================================================

param(
    [string]$Target = "current",
    [string]$OutputDir = "build"
)

# Configuration
$ModuleName = "github.com/metatube-community/metatube-sdk-go"
$ServerName = "metatube-server"
$ServerCode = "cmd/server/main.go"

# Create build directory
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Get version info
try {
    $BuildCommit = git rev-parse --short HEAD
    $BuildTag = git describe --abbrev=0 --tags HEAD
    $BuildVersion = $BuildTag -replace '^v', ''
} catch {
    $BuildCommit = "unknown"
    $BuildVersion = "unknown"
}

Write-Host "Version: $BuildVersion" -ForegroundColor Green
Write-Host "Commit:  $BuildCommit" -ForegroundColor Green
Write-Host ""

# Set common build flags
$env:GO111MODULE = "on"
$env:CGO_ENABLED = "0"
$BuildFlags = "-v -trimpath"
$LdflagsBase = "-w -s -buildid="
$Ldflags = "$LdflagsBase -X `"$ModuleName/internal/version.Version=$BuildVersion`" -X `"$ModuleName/internal/version.GitCommit=$BuildCommit`""

# Build function
function Build-Architecture {
    param(
        [string]$GoOS,
        [string]$GoArch,
        [string]$GoAmd64 = ""
    )
    
    $OutputName = "$ServerName-$GoOS-$GoArch"
    if ($GoAmd64) {
        $OutputName += "-$GoAmd64"
    }
    if ($GoOS -eq "windows") {
        $OutputName += ".exe"
    }
    
    Write-Host "Building for $GoOS/$GoArch/$GoAmd64..." -ForegroundColor Yellow
    
    $env:GOOS = $GoOS
    $env:GOARCH = $GoArch
    
    if ($GoAmd64) {
        $env:GOAMD64 = $GoAmd64
    } else {
        $env:GOAMD64 = ""
    }
    
    $BuildCmd = "go build $BuildFlags -ldflags `"$Ldflags`" -o `"$OutputDir/$OutputName`" $ServerCode"
    
    try {
        Invoke-Expression $BuildCmd
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Success: $OutputDir/$OutputName" -ForegroundColor Green
        } else {
            Write-Host "✗ Failed: $OutputDir/$OutputName" -ForegroundColor Red
        }
    } catch {
        Write-Host "✗ Failed: $OutputDir/$OutputName" -ForegroundColor Red
    }
    
    Write-Host ""
}

# Main build logic
switch ($Target.ToLower()) {
    "all" {
        Write-Host "Building all Windows architectures..." -ForegroundColor Cyan
        Build-Architecture "windows" "amd64"
        Build-Architecture "windows" "amd64" "v3"
        Build-Architecture "windows" "arm64"
    }
    "amd64" {
        Build-Architecture "windows" "amd64"
    }
    "amd64-v3" {
        Build-Architecture "windows" "amd64" "v3"
    }
    "arm64" {
        Build-Architecture "windows" "arm64"
    }
    default {
        Write-Host "Building for current Windows architecture..." -ForegroundColor Cyan
        $BuildCmd = "go build $BuildFlags -ldflags `"$Ldflags`" -o `"$OutputDir/$ServerName.exe`" $ServerCode"
        
        try {
            Invoke-Expression $BuildCmd
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ Success: $OutputDir/$ServerName.exe" -ForegroundColor Green
            } else {
                Write-Host "✗ Failed: $OutputDir/$ServerName.exe" -ForegroundColor Red
                exit 1
            }
        } catch {
            Write-Host "✗ Failed: $OutputDir/$ServerName.exe" -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host ""
Write-Host "Build completed! Check the $OutputDir directory for output files." -ForegroundColor Cyan