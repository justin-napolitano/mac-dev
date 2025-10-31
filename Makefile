SHELL := /bin/zsh

# Default: full setup
.PHONY: all
all: brew zsh cli fonts defaults runtimes vscode apps postflight
	@echo "✅ All steps complete!"

.PHONY: zsh
zsh:
	@echo ">>> Setting up Zsh..."
	@bash scripts/01_zsh.sh

.PHONY: brew
brew:
	@echo ">>> Installing Homebrew + Git..."
	@bash scripts/02_brew_git.sh

.PHONY: cli
cli:
	@echo ">>> Installing CLI tools..."
	@bash scripts/03_cli_tools.sh

.PHONY: fonts
fonts:
	@echo ">>> Installing Fonts + Terminal schemes..."
	@bash scripts/04_fonts_and_terminal.sh

.PHONY: defaults
defaults:
	@echo ">>> Applying macOS defaults..."
	@bash scripts/05_macos_defaults.sh

.PHONY: runtimes
runtimes:
	@echo ">>> Installing dev runtimes (Python/Node/etc.)..."
	@bash scripts/06_dev_runtimes.sh

.PHONY: vscode
vscode:
	@echo ">>> Setting up VS Code..."
	@bash scripts/07_vscode.sh

.PHONY: apps
apps:
	@echo ">>> Installing desktop apps..."
	@bash scripts/08_apps.sh

.PHONY: postflight
postflight:
	@echo ">>> Running postflight..."
	@bash scripts/99_postflight.sh

