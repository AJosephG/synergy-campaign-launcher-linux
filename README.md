# synergy-campaign-launcher-linux

>**This project is independent of and not affiliated, endorsed by, or representative of/with Synergy or the community**

this lets you run the [synergy campaign launcher](https://github.com/R-P-S/SC2CampaignLauncher) on linux using a pre‑patched proton ge. it's meant to be simple and not fussy.

this is because newer versions of the launcher don't play nice with plain `wine` in a few ways.

make sure to follow the [#how to use](#how-to-use) section for your distro before making [bug reports](#bug-reports). saves us both time :)

## What is this?

the python build used by the launcher needs windows process state snapshot (pss) apis that standard wine/proton doesn't implement. this repo ships a pre‑patched proton ge 9-20 with tiny stub pss functions (`PssQuerySnapshot`, `PssFreeSnapshot`, `PssCaptureSnapshot`) so the launcher actually runs.

tl;dr: patched proton ge with pss stubs, so it works.

# How to use

Make sure these dependencies are met:
- Steam installed (for compatibility tools directory structure)
- `lutris` (recommended for easy game management)
- StarCraft II installed via Battle.net
- SC2 Synergy Campaign Launcher files

## Installation

### Option 1: Download from Releases (Recommended)

1. Download `GE-Proton-PSS-Patched.tar.gz` from the [Releases](https://github.com/AJosephG/synergy-campaign-launcher-linux/releases) page

2. Extract to Steam compatibility tools directory:
>`mkdir -p ~/.steam/compatibilitytools.d`<br>
>`tar xzf GE-Proton-PSS-Patched.tar.gz -C ~/.steam/compatibilitytools.d`

### Option 2: Use the installer script

1. Clone this repository:
>`git clone https://github.com/AJosephG/synergy-campaign-launcher-linux.git`<br>
>`cd synergy-campaign-launcher-linux`

2. Download the archive from Releases and place it in the repository directory

3. Run the installer:
>`./install.sh`

## Starcraft 2

This script does not download or set up StarCraft II. You can install it using one of the following methods:

### Lutris

Download the most recent version of `lutris` and make sure it set up according to [Lutris's Page](https://lutris.net/about)

- Add a game using the '+' Symbol in the top left corner.
- Search for StarCraft in the 'Search Lutris Website for Installers'
- Install StarCraft II from the options
- Follow installer Instructions
- Launch game once and login
- Note the install directory (default is `~/Games/` or custom Wine prefix)

**or**

- Go to https://lutris.net/games/starcraft-ii/
- Click install
- Follow Instructions
- Launch game and remember the directory

## Usage with Lutris

1. Open Lutris
2. Right-click your SC2 installation → Configure
3. Under "Runner options":
   - Wine version: Select `GE-Proton-PSS-Patched`
   - Wine prefix: Set to your Battle.net prefix (e.g., `~/Games/battlenet`)
4. Left click on the SC2 installation and click the Arrow next to the Wine Icon
5. Click 'Run EXE in prefix'
6. Navigate to the Campaign .exe file

You can also add this as a game in lutris and follow the same steps to easily access and launch the campaign launcher without the script.


### Steam

1. Click add game
2. Navigate to the .exe
3. Select option, then check the 'force use of specific compatibility tool'
4. Select the tool as 'GE-Proton-PSS-Patched'
5. Select play

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

## Bug Reports

Bug reports when using this script are to be made in this repo unless otherwise directed.

Make sure to share any log files and errors that appear.

Steps that were made before the bug/error occured are also helpful.

OS is required in the report. This can be gotten different ways, most commonly through terminal: 
> `lsb_release -a` <br> `hostnamectl`

 or through a settings menu or info application.

Don't include personal info.

## License

- Proton GE: Multiple licenses (see included LICENSE files in the Proton directory)
- PSS patches: MIT License (see repository LICENSE)

## Credits

- GloriousEggroll for Proton GE
- SC2 Synergy Campaign creators
- Wine project
- Worked on by a few independent people :3
