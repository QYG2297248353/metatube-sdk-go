# GitHub Workflows

This directory contains GitHub Actions workflows for the MetaTube SDK Go project.

## Workflows Overview

### 1. `release-docker.yml` (NEW)
**Trigger**: GitHub Release publication
**Purpose**: Build and publish Docker images when a new release is created

**Features**:
- Automatically triggers when a release is published
- Extracts version from release tag (supports both `v1.0.0` and `1.0.0` formats)
- Builds multi-architecture Docker images (linux/amd64, linux/arm64)
- Publishes to GitHub Container Registry with multiple tags:
  - `ghcr.io/metatube-community/metatube-server:latest`
  - `ghcr.io/metatube-community/metatube-server:{version}` (without 'v' prefix)
  - `ghcr.io/metatube-community/metatube-server:{tag_name}` (full tag name)
- Updates release description with Docker image information
- Generates image manifest and pull commands

### 2. `docker.yml`
**Trigger**: Push to `main` branch
**Purpose**: Build and publish development Docker images

**Features**:
- Builds `dev` tagged images for main branch pushes
- Multi-architecture support (linux/amd64, linux/arm64)

### 3. `release.yml`
**Trigger**: Git tag push
**Purpose**: Build and publish binary releases

**Features**:
- Cross-compilation for multiple platforms
- Uploads release artifacts to separate repository

### 4. `test.yml`
**Trigger**: Pull requests and pushes
**Purpose**: Run test suite

### 5. `linter.yml`
**Trigger**: Pull requests and pushes
**Purpose**: Run code linting

### 6. `codeql-analysis.yml`
**Trigger**: Pull requests and pushes
**Purpose**: Security analysis with CodeQL

### 7. `stale.yml`
**Trigger**: Scheduled
**Purpose**: Manage stale issues and pull requests

## Release Process

1. Create a new release on GitHub with a version tag (e.g., `v1.0.0`)
2. The `release-docker.yml` workflow will automatically:
   - Build Docker images for multiple architectures
   - Publish images to GitHub Container Registry
   - Update the release description with image information
3. The `release.yml` workflow will build and publish binary releases

## Docker Image Usage

```bash
# Pull the latest version
docker pull ghcr.io/metatube-community/metatube-server:latest

# Pull a specific version
docker pull ghcr.io/metatube-community/metatube-server:1.0.0

# Run the container
docker run -d \
  --name metatube-server \
  -p 8080:8080 \
  -e TOKEN=your-token \
  -e DSN=your-database-connection-string \
  ghcr.io/metatube-community/metatube-server:1.0.0
```