#!/bin/bash

# deploy.sh - Script to deploy your 52-book challenge to GitHub Pages

echo "📚 Setting up and deploying 52-Book Challenge to GitHub Pages..."

# Check if we're in a git repository, if not initialize it
if [ ! -d .git ]; then
    echo "🔧 Initializing git repository..."
    git init
    git branch -M main
    git remote add origin https://github.com/shaansen/52-book-challenge.git
fi

# Create .github/workflows directory if it doesn't exist
mkdir -p .github/workflows

# Create the workflow file
cat > .github/workflows/deploy.yml << 'WORKFLOWEOF'
name: Deploy to GitHub Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Pages
        uses: actions/configure-pages@v4
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
      
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
WORKFLOWEOF

echo "✅ Created GitHub Actions workflow file"

# Make sure index.html exists
if [ ! -f index.html ]; then
    echo "⚠️  Warning: index.html not found in current directory"
    echo "Please make sure your HTML file is named 'index.html'"
    exit 1
fi

# Add all files
git add .

# Commit changes
git commit -m "Add GitHub Pages deployment workflow and website files"

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✨ Deployment initiated!"
echo "📍 Your site will be available at: https://shaansen.github.io/52-book-challenge/"
echo ""
echo "⏱️  It may take a few minutes for the site to go live."
echo "Check the Actions tab in your GitHub repo to monitor the deployment."