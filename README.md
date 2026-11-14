
# Dotfiles

My personal development environment.

## Tools

- Neovim 0.12+ with native plugin management
- R and Python
- TeX Live, VimTeX, and Skim
- Homebrew

## Installation

### Homebrew

Install Homebrew from https://brew.sh/.

Install development tools:

```bash
brew bundle --file=Brewfile
```

### Neovim

Link the configuration directory:

```bash
ln -s ~/dotfiles/nvim ~/.config/nvim
```

Back up any existing Neovim configuration first.

### LaTeX

Install TeX Live using the official installer: https://tug.org/texlive/

### Shell

Source `shell/homebrew.sh` from the appropriate shell startup file.

