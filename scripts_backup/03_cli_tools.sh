#!/usr/bin/env bash
# Installs useful CLI tools and wires completions where relevant.
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/_brew_env.sh"


BREW_PREFIX=$([ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew || echo /usr/local)
/usr/bin/env bash -lc "${BREW_PREFIX}/bin/brew install fzf zoxide bat eza fd ripgrep jq yq tree wget curlie direnv gh starship tmux"

# fzf keybindings
"$(/usr/bin/env bash -lc 'brew --prefix fzf')/install" --no-bash --no-fish --key-bindings --completion || true

# direnv hook for zsh
if ! grep -q 'direnv hook zsh' "$HOME/.zshrc" 2>/dev/null; then
  echo 'eval "$(direnv hook zsh)"' >> "$HOME/.zshrc"
fi

echo "✅ CLI tools installed."

