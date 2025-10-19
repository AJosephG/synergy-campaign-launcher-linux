
# synergy-campaign-launcher-linux


>**This project is independent of and not affiliated, endorsed by, or representative of/with Synergy or the community**

This project provides a fully repatched method of running [Synergy's Campaign launcher](https://github.com/R-P-S/SC2CampaignLauncher) on specifically Linux.

This is because the current versions of the launcher are incompatible with `wine` in several ways.

Make sure to follow the [#How to use](#how-to-use) section for your distro before making [bug reports](#bug-reports).

This project will most likely deprecate once `wine` is updated to work with this application.

# How to use

Make sure these dependencies are met:
- Latest version of `wine`, `wine-mono`, `wine-gecko` and `winetricks` (latest or staging)
- `lutris` (optional if using a different version of `wine` for `StarCraft2`)
- `jq` (only needed if you have issues related to `JSON` parsing)

### apt based distros (Debian / Ubuntu):

Required

> `sudo apt update`<br>
>`sudo apt install --no-install-recommends -y bash coreutils findutils procps grep sed gawk git tee`<br>
>`sudo apt install -y wine winetricks`<br>

Optional

> `sudo apt install -y wine64 wine32 wine-mono wine-gecko lutris`<br>

NOTE: You may need to enable the WineHQ repository to install `wine64` and `wine32`.

### dnf/yum (Fedora / CentOS):

Required

> `sudo dnf install -y bash coreutils findutils procps-ng grep sed gawk git`<br>
> `sudo dnf install -y wine winetricks`<br>

Optional 

> `sudo dnf install -y wine-mono wine-gecko lutris jq`<br>

### pacman (Arch / Manjaro)

Required

> `sudo pacman -Syu` <br>
> `sudo pacman -S --needed bash coreutils findutils procps-ng grep sed gawk git` <br>
> `sudo pacman -S --needed wine winetricks` <br>

Optional

> `sudo pacman -S --needed wine-mono wine-gecko lutris jq` <br>

NOTE: use AUR (yay) for `staging` or `dev` `wine`. ex. `wine-staging`

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

### Steam / Proton

Steam/Proton may work for some users, but Lutris is recommended for easier prefix management and compatibility with the launcher.

Steam: (https://store.steampowered.com/about/)

Proton: (https://github.com/GloriousEggroll/proton-ge-custom)

## Git

1. Clone the repo 
>`git clone https://github.com/AJosephG/synergy-campaign-launcher-linux.git`

2. Enter Directory 
>`cd synergy-campaign-launcher-linux`

3. Install (perserves executable and installs launcher to your user bin)
>`install -Dm755 src/scripts/sccm-launcher.sh ~/.local/bin/sccm-launcher`

4. Run
>`~/.local/bin/sccm-launcher`


## Release

1. Download the latest `sccm-launcher.tar.gz` from the releases page.
This ensures that the latest bug fixes for different wine versions are added.

2. Extract `.tar.gz` file. Locate the script file inside the extracted folder.

3. Run by either double clicking on the `.sh` or by using `./sccm-launcher.sh`

## Troubleshooting

If the launcher reports that StarCraft II is already running:
- Run the cleanup script included in the release to remove leftover `.lock`, `.tmp`, or `.flag` files
- Make sure the SC2 install path in `config/config.json` matches your actual Lutris prefix
- Check that Wine is correctly installed and matches the architecture of your SC2 install

Logs are saved to `~/.local/share/sccm-launcher/logs/` and can be uploaded to GitHub for help.

## Bug Reports

Bug reports when using this script are to be made in this repo unless otherwise directed.

Make sure to share any log files and errors that appear.

Steps that were made before the bug/error occured are also helpful.

OS is required in the report. This can be gotten different ways, most commonly through terminal: 
> `lsb_release -a` <br> `hostnamectl`

 or through a settings menu or info application.

Don't include personal info.



## Folder Overview

- `src/`: Main source code
- `src/wine/` Patched Wine Version
- `src/scripts/` Launcher scripts
- `config/`: Bundled configuration files
- `scripts/`: Debugging and development scripts
- `release/`: Packaged builds and release artifacts
- `build/`: Temporary wine/script build files

