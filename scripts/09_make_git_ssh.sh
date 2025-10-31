#!/usr/bin/env bash
# Configure GitHub CLI + SSH so pushes "just work"
# - Prefer system git for stability
# - Ensure SSH key (ed25519), load into Keychain
# - Configure gh to use SSH
# - Convert current repo's origin to SSH
# - Attempt to upload SSH key via gh; request scope if needed

set -euo pipefail

info(){ printf "\033[1;36m[INFO]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
die(){  printf "\033[1;31m[FAIL]\033[0m %s\n" "$*"; exit 1; }

PREFERS_SYSTEM_GIT="${PREFERS_SYSTEM_GIT:-1}"   # 1 = ensure /usr/bin/git wins
UPLOAD_KEY="${UPLOAD_KEY:-1}"                   # 1 = try to upload via gh

# --- 0) Prefer system git in this shell (no libcurl involved) ---
if [ "$PREFERS_SYSTEM_GIT" = "1" ]; then
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
fi
hash -r || true
info "Using git: $(command -v git)"
git --version || true

# --- 1) SSH key: create if missing, add to agent & keychain ---
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  info "Generating SSH key (ed25519)…"
  ssh-keygen -t ed25519 -C "${USER}@$(hostname)" -N "" -f "$HOME/.ssh/id_ed25519" </dev/null
fi

eval "$(ssh-agent -s)" >/dev/null
# macOS: prefer keychain
ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null \
  || ssh-add -K "$HOME/.ssh/id_ed25519" 2>/dev/null \
  || ssh-add "$HOME/.ssh/id_ed25519" || true

# --- 2) ~/.ssh/config host block for GitHub ---
SSHCFG="$HOME/.ssh/config"
touch "$SSHCFG"
chmod 600 "$SSHCFG" || true
if ! grep -qE '^\s*Host github\.com(\s|$)' "$SSHCFG"; then
  info "Adding github.com host block to ~/.ssh/config"
  cat >> "$SSHCFG" <<'EOF'

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  AddKeysToAgent yes
  UseKeychain yes
EOF
fi

# --- 3) GH CLI: login (if needed) and prefer SSH protocol ---
if command -v gh >/dev/null 2>&1; then
  if ! gh auth status >/dev/null 2>&1; then
    warn "gh is not authenticated. Launching device login (uses SSH protocol)…"
    # This opens a browser/device code flow; safe to rerun if already logged in.
    gh auth login --hostname github.com --git-protocol ssh -w || true
  fi
  gh config set git_protocol ssh
else
  warn "gh CLI not found; skipping gh-specific setup."
fi

# --- 4) Convert current repo remote to SSH (if inside a repo) ---
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  origin_url="$(git remote get-url origin 2>/dev/null || true)"
  if [ -n "$origin_url" ] && printf "%s" "$origin_url" | grep -q '^https://github.com/'; then
    repo_path="${origin_url#https://github.com/}"
    repo_path="${repo_path%.git}"
    ssh_url="git@github.com:${repo_path}.git"
    info "Switching origin to SSH: $ssh_url"
    git remote set-url origin "$ssh_url" || warn "Could not set SSH remote."
  fi
fi

# --- 5) Attempt to upload SSH key to GitHub (optional) ---
if [ "$UPLOAD_KEY" = "1" ] && command -v gh >/dev/null 2>&1; then
  PUB="$HOME/.ssh/id_ed25519.pub"
  TITLE="$(hostname) ed25519 key"
  if ! gh ssh-key list --json title 2>/dev/null | grep -q "$TITLE"; then
    info "Uploading SSH key to GitHub via gh (needs admin:public_key scope)…"
    if ! gh ssh-key add "$PUB" -t "$TITLE"; then
      warn "Key upload failed. Requesting scope 'admin:public_key' and retrying…"
      gh auth refresh -h github.com -s admin:public_key || true
      gh ssh-key add "$PUB" -t "$TITLE" || warn "Could not upload key (add it manually in GitHub → Settings → SSH and GPG keys)."
    fi
  fi
fi

# --- 6) Quick sanity ping (non-fatal if first-time fingerprint) ---
ssh -T git@github.com || true

info "✅ GitHub SSH setup complete. You can now push with: git push -u origin HEAD"


