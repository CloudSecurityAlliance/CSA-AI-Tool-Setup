# iCloud for Windows Setup Guide

iCloud for Windows enables seamless integration between Windows PCs and Apple's cloud services. This is particularly important for syncing Obsidian vaults and other files across devices.

## System Requirements

- Windows 10 or newer
- Microsoft Edge WebView2 Runtime (included in recent Windows updates)
- An Apple ID
- At least 1GB of RAM (recommended: 2GB or more)
- Sufficient storage space for synced content

For complete requirements, see [Apple's system requirements guide](https://support.apple.com/guide/icloud-windows/system-requirements-icw30cde6814/icloud).

## Download and Installation

You can install iCloud for Windows in two ways:

### Microsoft Store (Recommended)
1. Open the Microsoft Store on your PC
2. Search for "iCloud"
3. Click "Get" or visit [iCloud in Microsoft Store](ms-windows-store://pdp/?productid=9PKTQ5699M62)
4. Follow the installation prompts

### Direct Download
1. Visit [Apple's iCloud for Windows download page](https://support.apple.com/en-us/HT204283)
2. Click the download link
3. Run the installer
4. Follow the installation prompts

## Initial Setup

1. After installation, launch iCloud for Windows
2. Sign in with your Apple ID
3. Choose which features to enable:
   - iCloud Drive (required for Obsidian sync)
   - Photos (optional)
   - Passwords (optional)
   - Mail, Contacts, Calendars (optional)
   - Bookmarks (optional)

## Essential Configuration

### iCloud Drive Setup
1. Open iCloud for Windows
2. Ensure iCloud Drive is enabled
3. Click "Options" next to iCloud Drive
4. Select folders to sync
5. Click "Done"

### File Access
- iCloud Drive appears in File Explorer under Quick access
- Default location: `C:\\Users\\[YourUsername]\\iCloud Drive`
- Files are downloaded on-demand to save space

### Sync Settings
1. Right-click on folders for sync options:
   - "Always keep on this device"
   - "Free up space"
   - "Share"
2. Status icons indicate sync state:
   - Cloud: Available for download
   - Green checkmark: Downloaded locally
   - Sync arrows: Currently syncing

## Optimizing for Obsidian

1. Create an Obsidian vault folder in iCloud Drive
2. Set this folder to "Always keep on this device"
3. Configure Obsidian to use this location
4. Wait for initial sync to complete before opening in Obsidian

## Common Issues and Solutions

### Sign-in Problems
- Ensure your Apple ID two-factor authentication is set up
- Check your internet connection
- Try signing out and back in

### Sync Issues
- Verify internet connection
- Check available storage (both Windows and iCloud)
- Ensure the latest version is installed
- Restart the iCloud application

### Space Management
- Use "Free up space" for non-essential files
- Regular cleanup of unnecessary files
- Monitor iCloud storage usage

## Additional Resources

- [Official iCloud for Windows User Guide](https://support.apple.com/guide/icloud-windows/welcome/icloud)
- [iCloud Support Page](https://support.apple.com/icloud)
- [Manage iCloud Storage](https://support.apple.com/en-us/HT204247)

## Next Steps

After setting up iCloud for Windows:
1. Configure your Obsidian vault location
2. Test sync functionality
3. Set up automatic backups
4. Configure other desired iCloud features