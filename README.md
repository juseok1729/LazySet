# LazySet

This repository provides scripts to automatically install Neovim, LazyVim, and other necessary development tools.

## Table of Contents

- [Structure](#repository-structure)
- [Environments](#supported-environments)
- [Installing and Updating](#installing-and-updating)
   - [Install Script](#install--update-script)
   - [Mannual Installation](#manual-installation)
   - [Installing Individual Components](#installing-individual-components)
   - [Installed Tools](#installed-tools)
- [Custom Configuration](#custom-configuration)
- [Troubleshooting](#troubleshooting)
- [Customization](#customization)

## Repository Structure

```
.
├── README-KO.md               # Korean documentation
├── README.md                  # English documentation
├── _install.sh                # Main installation script
├── bin/                       # Installation scripts directory
│   ├── install_lazyvim.sh     # LazyVim installation script
│   ├── install_neovim.sh      # Neovim installation script
│   ├── install_nvm.sh         # NVM (Node Version Manager) installation script
│   ├── install_packages.sh    # Required packages installation script
│   └── utils.sh               # Utility functions for scripts
├── conf/                      # Configuration files directory
│   ├── ghostty/               # Ghostty terminal configuration
│   │   └── config             # Ghostty configuration file
│   ├── nvim/                  # Neovim configuration files
│   │   ├── lazy-lock.json     # LazyVim plugin lock file
│   │   ├── lazyvim.json       # LazyVim configuration file
│   │   └── lua/               # Lua configuration directory
│   │       ├── config/        # Core configuration files
│   │       │   ├── autocmds.lua    # Auto commands configuration
│   │       │   ├── keymaps.lua     # Key mappings configuration
│   │       │   ├── lazy.lua        # Lazy.nvim plugin manager configuration
│   │       │   └── options.lua     # Neovim options configuration
│   │       └── plugins/       # Plugin configurations
│   │           └── colorscheme.lua # Color scheme configuration
│   └── vivaldi/               # Vivaldi browser configuration
│       └── Preferences        # Vivaldi preferences file
└── install.sh                 # Remote installation script
```

## Supported Environments

- Linux (Ubuntu, Debian, Fedora, Arch Linux)
- macOS (Intel, Apple Silicon)

## Installing and Updating
### Install & Update Script

The simplest way to install is with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/juseok1729/LazySet/main/install.sh | bash
```

Or if you use wget:

```bash
wget -O- https://raw.githubusercontent.com/juseok1729/LazySet/main/install.sh | bash
```

### Manual Installation

Clone the Git repository and run the installation script:

```bash
git clone https://github.com/juseok1729/LazySet.git
cd LazySet
chmod +x _install.sh
./_install.sh
```

### Installing Individual Components

If needed, you can install individual components:

1. Install Neovim:
   ```bash
   ./bin/install_neovim.sh [linux|macos] [x86_64|arm64]
   ```

2. Install required packages:
   ```bash
   ./bin/install_packages.sh [linux|macos]
   ```

3. Install NVM (Node Version Manager):
   ```bash
   ./bin/install_nvm.sh
   ```

4. Install LazyVim:
   ```bash
   ./bin/install_lazyvim.sh [conf_dir_path]
   ```

### Installed Tools

- **Neovim**: Latest version of the Neovim editor
- **Development Tools**: ripgrep, fzf, fd, git, gcc
- **NVM**: Node.js Version Manager (automatically installs the latest LTS Node.js version)
- **LazyVim**: Neovim configuration framework

## Custom Configuration

You can add Neovim configuration files to the `conf` directory. During installation, these files will be automatically copied to the `~/.config/nvim/lua/plugins/` directory.

Example files:
- `lsp.lua`: Language Server Protocol (LSP) configuration

To create additional configuration files, add files with the `.lua` extension to the `conf` directory. The installation will proceed normally with default LazyVim settings even if there are no files or the directory is empty.

## Troubleshooting

If the `nvim` command doesn't work after installation:

```bash
# For Linux
source ~/.bashrc

# For macOS
source ~/.zshrc  # or ~/.bashrc
```

If you need to install Xcode Command Line Tools on macOS, you can install them with the following command:

```bash
xcode-select --install
```

## Customization

To further customize the LazyVim configuration after the basic installation, edit the files in the `~/.config/nvim` directory.