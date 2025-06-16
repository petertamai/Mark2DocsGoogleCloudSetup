# README.md
# Mark2Docs Google Cloud Setup

🚀 **One-click Google Cloud setup for Mark2Docs integration**

## Quick Start

Run this in [Google Cloud Shell](https://shell.cloud.google.com):

```bash
curl -s https://raw.githubusercontent.com/petertamai/Mark2DocsGoogleCloudSetup/main/setup.sh | bash
```

[![Open in Google Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/?cloudshell_git_repo=https://github.com/petertamai/Mark2DocsGoogleCloudSetup.git&cloudshell_working_dir=.&cloudshell_tutorial=tutorial.md)

## What This Does

✅ Creates a new Google Cloud project  
✅ Enables Google Docs API  
✅ Enables Google Drive API  
✅ Links billing account (if available)  
✅ Provides direct links to create OAuth credentials  

## Manual Steps Required

After running the script, you'll need to:

1. **Create OAuth Consent Screen** - The script provides the direct link
2. **Create OAuth Credentials** - Get your Client ID and Client Secret
3. **Add Test Users** - Add your email to use the app

## Files

- `setup.sh` - Main setup script
- `tutorial.md` - Step-by-step tutorial for Cloud Shell
- `cleanup.sh` - Script to remove created resources (optional)

## Requirements

- Google Cloud account
- Billing account enabled (for API usage)

## Security

This script only creates resources and enables APIs. It never accesses your credentials or data.

---

**Need help?** Open an issue or check the [Mark2Docs documentation](https://docs.mark2docs.com)

---

# tutorial.md
# Mark2Docs Google Cloud Setup Tutorial

This tutorial will guide you through setting up Google Cloud for Mark2Docs.

## Step 1: Run the Setup Script

```bash
./setup.sh
```

## Step 2: Follow the Interactive Prompts

The script will ask for:
- Project ID (or use the generated one)
- Redirect URI (use your Mark2Docs URL)

## Step 3: Complete Manual Setup

After the script finishes, you'll get direct links to:
1. OAuth Consent Screen setup
2. OAuth Credentials creation

## That's it! 

Copy your Client ID and Client Secret to Mark2Docs and you're ready to go!

---

# cleanup.sh (optional)
#!/bin/bash
# Cleanup script to remove Mark2Docs Google Cloud resources

echo "⚠️  This will DELETE your Mark2Docs Google Cloud project!"
read -p "Enter the project ID to delete: " PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
    echo "❌ No project ID provided"
    exit 1
fi

read -p "Are you sure you want to delete project $PROJECT_ID? (type 'DELETE' to confirm): " CONFIRM

if [ "$CONFIRM" = "DELETE" ]; then
    echo "🗑️ Deleting project $PROJECT_ID..."
    gcloud projects delete $PROJECT_ID --quiet
    echo "✅ Project deleted"
else
    echo "❌ Deletion cancelled"
fi
