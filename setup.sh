#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DEFAULT_PROJECT_ID="mark2docs-$(date +%s)"
DEFAULT_REDIRECT_URI="http://localhost:3000/api/google/callback"

echo -e "${BLUE}🚀 Mark2Docs Google Cloud Setup${NC}"
echo "=================================="

read -p "Enter project ID (default: $DEFAULT_PROJECT_ID): " PROJECT_ID
PROJECT_ID=${PROJECT_ID:-$DEFAULT_PROJECT_ID}

read -p "Enter redirect URI (default: $DEFAULT_REDIRECT_URI): " REDIRECT_URI
REDIRECT_URI=${REDIRECT_URI:-$DEFAULT_REDIRECT_URI}

echo -e "${YELLOW}📝 Configuration:${NC}"
echo "   Project ID: $PROJECT_ID"
echo "   Redirect URI: $REDIRECT_URI"
echo ""

read -p "Continue with setup? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Setup cancelled${NC}"
    exit 1
fi

echo -e "${BLUE}1️⃣ Creating Google Cloud project...${NC}"
if gcloud projects create $PROJECT_ID --name="Mark2Docs Integration" 2>/dev/null; then
    echo -e "${GREEN}✅ Project created successfully${NC}"
else
    echo -e "${YELLOW}⚠️  Project might already exist, continuing...${NC}"
fi

echo -e "${BLUE}2️⃣ Setting active project...${NC}"
gcloud config set project $PROJECT_ID
echo -e "${GREEN}✅ Active project set${NC}"

echo -e "${BLUE}3️⃣ Enabling required APIs...${NC}"
echo "   - Google Docs API"
gcloud services enable docs.googleapis.com --quiet
echo "   - Google Drive API"
gcloud services enable drive.googleapis.com --quiet
echo -e "${GREEN}✅ APIs enabled${NC}"

echo -e "${BLUE}4️⃣ Checking billing account...${NC}"
BILLING_ACCOUNT=$(gcloud billing accounts list --format="value(name)" --limit=1 2>/dev/null || echo "")
if [ ! -z "$BILLING_ACCOUNT" ]; then
    echo "   Found billing account: $BILLING_ACCOUNT"
    if gcloud billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT 2>/dev/null; then
        echo -e "${GREEN}✅ Billing linked${NC}"
    else
        echo -e "${YELLOW}⚠️  Billing might already be linked${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No billing account found. You'll need to enable billing manually.${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Automated setup complete!${NC}"
echo ""
echo -e "${YELLOW}📋 MANUAL STEPS REQUIRED:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${BLUE}Step 1: Create OAuth Consent Screen${NC}"
echo "🌐 URL: https://console.cloud.google.com/apis/credentials/consent?project=$PROJECT_ID"
echo "   - Choose 'External' user type"
echo "   - Fill in app name: 'Mark2Docs'"
echo "   - Add your email as support contact"
echo "   - Add test users (your email)"
echo ""
echo -e "${BLUE}Step 2: Create OAuth Credentials${NC}"
echo "🌐 URL: https://console.cloud.google.com/apis/credentials?project=$PROJECT_ID"
echo "   - Click 'Create Credentials' → 'OAuth 2.0 Client IDs'"
echo "   - Application type: 'Web application'"
echo "   - Name: 'Mark2Docs Client'"
echo "   - Authorized redirect URIs: $REDIRECT_URI"
echo ""
echo -e "${BLUE}Step 3: Copy Credentials${NC}"
echo "   - Copy the Client ID and Client Secret"
echo "   - Paste them into your Mark2Docs dashboard"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}🔗 Quick Links:${NC}"
echo "   Consent Screen: https://console.cloud.google.com/apis/credentials/consent?project=$PROJECT_ID"
echo "   Credentials:    https://console.cloud.google.com/apis/credentials?project=$PROJECT_ID"
echo "   Project Overview: https://console.cloud.google.com/home/dashboard?project=$PROJECT_ID"
echo ""
echo -e "${BLUE}💡 Need help? Check the Mark2Docs documentation or tutorial.${NC}"
