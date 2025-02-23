#!/bin/bash

source build-scripts/utils/logging.bash

# Private: Protocol used for URL handling (deep linking)
URL_PROTOCOL="questkeeper"

# Private: Some setups don't set XDG_DATA_HOME, so set it to the default
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Private: Installs a desktop entry at the appropriate location.
function install_entry() {
  local file_name="$1"
  local contents="$2"

  local path="$XDG_DATA_HOME/applications/$file_name.desktop"

  info "Installing desktop entry $file_name to $path"
  echo "$contents" > "$path"
}

# Private:
function main() {
  if [[ ! -f "pubspec.yaml" ]]; then
    abort "This script must be ran from the project root."
  fi

  local binary_path="$PWD/build/linux/x64/debug/bundle"

  install_entry "questkeeper" "$(echo "\
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=QuestKeeper Development
      Comment=Gamified task management app (development)
      Exec=$binary_path/questkeeper
      Categories=Office;Utility;
      Terminal=true
    " | sed 's/^[[:space:]]*//')"

  install_entry "questkeeper-handler" "$(echo "\
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=QuestKeeper Development (URL Handler)
      Comment=Gamified task management app (development)
      MimeType=x-scheme-handler/$URL_PROTOCOL;
      Exec=$binary_path/questkeeper %u
      Categories=Office;Utility;
      Terminal=true
      NoDisplay=true
    " | sed 's/^[[:space:]]*//')"

  if command -v update-desktop-database > /dev/null; then
    info "Running 'update-desktop-database' to update desktop entries."
    update-desktop-database
  else
    warn "Command 'update-desktop-database' does not exist. Desktop entries will not be automatically updated."
  fi

  info "Success!"

  if [[ ! -d "$binary_path" ]]; then
    warn "Unable to locate linux debug build directory. Make sure to build the app in debug before using the desktop entries."
  fi
}

main