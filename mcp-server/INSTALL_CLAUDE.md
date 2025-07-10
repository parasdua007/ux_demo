# Claude Desktop Installation Guide

This guide provides multiple methods to install Claude Desktop on your Linux system.

## Method 1: Official Download (Recommended)

### Step 1: Visit the Official Website
1. Open your web browser
2. Go to [https://claude.ai/download](https://claude.ai/download)
3. Click on "Download for Linux"
4. Choose the appropriate version (usually .deb for Ubuntu/Debian)

### Step 2: Install the Downloaded Package
```bash
# Navigate to your Downloads folder
cd ~/Downloads

# Install the .deb package
sudo dpkg -i claude-desktop_*.deb

# Fix any dependency issues
sudo apt-get install -f
```

## Method 2: Using Package Managers

### Option A: Snap (if available)
```bash
# Install snap if not already installed
sudo apt update
sudo apt install snapd

# Install Claude Desktop via snap
sudo snap install claude-desktop
```

### Option B: Flatpak (if available)
```bash
# Install flatpak if not already installed
sudo apt update
sudo apt install flatpak

# Add flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Claude Desktop via flatpak
flatpak install flathub com.anthropic.Claude
```

## Method 3: Manual Installation

### Step 1: Download the Latest Release
```bash
# Create a temporary directory
mkdir -p ~/claude-install
cd ~/claude-install

# Try to download from various sources
# Note: You may need to manually download from the website
echo "Please manually download Claude Desktop from https://claude.ai/download"
```

### Step 2: Extract and Install
```bash
# If you have a .tar.gz file
tar -xzf claude-desktop-*.tar.gz
cd claude-desktop-*

# If you have a .deb file
sudo dpkg -i *.deb
sudo apt-get install -f
```

## Method 4: Building from Source (Advanced)

### Prerequisites
```bash
# Install build dependencies
sudo apt update
sudo apt install git nodejs npm build-essential

# Clone the repository (if available)
git clone https://github.com/anthropics-ai/claude-desktop.git
cd claude-desktop

# Install dependencies
npm install

# Build the application
npm run build

# Install globally
sudo npm install -g .
```

## Method 5: Alternative: Using Web Version

If you can't install the desktop version, you can use the web version with MCP:

### Step 1: Install MCP Browser Extension
1. Install a browser extension that supports MCP
2. Configure it to use your local MCP server

### Step 2: Configure MCP for Web
```bash
# Create a simple HTTP server for MCP
cd /workspace/mcp-server
npm install -g http-server

# Start the server
http-server -p 3000
```

## Verification

After installation, verify Claude Desktop is working:

```bash
# Check if Claude Desktop is installed
which claude

# Check version
claude --version

# Start Claude Desktop
claude
```

## Post-Installation Setup

Once Claude Desktop is installed, run the setup script to configure MCP:

```bash
cd /workspace/mcp-server
./setup-claude-desktop.sh
```

## Troubleshooting

### Common Issues:

1. **Permission Denied**:
   ```bash
   # Make sure the file is executable
   chmod +x /path/to/claude
   ```

2. **Dependencies Missing**:
   ```bash
   # Install missing dependencies
   sudo apt-get install -f
   ```

3. **Library Issues**:
   ```bash
   # Update system libraries
   sudo apt update && sudo apt upgrade
   ```

4. **Display Issues**:
   ```bash
   # Check if you have a display server running
   echo $DISPLAY
   ```

### Debug Mode:
```bash
# Run Claude Desktop with debug logging
claude --debug

# Check system logs
journalctl -u claude-desktop
```

## Alternative: Using Docker

If you prefer using Docker:

```bash
# Pull the official image (if available)
docker pull anthropic/claude-desktop

# Run Claude Desktop in Docker
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /workspace/mcp-server:/workspace/mcp-server \
  anthropic/claude-desktop
```

## Next Steps

After successful installation:

1. **Run the MCP setup script**:
   ```bash
   cd /workspace/mcp-server
   ./setup-claude-desktop.sh
   ```

2. **Test the integration**:
   - Start Claude Desktop
   - Ask: "What tools do you have available?"
   - Try: "Get the weather in San Francisco"

3. **Customize your setup**:
   - Edit the MCP server files
   - Add your own tools
   - Configure additional servers

## Support

If you encounter issues:

1. **Check the official documentation**: [https://docs.anthropic.com/claude/docs/claude-desktop](https://docs.anthropic.com/claude/docs/claude-desktop)
2. **Visit the community forums**: [https://community.anthropic.com](https://community.anthropic.com)
3. **Check GitHub issues**: [https://github.com/anthropics-ai/claude-desktop/issues](https://github.com/anthropics-ai/claude-desktop/issues)

## Resources

- [Claude Desktop Documentation](https://docs.anthropic.com/claude/docs/claude-desktop)
- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [Linux Package Management](https://help.ubuntu.com/community/PackageManager)
- [Snap Documentation](https://snapcraft.io/docs)
- [Flatpak Documentation](https://docs.flatpak.org/)