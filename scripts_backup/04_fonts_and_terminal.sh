#!/usr/bin/env bash
# Fonts & (optional) iTerm2 color schemes
# - Installs Nerd Fonts via Homebrew casks (no cask-fonts tap needed)
# - Optionally downloads iTerm2 color schemes (INSTALL_SCHEMES=1)
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/_brew_env.sh"


BREW=$([ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew)


echo "🎨 Installing Nerd Fonts..."
$BREW install --cask font-jetbrains-mono-nerd-font font-hack-nerd-font font-fira-code-nerd-font || true
echo "✅ Fonts installed (Meslo NF already handled by 01_zsh.sh)."

# ---- OPTIONAL: iTerm2 Color Schemes ----
INSTALL_SCHEMES="${INSTALL_SCHEMES:-0}"
if [ "$INSTALL_SCHEMES" != "1" ]; then
  echo "ℹ️  Skipping iTerm2 color schemes (set INSTALL_SCHEMES=1 to enable)."
  exit 0
fi

echo "🌈 Installing iTerm2 color schemes..."
SCHEMES_DIR="$HOME/iterm-schemes"
mkdir -p "$SCHEMES_DIR"

# Use only known-good filenames from the upstream repo
# Ref: https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master/schemes
declare -A SCHEMES=(
  ["Dracula"]="https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Dracula.itermcolors"
  ["OneHalfDark"]="https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/OneHalfDark.itermcolors"
  ["SolarizedDarkPatched"]="https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark%20-%20Patched.itermcolors"
  # Add more as you like; keep names exactly as in the repo.
)

download_scheme () {
  local name="$1" url="$2" out="$SCHEMES_DIR/$name.itermcolors"
  echo "  • $name"
  if curl -fsSL -o "$out" "$url"; then
    : # ok
  else
    echo "    ⚠️  $name download failed (skipping)."
    rm -f "$out" || true
  fi
}

for name in "${!SCHEMES[@]}"; do
  download_scheme "$name" "${SCHEMES[$name]}"
done

echo
echo "✅ Schemes saved to: $SCHEMES_DIR"
echo "👉 iTerm2 → Preferences → Profiles → Colors → Color Presets… → Import…"

