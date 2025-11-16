#!/bin/bash
set -e

# Synergy Campaign Launcher - Proton GE PSS Installer
# Installs pre-patched Proton GE for SC2 Campaign Launcher compatibility

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STEAM_COMPAT_DIR="$HOME/.steam/compatibilitytools.d"
PROTON_NAME="GE-Proton-PSS-Patched"
ARCHIVE="$SCRIPT_DIR/$PROTON_NAME.tar.gz"

echo "=== Synergy Campaign Launcher - Proton GE PSS Installer ==="
echo ""

# check if steam compatibility tools directory exists
if [ ! -d "$HOME/.steam" ]; then
    echo "Error: Steam directory not found at $HOME/.steam"
    echo "Please install Steam first."
    exit 1
fi

# check if archive exists
if [ ! -f "$ARCHIVE" ]; then
    echo "Error: Proton archive not found at $ARCHIVE"
    echo "Please ensure you've cloned the repository with Git LFS enabled:"
    echo "  git lfs install"
    echo "  git lfs pull"
    exit 1
fi

# create compatibility tools directory if it doesn't exist
mkdir -p "$STEAM_COMPAT_DIR"

# check if already installed
if [ -d "$STEAM_COMPAT_DIR/$PROTON_NAME" ]; then
    echo "Found existing installation at $STEAM_COMPAT_DIR/$PROTON_NAME"
    read -p "Do you want to overwrite it? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    rm -rf "$STEAM_COMPAT_DIR/$PROTON_NAME"
fi

# extract patched proton
echo "Extracting patched Proton GE to $STEAM_COMPAT_DIR..."
tar xzf "$ARCHIVE" -C "$STEAM_COMPAT_DIR"

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. In Lutris, configure your SC2 installation to use '$PROTON_NAME' as the runner"
echo "2. Set the Wine prefix to your Battle.net installation (e.g., ~/Games/battlenet)"
echo "3. Launch SC2CampaignLauncher.exe or SC2Switcher_x64.exe through Lutris"
echo ""
echo "The patched Proton includes PSS API stubs required for the campaign launcher."
