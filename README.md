# nvim-nix

A Nix-based Neovim configuration using [mnw](https://github.com/Gerg-L/mnw) (minimal neovim wrapper) with lazy loading, LSP support, and modern editing features.

## Features

- **Declarative Configuration**: Entire setup defined in Nix with flakes
- **Lazy Loading**: Plugins load on-demand using [lz.n](https://github.com/nvim-neorocks/lz.n)
- **LSP Support**: Pre-configured with lua-language-server and nixd
- **Auto-formatting**: Format-on-save with conform.nvim (stylua, alejandra)
- **Auto-linting**: Automatic linting with nvim-lint
- **Modern UI**: Catppuccin theme, lualine, noice.nvim, snacks.nvim
- **Fuzzy Finding**: Integrated picker via snacks.nvim
- **Session Management**: Automatic session persistence
- **Git Integration**: Gitsigns for inline git blame and hunk operations

## Installation

### As a Standalone Package

```bash
# Clone the repository
git clone https://github.com/yourusername/nvim-nix.git
cd nvim-nix

# Build and run
nix build
./result/bin/nvim
```

### As a Flake Input

Add this configuration as an input to your NixOS or home-manager flake:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvim-nix.url = "github:yourusername/nvim-nix";
  };

  outputs = { self, nixpkgs, nvim-nix, ... }: {
    # In your system configuration or home-manager
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          # With neovim nightly
          environment.systemPackages = [
            nvim-nix.packages.${pkgs.system}.default
          ];

          # If you want to use stable neovim
          # environment.systemPackages = [
          #  nvim-nix.packages.${pkgs.system}.stable
          # ];
        })
      ];
    };
  };
}
```

### In Home Manager

```nix
{ config, pkgs, nvim-nix, ... }:

{
  home.packages = [
    # With neovim nightly
    nvim-nix.packages.${pkgs.system}.default

    # If you want to use stable neovim
    # nvim-nix.packages.${pkgs.system}.stable
  ];
}
```

### Customizing the Configuration

Fork this repository and modify:
- `default.nix` - Add/remove plugins and configure external tools
- `lua/nvim/` - Core Neovim settings (options, keymaps, autocommands)
- `lua/plugins/` - Plugin-specific configurations

## Plugins

### Core

These plugins are loaded immediately on startup:

- [lz.n](https://github.com/nvim-neorocks/lz.n) - Lazy loading framework
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua utility functions
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Multi-purpose plugin (dashboard, picker, terminal, notifications)
- [catppuccin-nvim](https://github.com/catppuccin/nvim) - Soothing pastel theme
- [mini.icons](https://github.com/echasnovski/mini.icons) - Icon provider
- [fyler.nvim](https://github.com/SalOrak/fyler.nvim) - Floating file explorer

### Treesitter

Syntax highlighting and code understanding:

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter configurations (with all grammars)
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Syntax-aware text objects and movement

### Coding

Auto-completion, text manipulation, and coding assistance:

- [blink.cmp](https://github.com/Saghen/blink.cmp) - Fast completion plugin with LSP, path, snippets, and buffer sources
- [colorful-menu.nvim](https://github.com/blink-cmp/colorful-menu.nvim) - Syntax highlighting in completion menu
- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Auto-pair brackets and quotes
- [mini.ai](https://github.com/echasnovski/mini.ai) - Enhanced text objects (functions, classes, parameters, blocks)
- [mini.surround](https://github.com/echasnovski/mini.surround) - Add/delete/replace surrounding characters
- [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) - Treesitter-powered commenting

### Editor

Navigation, search, and editing enhancements:

- [flash.nvim](https://github.com/folke/flash.nvim) - Fast navigation with labels and treesitter selection
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Display keybinding hints
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git decorations (signs, blame, hunk operations)
- [trouble.nvim](https://github.com/folke/trouble.nvim) - Pretty diagnostics and quickfix list
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - Highlight and search TODO comments
- [harpoon2](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) - Quick file navigation bookmarks
- [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) - Find and replace with live preview
- [dial.nvim](https://github.com/monaqa/dial.nvim) - Enhanced increment/decrement for dates, booleans, etc.

### LSP

Language Server Protocol support:

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration (lua_ls, nixd pre-configured)
- [fidget.nvim](https://github.com/j-hui/fidget.nvim) - LSP progress notifications

### Formatting

Code formatting with format-on-save:

- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatter runner (stylua, alejandra)

### Linting

Automatic linting and diagnostics:

- [nvim-lint](https://github.com/mfussenegger/nvim-lint) - Linting framework

### UI

Status line and enhanced UI:

- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Fast status line showing mode, file, git, diagnostics, LSP
- [noice.nvim](https://github.com/folke/noice.nvim) - Enhanced command line, messages, and notifications

### Utils

Session management and utilities:

- [persistence.nvim](https://github.com/folke/persistence.nvim) - Session management with auto-save

## Key Bindings

This configuration uses `<Space>` as the leader key. Key binding groups:

- `<leader>c` - Code actions (LSP, codelens, rename)
- `<leader>f` - File/find operations
- `<leader>g` - Git operations
- `<leader>gh` - Git hunks
- `<leader>s` - Search operations (symbols, text, files)
- `<leader>u` - UI toggles (format, diagnostics)
- `<leader>x` - Diagnostics and quickfix
- `<leader>b` - Buffer operations
- `<leader>w` - Window operations
- `<leader>h` - Harpoon quick menu
- `<leader>H` - Add file to Harpoon
- `<leader>1-5` - Jump to Harpoon files 1-5

Press `<leader>?` to see all available keybindings via which-key.

## Development

### Running from Source

The configuration supports live development:

```bash
# Launch neovim directly from the built package
./result/bin/nvim

# Lua changes are loaded from your working directory
# Nix changes require rebuilding
```

### Formatting Code

```bash
# Format Lua files
stylua lua/

# Format Nix files
alejandra .
```

### Adding Plugins

1. Add plugin to `default.nix` under `plugins.opt` (or `plugins.start` for eager loading)
2. Create configuration in appropriate `lua/plugins/*.lua` file
3. Rebuild with `nix build`

See [CLAUDE.md](./CLAUDE.md) for detailed architecture documentation.

## External Tools

The following tools are included in the PATH:

- **LSPs**: nixd, lua-language-server
- **Formatters**: stylua, alejandra
- **Tools**: ripgrep, fzf

## Aliases

The package provides these command aliases:
- `nvim` - Full Neovim
- `vim` - Alias to nvim
- `vi` - Alias to nvim
- `v` - Short alias to nvim

## License

This configuration is provided as-is for personal use and modification.
