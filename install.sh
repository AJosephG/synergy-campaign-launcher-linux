#!/bin/bash
set -e

# synergy campaign launcher - proton ge pss installer
# installs pre-patched proton ge so sc2 campaign launcher works good
# script_dir points to where this install script sits
# steam_compat_dir is the users steam compat tools folder
# proton_name is the folder name we drop in steam compat tools
# archive is the tarball we expect (same name as $proton_name)

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
steam_compat_dir="$HOME/.steam/compatibilitytools.d"
proton_name="GE-Proton-PSS-Patched"
archive="$script_dir/$proton_name.tar.gz"

echo "synergy campaign launcher - proton ge pss installer"
echo ""

# check if steam compat tools directory exists (we look at $HOME/.steam)
if [ ! -d "$HOME/.steam" ]; then
    echo "Error: Steam directory not found at $HOME/.steam"
    echo "Please install Steam first."
    exit 1
fi

# check if $archive exists (we need the tarball here)
if [ ! -f "$archive" ]; then
    echo "Error: Proton archive not found at $archive"
    echo "Please download GE-Proton-PSS-Patched.tar.gz from the Releases page:"
    echo "  https://github.com/AJosephG/synergy-campaign-launcher-linux/releases"
    echo ""
    echo "Place it in: $script_dir/"
    exit 1
fi

# create compat tools directory if it doesn't exist yet
mkdir -p "$steam_compat_dir"

# check if already installed at $steam_compat_dir/$proton_name
if [ -d "$steam_compat_dir/$proton_name" ]; then
    echo "Found existing installation at $steam_compat_dir/$proton_name"
    read -p "Do you want to overwrite it? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    rm -rf "$steam_compat_dir/$proton_name"
fi

# extract patched proton ge into $steam_compat_dir
echo "Extracting patched Proton GE to $steam_compat_dir..."
tar xzf "$archive" -C "$steam_compat_dir"

echo ""
echo "installation complete"
echo ""
echo "next steps:"
echo "1. in lutris, configure your sc2 installation to use '$proton_name' as the runner"
echo "2. set the wine prefix to your battle.net installation (e.g., ~/Games/battlenet)"
echo "3. launch sc2campaignlauncher.exe or sc2switcher_x64.exe through lutris"
echo ""
echo "the patched proton includes pss api stubs required for the campaign launcher"
