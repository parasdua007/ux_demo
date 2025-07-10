#!/bin/bash

# Claude Desktop Automated Installation Script
# This script attempts to install Claude Desktop using various methods

set -e

echo "🚀 Claude Desktop Automated Installation"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Claude Desktop is already installed
if command -v claude &> /dev/null; then
    print_success "Claude Desktop is already installed!"
    echo "Location: $(which claude)"
    echo "Version: $(claude --version 2>/dev/null || echo 'Version unknown')"
    exit 0
fi

# Method 1: Try Snap
print_status "Attempting to install via Snap..."
if command -v snap &> /dev/null; then
    if sudo snap install claude-desktop; then
        print_success "Claude Desktop installed via Snap!"
        exit 0
    else
        print_warning "Snap installation failed"
    fi
else
    print_warning "Snap not available"
fi

# Method 2: Try Flatpak
print_status "Attempting to install via Flatpak..."
if command -v flatpak &> /dev/null; then
    # Add flathub if not already added
    if ! flatpak remote-list | grep -q flathub; then
        print_status "Adding Flathub repository..."
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    
    if flatpak install flathub com.anthropic.Claude -y; then
        print_success "Claude Desktop installed via Flatpak!"
        exit 0
    else
        print_warning "Flatpak installation failed"
    fi
else
    print_warning "Flatpak not available"
fi

# Method 3: Try to download from official source
print_status "Attempting to download from official source..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Try to download using curl
print_status "Trying to download Claude Desktop..."

# Note: The actual download URL might be different
DOWNLOAD_URLS=(
    "https://claude.ai/download"
    "https://releases.anthropic.com/claude-desktop/latest/linux"
    "https://github.com/anthropics-ai/claude-desktop/releases/latest/download/claude-desktop-linux.deb"
)

DOWNLOADED=false

for url in "${DOWNLOAD_URLS[@]}"; do
    print_status "Trying: $url"
    if curl -L -o claude-desktop.deb "$url" 2>/dev/null; then
        if [ -f claude-desktop.deb ]; then
            print_success "Download successful!"
            DOWNLOADED=true
            break
        fi
    fi
done

if [ "$DOWNLOADED" = true ]; then
    print_status "Installing downloaded package..."
    if sudo dpkg -i claude-desktop.deb; then
        sudo apt-get install -f -y
        print_success "Claude Desktop installed from downloaded package!"
        cd /workspace/mcp-server
        rm -rf "$TEMP_DIR"
        exit 0
    else
        print_warning "Package installation failed"
    fi
else
    print_warning "Could not download Claude Desktop automatically"
fi

# Clean up
cd /workspace/mcp-server
rm -rf "$TEMP_DIR"

# Method 4: Try to install via package manager
print_status "Checking package repositories..."
if sudo apt update && sudo apt search claude-desktop 2>/dev/null | grep -q claude-desktop; then
    if sudo apt install claude-desktop -y; then
        print_success "Claude Desktop installed via apt!"
        exit 0
    fi
fi

# If all methods failed, provide manual instructions
echo ""
print_error "Automatic installation failed. Please install Claude Desktop manually:"
echo ""
echo "📥 Manual Installation Options:"
echo ""
echo "1. Visit https://claude.ai/download and download the Linux version"
echo "2. Install the downloaded .deb file:"
echo "   sudo dpkg -i claude-desktop_*.deb"
echo "   sudo apt-get install -f"
echo ""
echo "3. Or try installing via package manager:"
echo "   sudo apt update"
echo "   sudo apt install claude-desktop"
echo ""
echo "4. Or try building from source (if repository is available):"
echo "   git clone https://github.com/anthropics-ai/claude-desktop.git"
echo "   cd claude-desktop"
echo "   npm install"
echo "   npm run build"
echo "   sudo npm install -g ."
echo ""
echo "After installation, run the MCP setup script:"
echo "cd /workspace/mcp-server && ./setup-claude-desktop.sh"
echo ""

exit 1