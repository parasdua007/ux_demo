# 🚀 Reltio Console UX Demo - Setup Guide

## Overview
This repository contains a complete, self-contained UX demo for the Reltio Console Usage Reporting interface. The demo is designed to be easily accessible by anyone on any machine.

## 📁 Files Included

- `final-entitlement-summary.html` - Main demo file (self-contained)
- `index.html` - Landing page with auto-redirect
- `README.md` - Comprehensive documentation
- `start-demo.sh` - Linux/Mac startup script
- `start-demo.bat` - Windows startup script
- `package.json` - Node.js configuration
- `DEMO-SETUP.md` - This setup guide

## 🎯 Quick Start Options

### Option 1: Direct Browser Opening (Easiest)
1. Download all files to your computer
2. Double-click `final-entitlement-summary.html`
3. The demo opens in your default browser

### Option 2: Using Startup Scripts

#### On Linux/Mac:
```bash
chmod +x start-demo.sh
./start-demo.sh
```

#### On Windows:
```cmd
start-demo.bat
```

### Option 3: Using Node.js
```bash
npm install
npm start
```

### Option 4: Using Python
```bash
python -m http.server 8000
# Then open http://localhost:8000
```

### Option 5: Using PHP
```bash
php -S localhost:8000
# Then open http://localhost:8000
```

## 🌟 Demo Features

### Interactive Elements
- **Navigation Tabs**: Switch between different sections
- **Date Range Filter**: Interactive dropdown with custom date selection
- **Usage Indicators**: Color-coded percentages (Green/Yellow/Orange/Red)
- **Responsive Design**: Works on desktop, tablet, and mobile

### Color Coding System
- 🟢 **Green** (< 80%): Normal usage
- 🟡 **Yellow** (80-90%): Warning level
- 🟠 **Orange** (90.01-99.99%): High usage
- 🔴 **Red** (≥ 100%): Critical usage

## 🔧 Technical Requirements

### Minimum Requirements
- Modern web browser (Chrome, Firefox, Safari, Edge)
- JavaScript enabled
- No internet connection required

### Optional (for local server)
- Python 3.x or Python 2.x
- Node.js 12+
- PHP 7+

## 📱 Browser Compatibility

| Browser | Version | Status |
|---------|---------|--------|
| Chrome | 60+ | ✅ Full Support |
| Firefox | 55+ | ✅ Full Support |
| Safari | 12+ | ✅ Full Support |
| Edge | 79+ | ✅ Full Support |
| IE | 11 | ⚠️ Limited Support |

## 🚨 Troubleshooting

### Demo won't load
1. Check if JavaScript is enabled
2. Try refreshing the page (Ctrl+F5)
3. Clear browser cache
4. Try a different browser

### Local server issues
1. Check if port 8000 is available
2. Ensure firewall allows local connections
3. Try a different port: `python -m http.server 8080`

### Mobile issues
1. Ensure responsive design is working
2. Check viewport meta tag
3. Test on different screen sizes

## 📊 Demo Content

The demo showcases:
- Usage reporting dashboard
- Contract entitlement tracking
- Interactive data tables
- Modern UI/UX patterns
- Responsive design principles

## 🔒 Security Notes

- Demo runs entirely in the browser
- No data is sent to external servers
- All data is static and for demonstration purposes
- Safe to run on any machine

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Ensure you're using a modern browser
3. Try opening the HTML file directly
4. Verify all files are downloaded correctly

## 🎉 Success!

Once running, you should see:
- A modern, professional interface
- Interactive navigation
- Color-coded usage indicators
- Responsive design that adapts to screen size
- Smooth animations and transitions

The demo is now ready for presentation, testing, or development reference!