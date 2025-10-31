#!/usr/bin/env bash
# You can comment out any setting you don't want.
set -euo pipefail

# Key repeat (fast)
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Finder: show all extensions, status/path bar, default to list view
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Finder: show Library
chflags nohidden ~/Library

# Dock: autohide, faster animations, show only running apps
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock static-only -bool true

# Screenshots: save to ~/Screenshots
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# Trackpad: tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

killall Finder Dock SystemUIServer 2>/dev/null || true
echo "✅ macOS defaults applied."

