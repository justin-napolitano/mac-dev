#!/usr/bin/env bash
# Installs common language toolchains & managers.
# - build deps
# - pyenv (+ shell init)
# - fnm (Node manager) + latest LTS
# - rbenv (+ shell init) [Ruby optional]
# - Go, Java (Temurin)
set -euo pipefail
# shellcheck disable=SC1091



BREW=$([ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew)

# Core build deps often needed by runtimes
$BREW install openssl readline sqlite xz zlib bzip2 libffi

# --- Python via pyenv ---
$BREW install pyenv
if ! grep -q 'pyenv init' "$HOME/.zshrc"; then
  cat <<'EOF' >> "$HOME/.zshrc"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
fi
echo "ℹ️  pyenv installed. Install a version with: pyenv install 3.12.x && pyenv global 3.12.x"

# --- Node via fnm (fast node manager) ---
$BREW install fnm
if ! grep -q 'fnm env' "$HOME/.zshrc"; then
  echo 'eval "$(fnm env --use-on-cd)"' >> "$HOME/.zshrc"
fi
# Install latest LTS node and set default (safe to retry)
export FNM_DIR="${FNM_DIR:-$HOME/Library/Application Support/fnm}"
eval "$($BREW --prefix fnm)/bin/fnm env --use-on-cd"
fnm install --lts || true
fnm default lts || true

# --- Ruby via rbenv (optional) ---
$BREW install rbenv
if ! grep -q 'rbenv init' "$HOME/.zshrc"; then
  echo 'eval "$(rbenv init - zsh)"' >> "$HOME/.zshrc"
fi
echo "ℹ️  rbenv installed. Install Ruby with: rbenv install <version> && rbenv global <version>"

# --- Go ---
$BREW install go
# --- Java (Temurin JDK) ---
$BREW install --cask temurin

echo "✅ Dev runtimes installed."

