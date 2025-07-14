#!/bin/bash

# Simple GitHub Pages deployment script
echo "🚀 Deploying to GitHub Pages..."

# Create and switch to gh-pages branch
git checkout --orphan gh-pages

# Remove all files except the ones we need
git rm -rf .github/
git rm -rf .git/
git rm -f start-demo.sh start-demo.bat package.json DEMO-SETUP.md

# Add the files we want to deploy
git add index.html final-entitlement-summary.html README.md

# Commit the changes
git commit -m "Deploy to GitHub Pages"

# Push to gh-pages branch
git push origin gh-pages --force

# Switch back to main branch
git checkout main

echo "✅ Deployment complete!"
echo "🌐 Your site should be available at: file:///Users/parasdua/Documents/updatedux-entitlement.html"
echo ""
echo "📋 Next steps:"
echo "1. Go to https://github.com/parasdua007/ux_demo/settings/pages"
echo "2. Under 'Source', select 'Deploy from a branch'"
echo "3. Select 'gh-pages' branch and '/ (root)' folder"
echo "4. Click 'Save'"