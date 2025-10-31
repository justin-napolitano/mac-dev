#!/usr/bin/env bash
# Homebrew + curl setup (stable), plus zshrc hardening.
# - Forces brew to use system git/curl (no more _curl_global_trace)
# - Installs or repairs Homebrew
# - (Re)installs curl (keg-only)
# - Writes .zshrc exports so future shells and builds “just work”
# Optional: INSTALL_BREWED_GIT=1 to install Homebrew git after stabilization.

set -euo pipefail

INSTALL_BREWED_GIT="${INSTALL_BREWED_GIT:-0}"

# ---- helpers ----
append_if_missing() {
  local line="$1" file="$2"
  grep -qxF "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

info(){ printf "\033[1;36m[INFO]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
die(){  printf "\033[1;31m[FAIL]\033[0m %s\n" "$*"; exit 1; }

# Prefer system tools during bootstrap/repair
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_GIT_PATH="/usr/bin/git"
export HOMEBREW_CURL_PATH="/usr/bin/curl"

# Xcode CLT (needed for brew on fresh macs)
if ! xcode-select -p >/dev/null 2>&1; then
  info "Installing Xcode Command Line Tools (if prompted, complete the dialog)…"
  xcode-select --install || true
fi

# Detect brew prefix (Apple Silicon vs Intel); install if missing
if [ -x /opt/homebrew/bin/brew ]; then
  BREW_PREFIX="/opt/homebrew"
elif [ -x /usr/local/bin/brew ]; then
  BREW_PREFIX="/usr/local"
else
  info "Homebrew not found — installing…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then
    BREW_PREFIX="/opt/homebrew"
  elif [ -x /usr/local/bin/brew ]; then
    BREW_PREFIX="/usr/local"
  else
    die "Homebrew install did not produce a brew binary."
  fi
fi
BREW_BIN="${BREW_PREFIX}/bin/brew"

# Update or reset taps using system git/curl
info "Updating Homebrew (system git/curl)…"
if ! "${BREW_BIN}" update; then
  warn "brew update failed; trying update-reset"
  "${BREW_BIN}" update-reset || true
fi

# Keep things simple: ensure curl is installed/healthy (keg-only)
info "Reinstalling curl (keg-only)…"
"${BREW_BIN}" reinstall curl

# OPTIONAL: install brewed git (off by default for max stability)
if [ "$INSTALL_BREWED_GIT" = "1" ]; then
  info "Installing brewed git (optional)…"
  "${BREW_BIN}" reinstall git --force-bottle || "${BREW_BIN}" install git || true
else
  info "Skipping brewed git (stable path). You can run: INSTALL_BREWED_GIT=1 bash scripts/02_brew_git.sh"
fi

# ---- Zshrc hardening ----
ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"  # ensure file exists

# Correct prefix-aware paths
CURL_BIN_LINE="export PATH=\"${BREW_PREFIX}/opt/curl/bin:\$PATH\""
LDFLAGS_LINE="export LDFLAGS=\"-L${BREW_PREFIX}/opt/curl/lib\""
CPPFLAGS_LINE="export CPPFLAGS=\"-I${BREW_PREFIX}/opt/curl/include\""
PKGCFG_LINE="export PKG_CONFIG_PATH=\"${BREW_PREFIX}/opt/curl/lib/pkgconfig\""
HB_GIT_LINE="export HOMEBREW_GIT_PATH=\"/usr/bin/git\""
HB_CURL_LINE="export HOMEBREW_CURL_PATH=\"/usr/bin/curl\""

append_if_missing "$CURL_BIN_LINE" "$ZSHRC"
append_if_missing "$LDFLAGS_LINE" "$ZSHRC"
append_if_missing "$CPPFLAGS_LINE" "$ZSHRC"
append_if_missing "$PKGCFG_LINE" "$ZSHRC"
append_if_missing "$HB_GIT_LINE" "$ZSHRC"
append_if_missing "$HB_CURL_LINE" "$ZSHRC"

# Optional: ensure /bin/zsh is your login shell (harmless if already true)
if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
  info "Setting zsh as your default shell (may prompt for password)…"
  ZSH_PATH="/bin/zsh"
  grep -q "^$ZSH_PATH$" /etc/shells 2>/dev/null || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$ZSH_PATH" || warn "Could not change login shell automatically. You can run: chsh -s $ZSH_PATH"
fi

# ---- Final guidance ----
cat <<EOF

✅ Brew/curl setup complete.

Your ~/.zshrc now includes:
  - ${CURL_BIN_LINE}
  - ${LDFLAGS_LINE}
  - ${CPPFLAGS_LINE}
  - ${PKGCFG_LINE}
  - ${HB_GIT_LINE}
  - ${HB_CURL_LINE}

Reload your shell:
  source ~/.zshrc

Sanity check:
  which curl
  curl --version | head -n1
  echo \$HOMEBREW_GIT_PATH ; echo \$HOMEBREW_CURL_PATH
  ${BREW_BIN} update

If you later want brewed git:
  INSTALL_BREWED_GIT=1 bash scripts/02_brew_git.sh

EOF

