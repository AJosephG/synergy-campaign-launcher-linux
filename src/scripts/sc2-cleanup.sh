#!/bin/bash
# cleans Starcraft related temp and cache files from Wine

# default prefix path
load_config() {
    # find config
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "SCRIPT_DIR: $SCRIPT_DIR"
    CONFIG_FILE="$(realpath "$SCRIPT_DIR/../../config/config.json")"
    echo "CONFIG_FILE: $CONFIG_FILE"
    # load config
  if command -v jq >/dev/null && [ -f "$CONFIG_FILE" ]; then
    SC2PREFIX=$(jq -r '.sc2prefix // empty' "$CONFIG_FILE")
    TERMINAL=$(jq -r '.terminal // empty' "$CONFIG_FILE")
  else
    echo "Warning: config file not found or jq missing. Using defaults."
    echo "Resolved config path: $CONFIG_FILE"
  fi


  # fallbacks
  SCRIPT_DIR="$(dirname "$0")"
  REPO_ROOT="$(realpath "$SCRIPT_DIR/../..")"
  # default terminal
  TERMINAL="${TERMINAL:-}"
  # prefix where starcraft is located
  SC2PREFIX="${SC2PREFIX:-$HOME/Games/battlenet}"
}
# detect terminal

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

# config and terminal
load_config
# detect terminal if not set or set to "auto"
if [ -z "$TERMINAL" ] || [ "$TERMINAL" = "auto" ]; then
  detect_terminal
fi

# launches in terminal
if [ -z "$INSIDE_TERMINAL" ]; then
  export INSIDE_TERMINAL=1
  exec "$TERMINAL" --hold -e "$0"
fi

echo "Cleaning StarCraft2 temp files in: $SC2PREFIX"

# clear lingering Starcraft processes
pkill -f StarCraftII.exe 2>/dev/null

# Remove lock/temp/flag files from Temp folders
find "$SC2PREFIX/drive_c/users/"*/AppData/{Local,Roaming,LocalLow}/Temp/ -type f \
  \( -iname "*sc2*" -o -iname "*.lock" -o -iname "*.tmp" -o -iname "*.flag" -o -iname "*running*" \) \
  -exec rm -f {} + 2>/dev/null

# Remove Battle.net cache folders (Can help if there's launcher issues)
rm -rf "$SC2PREFIX/drive_c/users/"*/AppData/Local/Battle.net/Cache/* 2>/dev/null
rm -rf "$SC2PREFIX/drive_c/users/"*/AppData/Roaming/Battle.net/Cache/* 2>/dev/null

echo "Cleanup complete."
