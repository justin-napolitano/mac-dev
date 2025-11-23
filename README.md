# mac-dev-bootstrap

A modular, make-driven setup for macOS developer environments. This repository provides a streamlined way to configure a macOS system with essential developer tools, applications, and preferences using a series of shell scripts orchestrated by Make.

## Features

- Automated installation of Homebrew and Git
- Setup of Zsh with Oh My Zsh, Powerlevel10k, and plugins
- Installation of common CLI tools (fzf, zoxide, bat, jq, etc.)
- Installation of fonts and terminal color schemes
- Application of macOS system defaults
- Installation of development runtimes such as Python and Node.js
- Configuration of Visual Studio Code and its extensions
- Installation of common desktop applications (Slack, Chrome, etc.)
- Postflight configuration steps

## Tech Stack

- Shell scripting (bash, zsh)
- Makefile for task orchestration
- macOS native tools and package managers (Homebrew)

## Getting Started

### Prerequisites

- macOS 12 or higher
- Xcode Command Line Tools (`xcode-select --install`)
- Internet connection
- `make` (installed by default on macOS)

### Installation and Usage

1. Clone the repository:

```bash
git clone https://github.com/justin-napolitano/mac-dev.git
cd mac-dev
```

2. Run the full setup:

```bash
make all
```

3. Alternatively, run individual setup steps as needed:

```bash
make brew      # Install Homebrew + Git
make zsh       # Install Oh My Zsh, Powerlevel10k, plugins
make cli       # Install CLI tools
make fonts     # Install fonts and terminal color schemes
make defaults  # Apply macOS defaults
make runtimes  # Install development runtimes
make vscode    # Setup Visual Studio Code
make apps      # Install desktop applications
make postflight # Run postflight tasks
```

## Project Structure

```
mac-dev/
├── Makefile           # Orchestrates setup steps
├── README.md          # Project documentation
├── scripts/           # Shell scripts for each setup step
└── scripts_backup/    # Backup of previous or alternative scripts
```

- Each target in the Makefile corresponds to a script in the `scripts` directory.
- The `all` target runs all setup steps sequentially.

## Future Work / Roadmap

- Add support for additional development runtimes and languages.
- Enhance customization options for macOS defaults.
- Integrate more comprehensive error handling and logging.
- Expand application installation list based on user feedback.
- Provide support for other shells or terminal emulators.
- Add automated testing for scripts to ensure idempotency and reliability.

---

This setup aims to simplify the process of configuring a macOS development environment with repeatable, modular, and maintainable scripts.
