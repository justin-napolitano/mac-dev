---
slug: github-mac-dev-note-technical-overview
id: github-mac-dev-note-technical-overview
title: mac-dev Overview
repo: justin-napolitano/mac-dev
githubUrl: https://github.com/justin-napolitano/mac-dev
generatedAt: '2025-11-24T18:41:02.926Z'
source: github-auto
summary: >-
  The **mac-dev** repo helps you set up a macOS development environment quickly.
  It leverages make-driven scripts to automate essential installations and
  configuration.
tags: []
seoPrimaryKeyword: ''
seoSecondaryKeywords: []
seoOptimized: false
topicFamily: null
topicFamilyConfidence: null
kind: note
entryLayout: note
showInProjects: false
showInNotes: true
showInWriting: false
showInLogs: false
---

The **mac-dev** repo helps you set up a macOS development environment quickly. It leverages make-driven scripts to automate essential installations and configuration.

## Key Features

- Installs Homebrew and Git
- Sets up Zsh with Oh My Zsh and Powerlevel10k
- Installs common CLI tools (fzf, zoxide, etc.)
- Configures Visual Studio Code and installs extensions
- Applies macOS system defaults and installs key apps like Slack and Chrome

## Getting Started

1. Clone the repo:

    ```bash
    git clone https://github.com/justin-napolitano/mac-dev.git
    cd mac-dev
    ```

2. Run the full setup:

    ```bash
    make all
    ```

You can also run individual components:

```bash
make brew     # Homebrew + Git
make zsh      # Oh My Zsh setup
```

## Gotchas

- Make sure you're on macOS 12 or higher with Xcode Command Line Tools installed.  
- Each `make` target relates to a script in the `scripts` directory.
