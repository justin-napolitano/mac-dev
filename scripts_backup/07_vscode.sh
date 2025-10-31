#!/usr/bin/env bash
# Installs VS Code, common extensions, and opinionated settings.
set -euo pipefail

# shellcheck disable=SC1091
source "$(dirname "$0")/_brew_env.sh"


BREW=$([ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew)

# Install VS Code
$BREW install --cask visual-studio-code

# VS Code binary path (code)
if ! command -v code >/dev/null 2>&1; then
  # VS Code usually symlinks the "code" CLI via the app UI; we add a fallback
  VSC_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  [ -x "$VSC_BIN" ] && ln -sf "$VSC_BIN" "$HOME/.local/bin/code" || true
  export PATH="$HOME/.local/bin:$PATH"
fi

# Extensions list
EXTS=(
  "ms-python.python"
  "ms-python.vscode-pylance"
  "ms-toolsai.jupyter"
  "ms-azuretools.vscode-docker"
  "ms-vscode.makefile-tools"
  "ms-vscode.vscode-typescript-next"
  "esbenp.prettier-vscode"
  "dbaeumer.vscode-eslint"
  "ms-vscode.cpptools"
  "golang.Go"
  "redhat.java"
  "github.vscode-pull-request-github"
  "github.copilot"
  "streetsidesoftware.code-spell-checker"
  "yzhang.markdown-all-in-one"
  "eamodio.gitlens"
  "pkief.material-icon-theme"
  "Gruntfuggly.todo-tree"
)

if command -v code >/dev/null 2>&1; then
  for ext in "${EXTS[@]}"; do
    code --install-extension "$ext" --force || true
  done
else
  echo "⚠️  'code' CLI not found; skip extensions (open VS Code and run 'Shell Command: Install 'code' command')."
fi

# Settings.json (merge-friendly: write if missing, else append new keys if absent)
SET_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$SET_DIR"
SET_FILE="$SET_DIR/settings.json"

# Minimal sane defaults (idempotent write if file missing)
if [ ! -f "$SET_FILE" ]; then
  cat > "$SET_FILE" <<'JSON'
{
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "terminal.integrated.defaultProfile.osx": "zsh",
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "Default Dark Modern",
  "python.defaultInterpreterPath": "~/.pyenv/shims/python",
  "editor.minimap.enabled": false,
  "git.confirmSync": false
}
JSON
else
  # Append a few defaults only if not present (simple grep-based approach)
  grep -q '"editor.formatOnSave":' "$SET_FILE" || sed -i '' '1s|^{|{"editor.formatOnSave": true,|' "$SET_FILE"
  grep -q '"terminal.integrated.defaultProfile.osx":' "$SET_FILE" || sed -i '' '1s|^{|{"terminal.integrated.defaultProfile.osx": "zsh",|' "$SET_FILE"
fi

echo "✅ VS Code installed & configured."

