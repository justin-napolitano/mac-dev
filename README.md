# mac-dev-bootstrap

A modular, make-driven setup for macOS developer environments.

## ⚙️ Requirements
- macOS 12+
- Xcode Command Line Tools (`xcode-select --install`)
- Internet connection
- `make` (installed by default)

## 🚀 Usage
Clone or copy this folder, then run:

```bash
make all
```

### Individual

```bash
make brew      # Install Homebrew + Git
make zsh       # Install Oh My Zsh, Powerlevel10k, plugins
make cli       # Install fzf, zoxide, bat, jq, etc.
make fonts     # Fonts + iTerm2 color schemes
make defaults  # Apply macOS defaults
make runtimes  # Install pyenv, fnm, etc.
make vscode    # Install VSCode + extensions
make apps      # Install desktop apps (Slack, Chrome, etc.)
make postflight
```
