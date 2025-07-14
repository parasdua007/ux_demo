#!/bin/bash

# 🚀 Postman Integration Setup Script
# This script sets up Postman integration with Cursor for the Reltio Console API

set -e

echo "🚀 Setting up Postman Integration with Cursor..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Create necessary directories
print_status "Creating Postman directory structure..."
mkdir -p postman/scripts
mkdir -p postman/environments
mkdir -p postman/examples/sample-responses
mkdir -p postman/examples/test-data

# Check if Postman is installed
print_status "Checking Postman installation..."
if command -v postman &> /dev/null; then
    print_success "Postman is already installed"
elif command -v snap &> /dev/null && snap list | grep -q postman; then
    print_success "Postman is installed via snap"
else
    print_warning "Postman not found. Please install Postman manually:"
    echo "  Ubuntu/Debian: sudo snap install postman"
    echo "  macOS: brew install --cask postman"
    echo "  Windows: Download from https://www.postman.com/downloads/"
fi

# Install Newman CLI if Node.js is available
if command -v node &> /dev/null; then
    print_status "Installing Newman CLI for automated testing..."
    if command -v newman &> /dev/null; then
        print_success "Newman CLI is already installed"
    else
        npm install -g newman
        print_success "Newman CLI installed successfully"
    fi
    
    # Install Newman HTML reporter
    if npm list -g newman-reporter-htmlextra &> /dev/null; then
        print_success "Newman HTML reporter is already installed"
    else
        npm install -g newman-reporter-htmlextra
        print_success "Newman HTML reporter installed successfully"
    fi
else
    print_warning "Node.js not found. Newman CLI installation skipped."
    print_warning "Install Node.js to enable automated testing with Newman."
fi

# Check for VS Code extensions
print_status "Checking for recommended VS Code extensions..."
if command -v code &> /dev/null; then
    # Install recommended extensions
    extensions=(
        "Postman.postman"
        "humao.rest-client"
        "rangav.vscode-thunder-client"
    )
    
    for extension in "${extensions[@]}"; do
        if code --list-extensions | grep -q "$extension"; then
            print_success "Extension $extension is already installed"
        else
            print_status "Installing extension: $extension"
            code --install-extension "$extension"
        fi
    done
else
    print_warning "VS Code CLI not found. Please install extensions manually:"
    echo "  - Postman (Postman.postman)"
    echo "  - REST Client (humao.rest-client)"
    echo "  - Thunder Client (rangav.vscode-thunder-client)"
fi

# Create environment template
print_status "Creating environment template..."
cat > postman/environments/.env.template << 'EOF'
# Copy this file to .env and fill in your actual values
BASE_URL=https://api.reltio.com
CLIENT_ID=your-client-id
CLIENT_SECRET=your-client-secret
EOF

# Create VS Code settings for Postman integration
print_status "Creating VS Code settings..."
mkdir -p .vscode
cat > .vscode/settings.json << 'EOF'
{
    "rest-client.environmentVariables": {
        "$shared": {
            "version": "1.0"
        },
        "development": {
            "base_url": "https://dev-api.reltio.com",
            "client_id": "your-dev-client-id",
            "client_secret": "your-dev-client-secret"
        },
        "production": {
            "base_url": "https://api.reltio.com",
            "client_id": "your-prod-client-id",
            "client_secret": "your-prod-client-secret"
        }
    },
    "rest-client.defaultHeaders": {
        "Content-Type": "application/json",
        "User-Agent": "Reltio-Console-API/1.0"
    },
    "thunder-client.collectionsDir": "./postman/collections",
    "thunder-client.environmentDir": "./postman/environments"
}
EOF

# Create sample REST client file
print_status "Creating sample REST client file..."
cat > api-tests.http << 'EOF'
### Reltio Console API Tests
### This file can be used with REST Client extension

@base_url = https://api.reltio.com
@client_id = your-client-id
@client_secret = your-client-secret

### Get Access Token
# @name auth
POST {{base_url}}/oauth/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&client_id={{client_id}}&client_secret={{client_secret}}

### Get Usage Summary
# @name usage_summary
GET {{base_url}}/api/v1/usage/summary?start_date=2024-01-01&end_date=2024-12-31
Authorization: Bearer {{auth.response.body.access_token}}
Content-Type: application/json

### Get Entitlements
# @name entitlements
GET {{base_url}}/api/v1/entitlements
Authorization: Bearer {{auth.response.body.access_token}}
Content-Type: application/json
EOF

# Create package.json scripts for Newman
print_status "Adding Newman scripts to package.json..."
if [ -f "package.json" ]; then
    # Check if scripts section exists
    if grep -q '"scripts"' package.json; then
        # Add Newman scripts to existing scripts section
        sed -i '/"scripts": {/a\
    "test:api": "newman run postman/Reltio-Console-API.postman_collection.json -e postman/environments/Development.postman_environment.json --reporters cli,htmlextra",\
    "test:api:prod": "newman run postman/Reltio-Console-API.postman_collection.json -e postman/environments/Production.postman_environment.json --reporters cli,htmlextra",\
    "test:api:usage": "newman run postman/Reltio-Console-API.postman_collection.json -e postman/environments/Development.postman_environment.json --folder \"Usage Reporting\" --reporters cli",\
    "postman:setup": "echo \"Postman setup complete. Import collection and environments from postman/ directory\""' package.json
    else
        print_warning "No scripts section found in package.json. Please add Newman scripts manually."
    fi
fi

# Create .gitignore entries
print_status "Updating .gitignore..."
if [ -f ".gitignore" ]; then
    # Add Postman-specific entries if they don't exist
    if ! grep -q "postman/environments/.env" .gitignore; then
        echo "" >> .gitignore
        echo "# Postman" >> .gitignore
        echo "postman/environments/.env" >> .gitignore
        echo "postman/examples/test-data/*.json" >> .gitignore
        echo "newman-reports/" >> .gitignore
    fi
else
    cat > .gitignore << 'EOF'
# Postman
postman/environments/.env
postman/examples/test-data/*.json
newman-reports/
EOF
fi

# Make scripts executable
chmod +x postman/scripts/*.sh

print_success "🎉 Postman integration setup complete!"
echo ""
print_status "Next steps:"
echo "1. Install Postman if not already installed"
echo "2. Import the collection: postman/Reltio-Console-API.postman_collection.json"
echo "3. Import environments: postman/environments/*.postman_environment.json"
echo "4. Update environment variables with your actual credentials"
echo "5. Install recommended VS Code extensions for better integration"
echo ""
print_status "Available commands:"
echo "  npm run test:api          - Run API tests with Newman"
echo "  npm run test:api:prod     - Run API tests against production"
echo "  npm run test:api:usage    - Run usage reporting tests only"
echo ""
print_success "Happy API testing! 🚀"