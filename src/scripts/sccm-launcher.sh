#!/bin/bash

# loads config file from folder
# breaks out and uses fallbacks if file isnt found
load_config() {
  # robust script dir
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  CONFIG_FILE="$(realpath "$SCRIPT_DIR/../../config/config.json")"
  if command -v jq >/dev/null && [ -f "$CONFIG_FILE" ]; then
    WINEPREFIX=$(jq -r '.wineprefix // empty' "$CONFIG_FILE")
    TERMINAL=$(jq -r '.terminal // empty' "$CONFIG_FILE")
    SC2PREFIX=$(jq -r '.sc2prefix // empty' "$CONFIG_FILE")
  else
    echo "Warning: config file not found or jq missing. Using defaults."
  fi

  # fallbacks
  REPO_ROOT="$(realpath "$SCRIPT_DIR/../..")"
  # SC2 installation prefix (where actual game is)
  # Expand $HOME if present in sc2prefix
  SC2PREFIX="${SC2PREFIX:-$HOME/Games/battlenet}"
  SC2PREFIX="${SC2PREFIX/#\$HOME/$HOME}"
  # patched wine build folder
  WINE_INSTALL="${WINE_INSTALL:-$REPO_ROOT/src/wine/wine-sccm-custom}"
  # prefix folder for use with launcher
  if [ -z "$WINEPREFIX" ] || [ "$WINEPREFIX" = "auto" ]; then
  WINEPREFIX="$REPO_ROOT/src/wine/wine-sccm"
  fi
  # Sets the default terminal
  TERMINAL="${TERMINAL:-}"
  # Sets target for .exe logic
  TARGET_PATH="$WINEPREFIX/drive_c/SC2CampaignLauncher.exe"
}

# terminal detection
# annoyed i need this
  
detect_terminal() {
  for term in x-terminal-emulator gnome-terminal konsole xfce4-terminal xterm alacritty; do
    if command -v "$term" >/dev/null; then
      TERMINAL="$term"
      return
    fi
  done
  echo "Error: No supported terminal emulator found."
  exit 1
}

# assign extra variables and executable
load_config
# detect terminal if not set or set to "auto"
if [ -z "$TERMINAL" ] || [ "$TERMINAL" = "auto" ]; then
  detect_terminal
fi
EXE_PATH="C:\\SC2CampaignLauncher.exe"

# launches in terminal
# if [ -z "$INSIDE_TERMINAL" ]; then
#   export INSIDE_TERMINAL=1
#   exec "$TERMINAL" --hold -e "$0"
# fi

# make drive_c directory
mkdir -p "$(dirname "$TARGET_PATH")"

# downloads the launcher
echo "Downloading latest SC2CampaignLauncher.exe..."
curl -L -o "$TARGET_PATH" "https://github.com/R-P-S/SC2CampaignLauncher/releases/latest/download/SC2CampaignLauncher.exe"

# checks download success before continuing
if [ -f "$TARGET_PATH" ]; then
  echo "Launcher downloaded to: $TARGET_PATH"
else
  echo "Download failed."
  echo "Target Path: $TARGET_PATH"
  exit 1
fi

# assign log path and set it up for date logging
LOG_PATH="$HOME/.local/share/sccm-launcher/logs"
mkdir -p "$LOG_PATH"
LOG_FILE="$LOG_PATH/$(date +'%Y-%m-%d_%H-%M-%S').log"

# cleanup any starcraft states
pkill -f StarCraft 2>/dev/null || true
pkill -f SC2 2>/dev/null || true
pkill -f Battle.net 2>/dev/null || true
WINEPREFIX="$SC2PREFIX" wineserver -k 2>/dev/null || true
WINEPREFIX="$WINEPREFIX" wineserver -k 2>/dev/null || true
sleep 2
find "$WINEPREFIX/drive_c/users/"*/AppData/{Local,Roaming,LocalLow}/ -type f \
  \( -iname "*sc2*" -o -iname "*lock*" -o -iname "*tmp*" -o -iname "*flag*" -o -iname "*running*" \) \
  -exec rm -f {} + 2>/dev/null
find "$SC2PREFIX/drive_c/users/"*/AppData/{Local,Roaming,LocalLow}/ -type f \
  \( -iname "*sc2*" -o -iname "*lock*" -o -iname "*tmp*" -o -iname "*flag*" -o -iname "*running*" \) \
  -exec rm -f {} + 2>/dev/null

# copy launcher to SC2 prefix so it can see SC2 installation
SC2_LAUNCHER_PATH="$SC2PREFIX/drive_c/SC2CampaignLauncher.exe"
if [ ! -f "$SC2_LAUNCHER_PATH" ] || [ "$TARGET_PATH" -nt "$SC2_LAUNCHER_PATH" ]; then
  echo "Copying launcher to SC2 prefix..."
  cp "$TARGET_PATH" "$SC2_LAUNCHER_PATH"
fi

# final cleanup right before launch
echo "Final cleanup before launching..."
pkill -f StarCraft 2>/dev/null || true
pkill -f SC2 2>/dev/null || true
WINEPREFIX="$SC2PREFIX" wineserver -k 2>/dev/null || true
sleep 3
# remove any lingering state files
find "$SC2PREFIX/drive_c/users/"*/AppData/{Local,Roaming,LocalLow}/ -type f \
  \( -iname "*sc2*" -o -iname "*lock*" -o -iname "*tmp*" -o -iname "*flag*" -o -iname "*running*" \) \
  -exec rm -f {} + 2>/dev/null

# sets prefix and path to the patched wine as well as the used prefix folder
# use SC2 prefix so launcher can see and launch SC2
export WINEPREFIX="$SC2PREFIX"
export PATH="$WINE_INSTALL/bin:$PATH"
# overides a crypto checksum for RSA signitures
export WINEDLLOVERRIDES="rsaenh=n"

# finally launch the .exe
echo "Launching SC2 Campaign Launcher..."
echo "Final process check:"
pgrep -fl "starcraft\|sc2" || echo "No SC2 processes found"
echo "WINEPREFIX=$WINEPREFIX"
echo "Config location: $WINEPREFIX/drive_c/users/$(whoami)/AppData/Roaming/SC2CampaignLauncher/"
WINEDEBUG=+process wine "$EXE_PATH" 2>&1 | grep -v NtQueryInformationProcess | tee "$LOG_FILE" # logs terminal to directory
