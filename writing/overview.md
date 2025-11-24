---
slug: github-mac-dev-writing-overview
id: github-mac-dev-writing-overview
title: Streamline Your macOS Dev Environment with mac-dev
repo: justin-napolitano/mac-dev
githubUrl: https://github.com/justin-napolitano/mac-dev
generatedAt: '2025-11-24T17:40:04.676Z'
source: github-auto
summary: >-
  I’m excited to share my latest GitHub project, mac-dev, which is here to
  enhance your macOS developer experience. It's a modular, make-driven setup
  crafted to automate the installation and configuration of essential tools and
  applications.
tags: []
seoPrimaryKeyword: ''
seoSecondaryKeywords: []
seoOptimized: false
topicFamily: null
topicFamilyConfidence: null
kind: writing
entryLayout: writing
showInProjects: false
showInNotes: false
showInWriting: true
showInLogs: false
---

I’m excited to share my latest GitHub project, mac-dev, which is here to enhance your macOS developer experience. It's a modular, make-driven setup crafted to automate the installation and configuration of essential tools and applications. 

## What is mac-dev?

In a nutshell, mac-dev is all about making it easier for developers to get their macOS systems up and running with the tools they need. I started this project out of frustration with spending too much time configuring my development environment. I wanted something quick, efficient, and flexible.

With mac-dev, I’ve created a set of shell scripts bundled under a Makefile, enabling you to install everything from package managers to development runtimes with minimal effort. Think of it as the Swiss Army knife for macOS dev setups.

## Why Does It Exist?

Every developer knows that setting up a new environment can be tedious and, at times, a real slog. The motivation behind mac-dev is simple:

- **Reduce setup time**: By automating installation, I saved hours that I’d rather spend writing code.
- **Consistency**: No more mismatched environments. Everyone can get the same dev setup.
- **Flexibility**: Got specific tools you love? Pick and choose what you need instead of dealing with a massive, one-size-fits-all installer.

## Key Design Decisions

The primary goal with mac-dev was simplicity and modularity. Here are the main design decisions I made:

- **Modular Scripts**: Each installation step is divided into its own script. Want just Homebrew? Just run that specific script.
- **Makefile as Orchestrator**: Using Make to handle the workflow makes it simple and intuitive. Plus, it’s a tool that most devs are already familiar with.
- **Default Preferences**: The project not only installs tools, but it also applies macOS system defaults to enhance the user experience.

## Tech Stack

Here's a quick rundown of the tools I used:

- **Shell Scripting**: Primarily using bash and zsh for writing scripts.
- **Makefile**: Orchestrates everything—from running scripts to defining targets for various setups.
- **Homebrew**: The go-to package manager for macOS.

## Key Features

What does mac-dev offer? Here are some of the standout features:

- Automated installation of Homebrew and Git
- Full Zsh setup with Oh My Zsh and Powerlevel10k for that sweet terminal look
- Essential CLI tools like `fzf`, `zoxide`, and `jq`
- Handpicked fonts and vibrant terminal color schemes
- Predefined macOS system preferences
- Development runtimes including Python and Node.js
- Visual Studio Code configuration and key extensions
- Essential desktop applications installation like Slack and Chrome
- Neat post-install steps to wrap things up

## Getting Started

Starting with mac-dev is a breeze. You just need a few things:

- macOS 12 or higher
- Xcode Command Line Tools (`xcode-select --install`)
- An internet connection
- `make` (comes pre-installed on macOS)

### Installation Steps

1. Clone the repo:

   ```bash
   git clone https://github.com/justin-napolitano/mac-dev.git
   cd mac-dev
   ```

2. Run the complete setup:

   ```bash
   make all
   ```

3. Prefer a more tailored approach? You can run individual setup steps:

   ```bash
   make brew      # Install Homebrew + Git
   make zsh       # Install Oh My Zsh, Powerlevel10k, plugins
   make cli       # Install CLI tools
   make fonts     # Install fonts and terminal color schemes
   make defaults  # Apply macOS defaults
   make runtimes  # Install development runtimes
   make vscode    # Setup Visual Studio Code
   make apps      # Install desktop applications
   make postflight # Run any post-install tasks
   ```

## Project Structure

Here's how the project is laid out:

```
mac-dev/
├── Makefile           # All orchestrated tasks live here
├── README.md          # You're reading it!
├── scripts/           # The heart of the setup - the scripts
└── scripts_backup/    # Backup for alternative scripts
```

Each target in the Makefile directly links to a script in the `scripts` directory. The `all` target simply runs through everything in sequence.

## Future Work / Roadmap

I’m always looking to improve. Here are some future goals for mac-dev:

- Add support for more development runtimes and languages.
- Provide richer customization options for macOS defaults.
- Incorporate comprehensive error handling and logging.
- Expand the application installation list based on user feedback.
- Add compatibility with other shells or terminal emulators.
- Implement automated testing for scripts to ensure they're reliable and idempotent.

## Final Thoughts

mac-dev aims to simplify the setup process for macOS development environments in a way that's both repeatable and maintainable. I believe there's always room for improvement, and I'm eager to hear your feedback.

If you want to stay updated on mac-dev and other projects, you can follow me on Mastodon, Bluesky, or Twitter/X. Let’s make our macOS setups just a bit better together!
