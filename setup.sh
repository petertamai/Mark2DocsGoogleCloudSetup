#!/bin/bash
set -e

echo "🚀 Mark2Docs Google Cloud Setup"
echo "=================================="

DEFAULT_PROJECT_ID="mark2docs-$(date +%s)"
DEFAULT_REDIRECT_URI="http://localhost:3000/api/google/callback"

read -p "Enter project ID (default: $DEFAULT_PROJECT_ID): " PROJECT_ID
PROJECT_ID=${PROJECT_ID:-$DEFAULT_PROJECT_ID}

read -p "Enter redirect URI (default: $DEFAULT_REDIRECT_URI): " REDIRECT_URI
REDIRECT_URI=${REDIRECT_URI:-$DEFAULT_REDIRECT_URI}

echo "📝 Configuration:"
echo "   Project ID: $PROJECT_ID"
echo "   Redirect URI: $REDIRECT_URI"
echo ""

read -p "Continue with setup? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Setup cancelled"
    exit 1
fi

echo "1️⃣ Creating Google Cloud project..."
if gcloud projects create $PROJECT_ID --name="Mark2Docs Integration" 2>/dev/null; then
    echo "✅ Project created successfully"
else
    echo "⚠️  Project might already exist, continuing..."
fi

echo "2️⃣ Setting active project..."
gcloud config set project $PROJECT_ID
echo "✅ Active project set"

echo "3️⃣ Enabling required APIs..."
echo "   - Google Docs API"
gcloud services enable docs.googleapis.com --quiet
echo "   - Google Drive API"
gcloud services enable drive.googleapis.com --quiet
echo "✅ APIs enabled"

echo "4️⃣ Checking billing account..."
BILLING_ACCOUNT=$(gcloud billing accounts list --format="value(name)" --limit=1 2>/dev/null || echo "")
if [ ! -z "$BILLING_ACCOUNT" ]; then
    echo "   Found billing account: $BILLING_ACCOUNT"
    if gcloud billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT 2>/dev/null; then
        echo "✅ Billing linked"
    else
        echo "⚠️  Billing might already be linked"
    fi
else
    echo "⚠️  No billing account found. You'll need to enable billing manually."
fi

echo ""
echo "🎉 Automated setup complete!"
echo ""
echo "📋 MANUAL STEPS REQUIRED:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Step 1: Create OAuth Consent Screen"
echo "🌐 URL: https://console.cloud.google.com/apis/credentials/consent?project=$PROJECT_ID"
echo "   - Choose 'External' user type"
echo "   - Fill in app name: 'Mark2Docs'"
echo "   - Add your email as support contact"
echo "   - Add test users (your email)"
echo ""
echo "Step 2: Create OAuth Credentials"
echo "🌐 URL: https://console.cloud.google.com/apis/credentials?project=$PROJECT_ID"
echo "   - Click 'Create Credentials' → 'OAuth 2.0 Client IDs'"
echo "   - Application type: 'Web application'"
echo "   - Name: 'Mark2Docs Client'"
echo "   - Authorized redirect URIs: $REDIRECT_URI"
echo ""
echo "Step 3: Copy Credentials"
echo "   - Copy the Client ID and Client Secret"
echo "   - Paste them into your Mark2Docs dashboard"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔗 Quick Links:"
echo "   Consent Screen: https://console.cloud.google.com/apis/credentials/consent?project=$PROJECT_ID"
echo "   Credentials:    https://console.cloud.google.com/apis/credentials?project=$PROJECT_ID"
echo "   Project Overview: https://console.cloud.google.com/home/dashboard?project=$PROJECT_ID"
echo ""
echo "💡 Need help? Check the Mark2Docs documentation or tutorial."
