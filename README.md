# Paymenter to Pterodactyl Server Expiry Sync Extension

A custom Paymenter server extension patch that automatically syncs the billing service expiration date (`expires_at`) directly to your Pterodactyl panel's custom **Server Expiry Date** field (added by third-party server expiry addons). 

Mainly focused and optimized for **Hyper V1** users to sync VM and server expiration dates seamlessly.

Created by **UNTILGHAMER (UG88)**.

---

## 🚀 Features

- **Automated Sync**: Automatically pushes the service expiration date upon server creation.
- **Renewal & Upgrade Sync**: Keeps the expiration date updated in Pterodactyl during package upgrades or invoice renewals.
- **Custom Parameter Key**: Fully configurable API key parameter (e.g., `exp_date`, `expiry_date`, `expires_at`) matching your specific Pterodactyl addon.
- **Graceful Fallback**: Safely ignores sync if left blank, ensuring compatibility with standard eggs/products.

---

## ⚙️ How It Works

1. Paymenter calculates the service's expiration date based on the user's billing cycle (e.g., today + 1 month) upon successful checkout/renewal.
2. The extension formats this date to `YYYY-MM-DD HH:MM:SS` (or `null` if there is no expiry).
3. The extension attaches this formatted date to the Pterodactyl server creation API request under the parameter key you define.
4. Pterodactyl's Server Expiry addon grabs the parameter and applies it directly to the server.

---

## 📦 Easy Installation

To install this custom extension on your Paymenter server, run the following one-liner command in your terminal as `root` or using `sudo`:

```bash
curl -sSL https://raw.githubusercontent.com/UG88/Paymenter/main/expiry_date_Pterodactyl/install.sh | sudo bash
```

*This script will safely backup your original `Pterodactyl.php` file (to `Pterodactyl.php.bak`) and replace it with this patched version.*

---

## 🔧 Configuration Guide

### 1. Identify Your Addon's API Parameter Key
Find the HTML input parameter key for the expiry date field in Pterodactyl. For example, if you inspect the "Server Expiry Date" input in your Pterodactyl Admin Panel under Server Details, you might see:
```html
<input type="datetime-local" name="exp_date" class="form-control">
```
Here, the parameter key is **`exp_date`**.

### 2. Set Up Paymenter Product Settings
1. Go to your **Paymenter Admin Panel** -> **Products** -> Edit your product.
2. Open the **Server** tab.
3. Scroll to the bottom and locate the **Server Expiry API Parameter** field.
4. Type your parameter key: **`exp_date`** (or your specific key).
5. Click **Save**.

### Example Configuration:
Below is an example of how your product's server configuration page should look:

![Product Server Config](https://raw.githubusercontent.com/UG88/Paymenter/main/example.png)
