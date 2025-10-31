#!/usr/bin/env bash
set -euo pipefail

# --- Use system git/curl so brew never touches the broken brewed git/curl ---
export HOMEBREW_GIT_PATH="/usr/bin/git"
export HOMEBREW_CURL_PATH="/usr/bin/curl"
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1

# --- Find brew bin (Apple Silicon vs Intel) ---
if [ -x /opt/homebrew/bin/brew ]; then
  BREW_BIN="/opt/homebrew/bin/brew"
else
  BREW_BIN="/usr/local/bin/brew"
fi

APPS=(
  iterm2
  google-chrome
  rectangle
  raycast
  slack
  notion
  docker
  postman
  visual-studio-code
  spotify
  1password
)

# Update/repair taps using system git/curl
if ! "${BREW_BIN}" update; then
  "${BREW_BIN}" update-reset || true
fi

# Cask install loop (don’t fail the whole script if one app errors)
for app in "${APPS[@]}"; do
  "${BREW_BIN}" install --cask "$app" || true
done

echo "✅ Desktop apps installed."

