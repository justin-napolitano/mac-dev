#!/usr/bin/env bash
# macOS Zsh Setup (no Homebrew, no Git)
# Installs: Oh My Zsh (tarball), Powerlevel10k, autosuggestions, syntax-highlighting, completions
# Also sets zsh default shell and (optionally) Meslo Nerd Fonts.
set -euo pipefail

info(){ printf "\033[1;36m[INFO]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
die(){  printf "\033[1;31m[FAIL]\033[0m %s\n" "$*"; exit 1; }

for b in curl tar sed chsh; do command -v "$b" >/dev/null 2>&1 || die "Missing: $b"; done

# macOS has BSD sed; use -i ''
SED_INPLACE=(sed -i '')

OMZ_DIR="$HOME/.oh-my-zsh"
ZSHRC="$HOME/.zshrc"
ZSH_CUSTOM_RUNTIME="${ZSH_CUSTOM:-$OMZ_DIR/custom}" # this is for *runtime* zsh; we'll also write ZSH to .zshrc
THEMES_DIR="$ZSH_CUSTOM_RUNTIME/themes"
PLUGINS_DIR="$ZSH_CUSTOM_RUNTIME/plugins"

INSTALL_FONTS="${INSTALL_FONTS:-1}"

# --- robust tarball helper: uses the archive's top-level dir ---
download_unpack() { # url dest_dir
  local url="$1" dest="$2"
  local tmp; tmp="$(mktemp -d)"
  trap 'rm -rf "'"$tmp"'"' RETURN

  info "Downloading: $url"
  curl -fsSL "$url" -o "$tmp/pkg.tgz"

  # Determine the top-level path inside the archive (first entry)
  local top
  top="$(tar -tzf "$tmp/pkg.tgz" | head -n1)"
  [ -n "$top" ] || die "Could not read top-level path in archive: $url"

  info "Unpacking to: $dest"
  rm -rf "$dest" && mkdir -p "$dest"
  tar -xzf "$tmp/pkg.tgz" -C "$tmp"
  # Copy contents of the top dir into the dest
  /bin/cp -R "$tmp/$top"/. "$dest"/ 2>/dev/null || /bin/cp -R "$tmp/$top"/* "$dest"/ 2>/dev/null || true
  rm -rf "$tmp"
  trap - RETURN
}

# ---------- 1) Install Oh My Zsh (tarball) ----------
if [ ! -d "$OMZ_DIR" ]; then
  info "Installing Oh My Zsh…"
  mkdir -p "$OMZ_DIR"
  download_unpack "https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.tar.gz" "$OMZ_DIR"
  [ -f "$ZSHRC" ] || /bin/cp "$OMZ_DIR/templates/zshrc.zsh-template" "$ZSHRC"
else
  info "Oh My Zsh already present at $OMZ_DIR"
fi

# Ensure ~/.zshrc has the basics
grep -qE '^export ZSH=' "$ZSHRC" 2>/dev/null || echo 'export ZSH="$HOME/.oh-my-zsh"' >> "$ZSHRC"
grep -q 'source $ZSH/oh-my-zsh.sh' "$ZSHRC" 2>/dev/null || echo 'source $ZSH/oh-my-zsh.sh' >> "$ZSHRC"

# ---------- 2) Theme: Powerlevel10k (tarball) ----------
info "Installing Powerlevel10k…"
mkdir -p "$THEMES_DIR/powerlevel10k"
download_unpack "https://github.com/romkatv/powerlevel10k/archive/refs/heads/master.tar.gz" "$THEMES_DIR/powerlevel10k"

# ---------- 3) Plugins (tarballs) ----------
info "Installing plugins…"
mkdir -p "$PLUGINS_DIR/zsh-autosuggestions"
download_unpack "https://github.com/zsh-users/zsh-autosuggestions/archive/refs/heads/master.tar.gz" "$PLUGINS_DIR/zsh-autosuggestions"

mkdir -p "$PLUGINS_DIR/zsh-syntax-highlighting"
download_unpack "https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/heads/master.tar.gz" "$PLUGINS_DIR/zsh-syntax-highlighting"

mkdir -p "$PLUGINS_DIR/zsh-completions"
download_unpack "https://github.com/zsh-users/zsh-completions/archive/refs/heads/master.tar.gz" "$PLUGINS_DIR/zsh-completions"

# ---------- 4) Update ~/.zshrc ----------
info "Configuring ~/.zshrc …"

# Theme
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
  "${SED_INPLACE[@]}" 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
else
  printf '\nZSH_THEME="powerlevel10k/powerlevel10k"\n' >> "$ZSHRC"
fi

# Plugins (ensure zsh-syntax-highlighting is last)
if grep -q '^plugins=(' "$ZSHRC"; then
  "${SED_INPLACE[@]}" 's|^plugins=(.*)|plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting)|' "$ZSHRC"
else
  printf '\nplugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting)\n' >> "$ZSHRC"
fi

# Extra config (only append once)
if ! grep -q '# === Extra Tools Config ===' "$ZSHRC" 2>/dev/null; then
  cat <<'EOF' >> "$ZSHRC"

# === Extra Tools Config ===
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# History prefix search on Up/Down
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Prefer bat if present
if command -v bat >/dev/null 2>&1; then
  alias cat="bat --style=plain --paging=never"
elif command -v batcat >/dev/null 2>&1; then
  alias bat="batcat"; alias cat="batcat --style=plain --paging=never"
fi

# Load p10k config if present
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF
fi

# ---------- 5) Meslo Nerd Fonts (Optional) ----------
if [ "${INSTALL_FONTS}" = "1" ]; then
  info "Installing MesloLGS Nerd Fonts…"
  FONTS="$HOME/Library/Fonts"; mkdir -p "$FONTS"
  for f in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
    curl -fsSL "https://github.com/romkatv/powerlevel10k-media/raw/master/${f// /%20}" -o "$FONTS/$f"
  done
else
  warn "Skipping fonts (INSTALL_FONTS=$INSTALL_FONTS). Make sure your terminal uses MesloLGS NF."
fi

# ---------- 6) Make zsh the default shell ----------
if [ "$(basename "$SHELL")" != "zsh" ]; then
  info "Setting zsh as your default shell…"
  ZSH_PATH="/bin/zsh"
  grep -q "^$ZSH_PATH$" /etc/shells 2>/dev/null || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$ZSH_PATH" || warn "Could not chsh automatically; run: chsh -s $ZSH_PATH"
fi

# ---------- 7) Validate plugin install & prompt user-friendly hints ----------
missing=()
[ -d "$PLUGINS_DIR/zsh-autosuggestions" ] || missing+=("zsh-autosuggestions")
[ -d "$PLUGINS_DIR/zsh-completions" ]     || missing+=("zsh-completions")
[ -d "$PLUGINS_DIR/zsh-syntax-highlighting" ] || missing+=("zsh-syntax-highlighting")

if [ ${#missing[@]} -gt 0 ]; then
  warn "Some plugins appear missing: ${missing[*]}"
  warn "Expected under: $PLUGINS_DIR/<plugin>"
fi

# Remove old p10k config so the wizard runs on first start (safe; will be recreated)
rm -f "$HOME/.p10k.zsh"

info "✅ Zsh setup complete. Restart Terminal/iTerm2 or run: exec zsh"
info "👉 On first start, the Powerlevel10k wizard should launch (or run: p10k configure)"

