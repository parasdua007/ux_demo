# 🚀 Postman Integration with Cursor

This directory contains the complete Postman integration setup for the Reltio Console API, designed to work seamlessly with Cursor IDE.

## 📁 Directory Structure

```
postman/
├── Reltio-Console-API.postman_collection.json  # Main API collection
├── environments/                                # Environment configurations
│   ├── Development.postman_environment.json
│   └── Production.postman_environment.json
├── scripts/                                     # Utility scripts
│   ├── setup-postman.sh
│   └── run-tests.sh
├── examples/                                    # Example responses and data
│   ├── sample-responses/
│   └── test-data/
└── README.md                                    # This file
```

## 🛠️ Setup Instructions

### 1. Install Postman

If you haven't installed Postman yet:

```bash
# On Ubuntu/Debian
sudo snap install postman

# On macOS
brew install --cask postman

# On Windows
# Download from https://www.postman.com/downloads/
```

### 2. Import Collection and Environments

1. **Open Postman**
2. **Import Collection:**
   - Click "Import" button
   - Select `Reltio-Console-API.postman_collection.json`
   - The collection will be imported with all endpoints

3. **Import Environments:**
   - Click "Import" button
   - Select both environment files from `environments/` folder
   - Switch between environments using the dropdown in the top-right

### 3. Configure Environment Variables

Update the environment variables with your actual credentials:

#### Development Environment
- `client_id`: Your development client ID
- `client_secret`: Your development client secret
- `base_url`: Development API URL

#### Production Environment
- `client_id`: Your production client ID
- `client_secret`: Your production client secret
- `base_url`: Production API URL

## 🔧 Cursor Integration

### 1. Install Postman CLI (Optional)

For advanced integration with Cursor:

```bash
# Install Newman (Postman CLI)
npm install -g newman

# Install Newman HTML Reporter
npm install -g newman-reporter-htmlextra
```

### 2. VS Code Extensions

Install these extensions in Cursor for better Postman integration:

- **Postman** - Official Postman extension
- **REST Client** - Alternative REST client
- **Thunder Client** - Lightweight REST client

### 3. Quick Start Scripts

Run the setup script to configure everything:

```bash
chmod +x postman/scripts/setup-postman.sh
./postman/scripts/setup-postman.sh
```

## 📋 Available Endpoints

### Authentication
- **Get Access Token** - OAuth2 client credentials flow

### Usage Reporting
- **Get Usage Summary** - Retrieve usage summary data
- **Get Detailed Usage** - Get detailed usage breakdown

### Entitlements
- **Get Entitlements** - List all entitlements
- **Update Entitlement** - Modify entitlement limits

### Reports
- **Generate Usage Report** - Create downloadable reports

## 🧪 Testing

### Manual Testing
1. Select the appropriate environment
2. Run "Get Access Token" first to authenticate
3. Test other endpoints as needed

### Automated Testing
Run the test suite:

```bash
chmod +x postman/scripts/run-tests.sh
./postman/scripts/run-tests.sh
```

### Newman CLI Testing
```bash
# Run collection with development environment
newman run postman/Reltio-Console-API.postman_collection.json \
  -e postman/environments/Development.postman_environment.json \
  --reporters cli,htmlextra

# Run specific folder
newman run postman/Reltio-Console-API.postman_collection.json \
  -e postman/environments/Development.postman_environment.json \
  --folder "Usage Reporting"
```

## 🔐 Security Best Practices

1. **Never commit real credentials** to version control
2. **Use environment variables** for sensitive data
3. **Rotate API keys** regularly
4. **Use different credentials** for dev/staging/prod
5. **Enable 2FA** on your Postman account

## 📊 Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `base_url` | API base URL | `https://api.reltio.com` |
| `client_id` | OAuth client ID | `your-client-id` |
| `client_secret` | OAuth client secret | `your-client-secret` |
| `access_token` | Bearer token (auto-populated) | `eyJ...` |
| `token_expires` | Token expiration (auto-populated) | `1640995200000` |
| `start_date` | Report start date | `2024-01-01` |
| `end_date` | Report end date | `2024-12-31` |
| `entitlement_type` | Filter by entitlement type | `all` |
| `entitlement_id` | Specific entitlement ID | `ent-123` |
| `new_limit` | New entitlement limit | `1000` |
| `report_type` | Type of report to generate | `usage_summary` |
| `format` | Report format | `json` |
| `include_details` | Include detailed data | `true` |

## 🚀 Workflow Integration

### Development Workflow
1. **Start development** in Cursor
2. **Test APIs** using Postman collection
3. **Debug responses** with Postman console
4. **Share results** with team via Postman

### CI/CD Integration
```yaml
# Example GitHub Actions workflow
- name: API Tests
  run: |
    newman run postman/Reltio-Console-API.postman_collection.json \
      -e postman/environments/Development.postman_environment.json \
      --reporters cli,junit
```

## 🐛 Troubleshooting

### Common Issues

1. **Authentication Failed**
   - Check `client_id` and `client_secret`
   - Verify OAuth endpoint URL
   - Ensure credentials have proper permissions

2. **Token Expired**
   - Run "Get Access Token" again
   - Check token expiration time
   - Verify token refresh logic

3. **Environment Not Loading**
   - Ensure environment file is properly imported
   - Check environment variable names
   - Verify JSON syntax

### Debug Mode
Enable debug logging in Postman:
1. Open Postman Console (View → Show Postman Console)
2. Check "Log requests" in Settings
3. Monitor network requests and responses

## 📞 Support

For issues with:
- **Postman Collection**: Check the collection documentation
- **API Endpoints**: Contact Reltio API support
- **Cursor Integration**: Check VS Code extension documentation

## 🔄 Updates

To update the collection:
1. Export updated collection from Postman
2. Replace `Reltio-Console-API.postman_collection.json`
3. Update this README if needed
4. Commit changes to version control

---

**Happy API Testing! 🎉**