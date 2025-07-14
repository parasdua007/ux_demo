# 🚀 Postman Integration with Cursor - Complete Guide

This guide provides a comprehensive walkthrough for integrating Postman with Cursor IDE for the Reltio Console API project.

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Installation](#installation)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Advanced Features](#advanced-features)
6. [Troubleshooting](#troubleshooting)
7. [Best Practices](#best-practices)

## ⚡ Quick Start

### 1. Run the Setup Script
```bash
chmod +x postman/scripts/setup-postman.sh
./postman/scripts/setup-postman.sh
```

### 2. Import Postman Collection
1. Open Postman
2. Click "Import"
3. Select `postman/Reltio-Console-API.postman_collection.json`

### 3. Import Environments
1. Click "Import" again
2. Select both environment files from `postman/environments/`

### 4. Test Your Setup
```bash
npm run test:api
```

## 🛠️ Installation

### Prerequisites
- **Node.js** (v12 or higher)
- **Postman** (Desktop app or web version)
- **Cursor IDE** (or VS Code)

### Install Postman
```bash
# Ubuntu/Debian
sudo snap install postman

# macOS
brew install --cask postman

# Windows
# Download from https://www.postman.com/downloads/
```

### Install Newman CLI
```bash
npm install -g newman
npm install -g newman-reporter-htmlextra
```

### Install VS Code Extensions
Install these extensions in Cursor for better integration:

1. **Postman** (`Postman.postman`)
   - Official Postman extension
   - Sync collections and environments
   - Send requests directly from Cursor

2. **REST Client** (`humao.rest-client`)
   - Send HTTP requests from `.http` files
   - Environment variable support
   - Response preview

3. **Thunder Client** (`rangav.vscode-thunder-client`)
   - Lightweight REST client
   - Collection management
   - Environment support

## 🔧 Setup

### 1. Environment Configuration

Update the environment variables with your actual credentials:

#### Development Environment
```json
{
  "base_url": "https://dev-api.reltio.com",
  "client_id": "your-dev-client-id",
  "client_secret": "your-dev-client-secret"
}
```

#### Production Environment
```json
{
  "base_url": "https://api.reltio.com",
  "client_id": "your-prod-client-id",
  "client_secret": "your-prod-client-secret"
}
```

### 2. VS Code Settings

The `.vscode/settings.json` file is already configured with:
- REST Client environment variables
- Thunder Client directories
- File associations for `.http` files
- Optimized workspace settings

### 3. Security Configuration

Create a `.env` file for sensitive data:
```bash
cp postman/environments/.env.template postman/environments/.env
# Edit the .env file with your actual credentials
```

## 📖 Usage

### Manual Testing with Postman

1. **Select Environment**
   - Choose "Development" or "Production" from the dropdown

2. **Authenticate**
   - Run "Get Access Token" from the Authentication folder
   - Token will be automatically saved to environment

3. **Test Endpoints**
   - Use any endpoint in the collection
   - Responses are automatically validated

### Automated Testing with Newman

#### Run All Tests
```bash
npm run test:api
```

#### Run Production Tests
```bash
npm run test:api:prod
```

#### Run Specific Test Categories
```bash
# Usage reporting only
npm run test:api:usage

# Using the test runner script
./postman/scripts/run-tests.sh --usage-only
./postman/scripts/run-tests.sh --auth-only
./postman/scripts/run-tests.sh --entitlements-only
```

#### Advanced Newman Options
```bash
# Run with custom parameters
./postman/scripts/run-tests.sh \
  --iterations 3 \
  --delay 1000 \
  --timeout 60000 \
  --reporters cli,junit,htmlextra
```

### REST Client Testing

Use the `api-tests.http` file for quick testing:

1. **Open the file** in Cursor
2. **Select environment** (dev/prod)
3. **Send requests** using `Ctrl+Alt+R` (or `Cmd+Alt+R` on Mac)

### Thunder Client Testing

1. **Open Thunder Client** in Cursor
2. **Import collection** from `postman/` directory
3. **Select environment** and start testing

## 🚀 Advanced Features

### 1. Pre-request Scripts

The collection includes automatic token refresh:
```javascript
// Check if token is expired and refresh if needed
const tokenExpires = pm.environment.get('token_expires');
if (tokenExpires && new Date().getTime() > parseInt(tokenExpires)) {
    // Automatically refresh token
}
```

### 2. Test Scripts

Each request includes validation tests:
```javascript
pm.test('Status code is 200', function () {
    pm.response.to.have.status(200);
});

pm.test('Response has required fields', function () {
    const response = pm.response.json();
    pm.expect(response).to.have.property('usage');
});
```

### 3. Environment Variables

Dynamic variables for flexible testing:
- `{{start_date}}` - Report start date
- `{{end_date}}` - Report end date
- `{{entitlement_type}}` - Filter by entitlement type
- `{{access_token}}` - Auto-populated bearer token

### 4. CI/CD Integration

#### GitHub Actions Example
```yaml
name: API Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '16'
      - run: npm install -g newman newman-reporter-htmlextra
      - run: npm run test:api
```

#### Jenkins Pipeline Example
```groovy
pipeline {
    agent any
    stages {
        stage('API Tests') {
            steps {
                sh 'npm install -g newman newman-reporter-htmlextra'
                sh 'npm run test:api'
            }
        }
    }
}
```

### 5. Custom Reporters

Generate different report formats:
```bash
# HTML report
newman run collection.json -r htmlextra

# JUnit report for CI
newman run collection.json -r junit

# JSON report
newman run collection.json -r json
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Authentication Failed
**Problem**: `401 Unauthorized` errors
**Solution**:
- Check `client_id` and `client_secret` in environment
- Verify OAuth endpoint URL
- Ensure credentials have proper permissions

#### 2. Token Expired
**Problem**: `401 Unauthorized` after successful auth
**Solution**:
- Run "Get Access Token" again
- Check token expiration time
- Verify token refresh logic in pre-request scripts

#### 3. Environment Not Loading
**Problem**: Variables showing as `{{variable_name}}`
**Solution**:
- Ensure environment file is properly imported
- Check environment variable names match exactly
- Verify JSON syntax in environment file

#### 4. Newman Not Found
**Problem**: `command not found: newman`
**Solution**:
```bash
npm install -g newman
npm install -g newman-reporter-htmlextra
```

#### 5. Permission Denied
**Problem**: Script execution fails
**Solution**:
```bash
chmod +x postman/scripts/*.sh
```

### Debug Mode

Enable debug logging in Postman:
1. Open Postman Console (`View → Show Postman Console`)
2. Check "Log requests" in Settings
3. Monitor network requests and responses

### Environment Debugging

Test environment variables:
```bash
# Check environment file syntax
cat postman/environments/Development.postman_environment.json | jq .

# Validate collection syntax
cat postman/Reltio-Console-API.postman_collection.json | jq .
```

## 📋 Best Practices

### 1. Security
- ✅ Never commit real credentials to version control
- ✅ Use environment variables for sensitive data
- ✅ Rotate API keys regularly
- ✅ Use different credentials for dev/staging/prod
- ✅ Enable 2FA on your Postman account

### 2. Organization
- ✅ Group related requests in folders
- ✅ Use descriptive request names
- ✅ Add comments to complex requests
- ✅ Keep environments organized by purpose

### 3. Testing
- ✅ Write comprehensive test scripts
- ✅ Test both success and error scenarios
- ✅ Validate response structure and data types
- ✅ Test edge cases and boundary conditions

### 4. Maintenance
- ✅ Keep collections updated with API changes
- ✅ Document new endpoints and changes
- ✅ Review and update test data regularly
- ✅ Monitor test execution times

### 5. Collaboration
- ✅ Share collections with team members
- ✅ Use Postman workspaces for team collaboration
- ✅ Document API changes in collection descriptions
- ✅ Use version control for collection changes

## 📊 Monitoring and Analytics

### Test Metrics
Track test performance and reliability:
- Test execution time
- Success/failure rates
- Response time trends
- Error patterns

### Report Analysis
Review generated reports for:
- API performance trends
- Error rate analysis
- Response time optimization opportunities
- Test coverage gaps

## 🔄 Updates and Maintenance

### Updating Collections
1. Export updated collection from Postman
2. Replace `Reltio-Console-API.postman_collection.json`
3. Update this documentation if needed
4. Commit changes to version control

### Adding New Endpoints
1. Create new request in Postman
2. Add appropriate test scripts
3. Update collection file
4. Test with Newman
5. Update documentation

### Environment Updates
1. Update environment variables as needed
2. Test with both development and production
3. Update team members about changes
4. Document any breaking changes

---

## 🎉 Success!

You now have a fully integrated Postman setup with Cursor that includes:

- ✅ Complete API collection with all endpoints
- ✅ Environment configurations for dev/prod
- ✅ Automated testing with Newman CLI
- ✅ REST Client integration for quick testing
- ✅ VS Code extensions for seamless workflow
- ✅ CI/CD integration examples
- ✅ Comprehensive documentation

**Happy API Testing! 🚀**

For additional support:
- Check the `postman/README.md` for detailed setup instructions
- Review the example responses in `postman/examples/`
- Use the troubleshooting section for common issues
- Refer to the Newman documentation for advanced features