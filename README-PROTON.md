# Synergy Campaign Launcher - Linux (Proton GE)

Pre-patched Proton GE for running the StarCraft II Synergy Campaign Launcher on Linux.

## What is this?

The SC2 Synergy Campaign Launcher requires Windows Process State Snapshot (PSS) APIs that are not implemented in standard Wine/Proton. This repository provides a pre-patched version of Proton GE 9-20 with stubbed PSS API functions (`PssQuerySnapshot`, `PssFreeSnapshot`, `PssCaptureSnapshot`) that allow the launcher to run.

## Requirements

- Steam installed (for compatibility tools directory structure)
- Lutris (recommended for easy game management)
- StarCraft II installed via Battle.net
- SC2 Synergy Campaign Launcher files

## Installation

### Option 1: Download from Releases (Recommended)

1. Download `GE-Proton-PSS-Patched.tar.gz` from the [Releases](https://github.com/AJosephG/synergy-campaign-launcher-linux/releases) page

2. Extract to Steam compatibility tools directory:
```bash
mkdir -p ~/.steam/compatibilitytools.d
tar xzf GE-Proton-PSS-Patched.tar.gz -C ~/.steam/compatibilitytools.d
```

### Option 2: Use the installer script

1. Clone this repository:
```bash
git clone https://github.com/AJosephG/synergy-campaign-launcher-linux.git
cd synergy-campaign-launcher-linux
```

2. Download the archive from Releases and place it in the repository directory

3. Run the installer:
```bash
./install.sh
```

## Usage with Lutris

1. Open Lutris
2. Right-click your SC2 installation → Configure
3. Under "Runner options":
   - Wine version: Select `GE-Proton-PSS-Patched`
   - Wine prefix: Set to your Battle.net prefix (e.g., `~/Games/battlenet`)
4. Set the executable to `SC2CampaignLauncher.exe` or `SC2Switcher_x64.exe`
5. Launch!

## Why Proton GE instead of Wine?

The SC2 Switcher program requires Proton GE's specific configuration to properly load maps. Standard Wine builds do not work correctly even with PSS stubs. Both the campaign launcher and switcher must run under this patched Proton GE.

## Technical Details

This package includes:
- **Base**: GE-Proton 9-20 (last stable version before gstreamer issues)
- **Patch**: PSS API stubs in `kernel32.dll` (both 32-bit and 64-bit)
- **Modified files**:
  - `files/lib/wine/i386-unix/kernel32.dll.so`
  - `files/lib/wine/i386-windows/kernel32.dll`
  - `files/lib64/wine/x86_64-unix/kernel32.dll.so`
  - `files/lib64/wine/x86_64-windows/kernel32.dll`

## Troubleshooting

**"Prefix has an invalid version" warning**
- This is expected when downgrading from a newer Proton version
- The prefix will be automatically updated to work with GE-Proton 9-20

**Campaign launcher doesn't start**
- Verify the Wine prefix contains your Battle.net installation
- Check that `SC2CampaignLauncher.exe` exists in `drive_c/` of your prefix
- Ensure Lutris is using `GE-Proton-PSS-Patched` as the runner

**Maps don't load**
- You must use the patched Proton GE, not regular Wine
- Verify SC2Switcher is also launching through the same Proton version

## Building from Source

If you want to build the patched Proton yourself, see the [proton-repatched](https://github.com/yourusername/proton-repatched) repository which contains build scripts and documentation.

## Release Process

For maintainers: To create a new release with the patched Proton:

1. Build or update the patched Proton
2. Create archive: `tar czf GE-Proton-PSS-Patched.tar.gz -C ~/.steam/compatibilitytools.d GE-Proton-PSS-Patched`
3. Create a new GitHub Release
4. Upload `GE-Proton-PSS-Patched.tar.gz` as a release asset
5. Update release notes with version info and changes

## License

- Proton GE: Multiple licenses (see included LICENSE files in the Proton directory)
- PSS patches: MIT License (see repository LICENSE)

## Credits

- GloriousEggroll for Proton GE
- SC2 Synergy Campaign creators
- Wine project
