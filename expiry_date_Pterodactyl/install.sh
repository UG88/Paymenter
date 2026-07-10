#!/bin/bash

# Paymenter Pterodactyl Server Expiry Sync Installer
# Created by UNTILGHAMER (UG88)

PAYMENTER_PATH="/var/www/paymenter"
EXTENSION_PATH="$PAYMENTER_PATH/app/Extensions/Servers/Pterodactyl/Pterodactyl.php"

echo "========================================================="
echo "  Paymenter Pterodactyl Server Expiry Sync Installer"
echo "========================================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script with sudo or as root."
  exit 1
fi

# Detect Paymenter directory
if [ ! -f "$EXTENSION_PATH" ]; then
    echo "Could not find Pterodactyl.php at standard path: $EXTENSION_PATH"
    read -p "Please enter your absolute Paymenter folder path (e.g., /var/www/paymenter): " custom_path
    # Remove trailing slash if present
    PAYMENTER_PATH=$(echo "$custom_path" | sed 's/\/$//')
    EXTENSION_PATH="$PAYMENTER_PATH/app/Extensions/Servers/Pterodactyl/Pterodactyl.php"
    
    if [ ! -f "$EXTENSION_PATH" ]; then
        echo "Error: Could not locate Pterodactyl.php at $EXTENSION_PATH. Aborting."
        exit 1
    fi
fi

# Backup original file
echo "Creating backup: Pterodactyl.php.bak..."
cp "$EXTENSION_PATH" "$EXTENSION_PATH.bak"

# Download patched version from repository
DOWNLOAD_URL="https://raw.githubusercontent.com/UG88/Paymenter/main/expiry_date_Pterodactyl/Pterodactyl/Pterodactyl.php"

echo "Downloading patched extension file..."
curl -sS -o "$EXTENSION_PATH" "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
    # Auto-detect file ownership based on artisan executable
    OWNER=$(stat -c '%U:%G' "$PAYMENTER_PATH/artisan" 2>/dev/null || echo "www-data:www-data")
    chown "$OWNER" "$EXTENSION_PATH"
    chmod 644 "$EXTENSION_PATH"
    
    echo "========================================================="
    echo "  Installation Successful!"
    echo "========================================================="
    echo "1. Go to your Paymenter Admin Dashboard -> Products -> Edit Product."
    echo "2. Go to the 'Server' tab and locate 'Server Expiry API Parameter'."
    echo "3. Enter your Pterodactyl addon variable (e.g., 'exp_date')."
    echo "4. Save settings and enjoy automated expiration syncing!"
else
    echo "Error: Failed to download the patched file. Restoring original from backup..."
    mv "$EXTENSION_PATH.bak" "$EXTENSION_PATH"
    exit 1
fi
