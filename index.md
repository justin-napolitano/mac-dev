+++
title= "Mac Dev Bootstrap — Fully Automated macOS Setup for Developers"
author= "Justin Napolitano"
date= "2025-10-31"
tags= ["macOS", "automation", "zsh", "dotfiles", "brew", "developer-tools"]
description= "A complete modular macOS bootstrap setup that automates Zsh, Homebrew, Powerlevel10k, GitHub SSH, and more. Set up your dev environment in minutes, not hours."
[extra]
reaction= false

+++

# 🚀 Mac Dev Bootstrap — Fully Automated macOS Setup for Developers

**by Justin Napolitano**

---

## 💡 Why I Built This

Setting up a new Mac for development should take 15 minutes, not half a day of manual installs, missing fonts, and plugin rabbit holes.  

After fighting through brew, zsh, oh-my-zsh, Powerlevel10k, libcurl mismatches, and the GitHub CLI chaos, I decided to script **everything** — from Zsh setup to GitHub SSH configuration — so the next time I wipe or upgrade a Mac, it’s one `make all` away from ready.

This repo is that setup — a **modular macOS bootstrap** you can use, fork, and customize.

---

## 🧱 Project Overview

**Repository:** [mac-dev-bootstrap](https://github.com/justin-napolitano/mac-dev)  
**Language:** Bash  
**Run it with:**  
```bash
make all
```

Each step is its own script under `scripts/`, wired together by a Makefile.  
You can run them all at once or step through them one by one.

```
mac-dev/
├─ Makefile
├─ README.md
└─ scripts/
   ├─ 01_zsh.sh              # Zsh + Oh My Zsh + Powerlevel10k + plugins
   ├─ 02_brew_git.sh         # Homebrew setup + curl + zshrc hardening
   ├─ 03_cli_tools.sh        # CLI tools: fzf, zoxide, bat, jq, etc.
   ├─ 04_fonts_and_terminal.sh
   ├─ 05_macos_defaults.sh   # Key repeat, Dock, Finder, etc.
   ├─ 06_dev_runtimes.sh     # pyenv, fnm, rbenv, Go, Java
   ├─ 07_vscode.sh           # VSCode + extensions + settings
   ├─ 08_apps.sh             # iTerm2, Chrome, Docker, Slack, etc.
   ├─ 09_github_ssh.sh       # GitHub CLI + SSH key setup
   └─ 99_postflight.sh       # Git identity + key printout
```

---

## ⚙️ Core Features

### 🌀 1. Zsh + Oh My Zsh
- Installs Oh My Zsh without using git (tarball method).
- Adds **Powerlevel10k** and **MesloLGS NF** fonts.
- Configures plugins:
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
  - `zsh-completions`
- Adds optional “smart history” search with ↑ / ↓ arrows.

> ✅ The 01_zsh.sh script ensures Powerlevel10k’s setup wizard runs the first time you open your shell.

---

### 🍺 2. Homebrew + Git (sane defaults)
After breaking brew one too many times, I hardened the setup:
- Uses **system git** and **system curl** (avoids libcurl symbol mismatch).
- Reinstalls curl as keg-only, sets paths, and exports everything to your `~/.zshrc`.
- Keeps your brew environment clean and idempotent.

> No more `_curl_global_trace` crashes.  
> No more half-broken brew updates.

---

### 🧰 3. CLI Tools
Includes everything I actually use day-to-day:
- `fzf` – fuzzy finder for history/files
- `zoxide` – smarter `cd`
- `bat` – colorized `cat`
- `jq`, `yq`, `ripgrep`, `fd`, `eza`, `tree`, `tmux`, `starship`, `direnv`
- Integrates completions automatically into Zsh.

---

### 🖋️ 4. Fonts & Terminal
Installs:
- JetBrains Mono Nerd Font
- Hack Nerd Font
- (optional) Fira Code Nerd Font

Also creates `~/iterm-schemes/` with downloadable `.itermcolors` files for OneHalfDark, Dracula, and Solarized Dark.

> Tip: You can skip color schemes entirely by setting `INSTALL_SCHEMES=0`.

---

### ⚙️ 5. macOS Defaults
Tweaks macOS for sane dev behavior:
- Fast key repeat
- Show all file extensions
- Dock autohide & scaling
- Save screenshots to `~/Screenshots`
- Enable trackpad tap-to-click

---

### 🧑‍💻 6. Dev Runtimes
Installs modern toolchains:
- Python via **pyenv**
- Node.js via **fnm**
- Ruby via **rbenv**
- Go + Temurin JDK

Each one auto-wires its init block into your `~/.zshrc`.

---

### 💻 7. VS Code
- Installs VS Code via Homebrew
- Installs extensions (Python, Docker, ESLint, Prettier, etc.)
- Writes a clean default `settings.json`

---

### 🧩 8. Apps
Installs the usual suspects:
```
iTerm2, Chrome, Rectangle, Raycast, Slack,
Notion, Docker, Postman, VS Code, Spotify, 1Password
```
Runs through cask, skips failed installs gracefully.

---

### 🔐 9. GitHub + SSH (the game changer)
This is where most setups break — so I made it bulletproof.

The script:
- Prefers **system git**.
- Generates/loads an **ed25519 SSH key**.
- Adds it to your **macOS Keychain** and `~/.ssh/config`.
- Configures the **GitHub CLI (`gh`)** for SSH.
- Converts your repo’s `origin` from HTTPS → SSH.
- Attempts to upload your public key via the GitHub API (auto-refreshes the needed scope).

> ✅ After this step: `git push` and `gh repo create` both just work — no prompts, no crashes.

---

### 🧹 99. Postflight
- Prints your SSH public key.
- Configures your Git name/email.
- Confirms system git/curl paths.

---

## 🧾 Makefile Usage

Run everything:
```bash
make all
```

Or run individual steps:
```bash
make zsh
make brew
make cli
make fonts
make github
```

---

## 🔁 Idempotent by Design

Every script checks for existing installs and configurations — rerunning it won’t break anything. It’s built for repeatable use across machines or fresh macOS setups.

---

## 💪 Why It Matters

This project is more than a dotfile repo. It’s a **complete reproducible Mac development environment** — modular, debuggable, and stable enough to trust on a clean machine.

- **No hardcoded paths**
- **No external dependencies**
- **No brew tap hacks**
- **Fully offline-compatible once cached**

---

## 🧠 Lessons Learned

- Don’t mix brewed git with system libcurl on macOS.
- Don’t assume Oh My Zsh is cloned via git.
- Always back up `.zshrc` before patching.
- SSH > HTTPS for GitHub every time.

---

## 🔗 Repository & License

**Repo:** [github.com/justin-napolitano/mac-dev](https://github.com/justin-napolitano/mac-dev)  
**License:** MIT  
**Author:** Justin Napolitano  

> Feel free to fork, modify, and share — the goal is to make onboarding a new Mac take minutes, not hours.
justin@Justins-MacBook-Air Downloads % 

