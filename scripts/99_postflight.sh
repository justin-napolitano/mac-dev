#!/usr/bin/env bash
# Final touches: SSH keys, Git identity, helpful tips.
set -euo pipefail

# --- SSH key (ed25519) ---
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  echo "🔐 Generating SSH key (ed25519)…"
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "${USER}@$(hostname)" -N "" -f "$HOME/.ssh/id_ed25519" </dev/null
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add -K "$HOME/.ssh/id_ed25519" 2>/dev/null || ssh-add "$HOME/.ssh/id_ed25519" || true
else
  echo "🔐 SSH key already exists."
fi

# --- Git identity (optional, uses env vars if provided) ---
if [ -n "${GIT_NAME:-}" ]; then
  git config --global user.name "$GIT_NAME"
fi
if [ -n "${GIT_EMAIL:-}" ]; then
  git config --global user.email "$GIT_EMAIL"
fi
git config --global pull.rebase false
git config --global init.defaultBranch main
git config --global core.editor "code --wait"

# --- Show public key for convenience ---
if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
  echo
  echo "📋 Your SSH public key (add to GitHub/GitLab/Bitbucket):"
  echo "----------------------------------------------------------------"
  cat "$HOME/.ssh/id_ed25519.pub"
  echo "----------------------------------------------------------------"
fi

echo
echo "✅ Postflight complete."
echo "• If you use GitHub: https://github.com/settings/keys"
echo "• If 'code' CLI isn't on PATH, in VS Code run: 'Shell Command: Install 'code' command in PATH'"
echo "• Restart Terminal or run: exec zsh"
