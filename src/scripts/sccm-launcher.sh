#!/bin/bash

# loads config from $config_file folder
# breaks out and uses fallbacks if file isnt found
load_config() {
  # robust $script_dir detection
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  config_file="$(realpath "$script_dir/../../config/config.json")"
  if command -v jq >/dev/null && [ -f "$config_file" ]; then
    wine_prefix=$(jq -r '.wineprefix // empty' "$config_file")
    terminal=$(jq -r '.terminal // empty' "$config_file")
    sc2_prefix=$(jq -r '.sc2prefix // empty' "$config_file")
  else
    echo "Warning: config file not found or jq missing. Using defaults."
  fi

  # fallbacks for $wine_prefix $terminal and $sc2_prefix
  repo_root="$(realpath "$script_dir/../..")"
  # SC2 installation prefix (where actual game is)
  # Expand $HOME if present in sc2prefix
  sc2_prefix="${sc2_prefix:-$HOME/Games/battlenet}"
  sc2_prefix="${sc2_prefix/#\$HOME/$HOME}"
  # patched wine build folder
  wine_install="${wine_install:-$repo_root/src/wine/wine-sccm-custom}"
  # prefix folder for use with launcher
  if [ -z "$wine_prefix" ] || [ "$wine_prefix" = "auto" ]; then
  wine_prefix="$repo_root/src/wine/wine-sccm"
  fi
  # Sets the default terminal
  terminal="${terminal:-}"
  # Sets target for .exe logic
  target_path="$wine_prefix/drive_c/SC2CampaignLauncher.exe"
}

# terminal detection
# annoyed i need this
  
detect_terminal() {
  for term in x-terminal-emulator gnome-terminal konsole xfce4-terminal xterm alacritty; do
    if command -v "$term" >/dev/null; then
      terminal="$term"
      return
    fi
  done
  echo "Error: No supported terminal emulator found."
  exit 1
}

# assign extra variables and executable
load_config
# detect terminal if not set or set to "auto"
if [ -z "$terminal" ] || [ "$terminal" = "auto" ]; then
  detect_terminal
fi
exe_path="C:\\SC2CampaignLauncher.exe"

# launches in terminal
# if [ -z "$INSIDE_TERMINAL" ]; then
#   export INSIDE_TERMINAL=1
#   exec "$TERMINAL" --hold -e "$0"
# fi

# make drive_c directory
mkdir -p "$(dirname "$target_path")"

# downloads the launcher
echo "Downloading latest SC2CampaignLauncher.exe..."
curl -L -o "$target_path" "https://github.com/R-P-S/SC2CampaignLauncher/releases/latest/download/SC2CampaignLauncher.exe"

# checks download success before continuing
if [ -f "$target_path" ]; then
  echo "Launcher downloaded to: $TARGET_PATH"
else
  echo "Download failed."
  echo "Target Path: $target_path"
  exit 1
fi

# assign log path and set it up for date logging
log_path="$HOME/.local/share/sccm-launcher/logs"
mkdir -p "$log_path"
log_file="$log_path/$(date +'%Y-%m-%d_%H-%M-%S').log"

# cleanup any starcraft states
pkill -f StarCraft 2>/dev/null || true
pkill -f SC2 2>/dev/null || true
pkill -f Battle.net 2>/dev/null || true
WINEPREFIX="$sc2_prefix" wineserver -k 2>/dev/null || true
WINEPREFIX="$wine_prefix" wineserver -k 2>/dev/null || true
sleep 2
find "$wine_prefix/drive_c/users/"*/AppData/{Local,Roaming,LocalLow}/ -type f \
  \( -iname "*sc2*" -o -iname "*lock*" -o -iname "*tmp*" -o -iname "*flag*" -o -iname "*running*" \) \
  -exec rm -f {} + 2>/dev/null
find "$sc2_prefix/drive_c/users/"*/AppData/{Local,Roaming,LocalLow}/ -type f \
  \( -iname "*sc2*" -o -iname "*lock*" -o -iname "*tmp*" -o -iname "*flag*" -o -iname "*running*" \) \
  -exec rm -f {} + 2>/dev/null

# copy launcher to SC2 prefix so it can see SC2 installation
sc2_launcher_path="$sc2_prefix/drive_c/SC2CampaignLauncher.exe"
if [ ! -f "$sc2_launcher_path" ] || [ "$target_path" -nt "$sc2_launcher_path" ]; then
  echo "Copying launcher to SC2 prefix..."
  cp "$target_path" "$sc2_launcher_path"
fi

# final cleanup right before launch
echo "Final cleanup before launching..."
pkill -f StarCraft 2>/dev/null || true
pkill -f SC2 2>/dev/null || true
WINEPREFIX="$SC2PREFIX" wineserver -k 2>/dev/null || true
sleep 3
# remove any lingering state files
find "$sc2_prefix/drive_c/users/"*/AppData/{Local,Roaming,LocalLow}/ -type f \
  \( -iname "*sc2*" -o -iname "*lock*" -o -iname "*tmp*" -o -iname "*flag*" -o -iname "*running*" \) \
  -exec rm -f {} + 2>/dev/null

# sets prefix and path to the patched wine as well as the used prefix folder
# use SC2 prefix so launcher can see and launch SC2
export WINEPREFIX="$sc2_prefix"
export PATH="$wine_install/bin:$PATH"
# overides a crypto checksum for RSA signitures
export WINEDLLOVERRIDES="rsaenh=n"

# finally launch the .exe
echo "Launching SC2 Campaign Launcher..."
echo "Final process check:"
pgrep -fl "starcraft\|sc2" || echo "No SC2 processes found"
echo "WINEPREFIX=$WINEPREFIX"
echo "Config location: $WINEPREFIX/drive_c/users/$(whoami)/AppData/Roaming/SC2CampaignLauncher/"
WINEDEBUG=+process wine "$exe_path" 2>&1 | grep -v NtQueryInformationProcess | tee "$log_file" # logs terminal to directory
