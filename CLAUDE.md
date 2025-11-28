# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix-based Neovim configuration using the `mnw` (minimal neovim wrapper) library. The configuration is built declaratively through Nix flakes and provides a complete IDE-like experience with LSP, completion, formatting, and linting.

## Build and Development Commands

### Building the Configuration

```bash
# Build the Neovim configuration
nix build

# Run the built Neovim directly
./result/bin/nvim

# Or use any of the configured aliases
./result/bin/v
./result/bin/vi
./result/bin/vim
```

### Development Workflow

The configuration uses a dual development mode (pure/impure) defined in `default.nix`:
- **Pure mode**: Changes in the nix store (requires rebuild)
- **Impure mode**: Live development from current directory (`dev.nvim.impure`)

To test changes without rebuilding:
- Lua changes in `lua/` are loaded directly from the working directory
- Nix changes require `nix build` to take effect

### Formatting

```bash
# Format Lua files with stylua
stylua lua/

# Format Nix files with alejandra
alejandra .
```

Configuration follows:
- Lua: 2 spaces, 160 char width, single quotes (`.stylua.toml`)
- Nix: 2 spaces (`.editorconfig`)

## Architecture

### Nix Layer (`flake.nix`, `default.nix`)

The configuration is bootstrapped through Nix:
1. `flake.nix` defines inputs (nixpkgs, mnw) and creates the package
2. `default.nix` is the core configuration using `mnw.lib.wrap`:
   - Declares all plugins split into `start` (eager) and `opt` (lazy loaded)
   - Configures `extraBinPath` for LSPs (nixd, lua-language-server), formatters (stylua, alejandra), and tools (ripgrep, fzf)
   - Sets `initLua` to bootstrap the Lua configuration

### Lua Layer

**Entry point**: `lua/nvim/init.lua` loads core modules in order:
1. `nvim.snacks` - Snacks.nvim setup (used throughout)
2. `nvim.util` - Utility modules (root detection, icons)
3. `nvim.options` - Vim options
4. `nvim.autocmd` - Autocommands
5. `nvim.keymaps` - Global keymaps
6. `nvim.colorscheme` - Theme setup

Then `LZN.load('plugins')` triggers lazy loading via `lz.n`.

**Plugin organization** (`lua/plugins/`):
- `coding.lua` - Completion (blink.cmp), pairs, surround, comments, text objects (mini.ai)
- `editor.lua` - File explorer (fyler), search/replace (grug-far), navigation (flash, harpoon), git (gitsigns), diagnostics (trouble, todo-comments), incremental operations (dial)
- `lsp.lua` - LSP configuration (lua_ls, nixd), keymaps, diagnostics setup
- `formatting.lua` - conform.nvim with autoformat toggle
- `linting.lua` - nvim-lint with debounced linting
- `ui.lua` - Status line (lualine), notifications (noice), icons (mini.icons)
- `treesitter.lua` - Treesitter configuration
- `utils.lua` - Session persistence

### Lazy Loading Strategy

Uses `lz.n` for lazy loading with these events:
- `DeferredUIEnter` - Most UI plugins, LSP
- `BufReadPost`, `BufWritePost`, `BufNewFile` - File-based plugins
- `InsertEnter`, `CmdlineEnter` - Insert mode plugins
- Key mappings - Many plugins load on first keypress
- Commands - Some load on command execution

### Key Utilities

**Snacks.nvim** (`lua/nvim/snacks.lua`): Central UI framework providing:
- Dashboard, picker (fuzzy finder), notifications, terminal, statuscolumn, words, zen mode, file operations

**Util module** (`lua/nvim/util/init.lua`): Exposes:
- `Util.root` - Root directory detection
- `Util.icons` - Icon definitions for kinds, git, etc.

### LSP Setup Pattern

LSP configuration in `lua/plugins/lsp.lua`:
1. Uses `vim.lsp.config()` to configure servers (lua_ls, nixd)
2. `vim.lsp.enable()` activates them
3. Keymaps bound via `LspAttach` autocmd
4. LSP pickers from Snacks (`Snacks.picker.lsp_definitions()`, etc.)

### Completion Setup

`blink.cmp` (`lua/plugins/coding.lua`):
- Integrates with `colorful-menu.nvim` for syntax-highlighted completions
- Snippets loaded from `~/nvim-nix/snippets/`
- Custom `<Tab>` behavior: expands snippets matching keyword
- Sources: LSP, path, snippets, buffer

## Important Patterns

### Adding a New Plugin

1. Add to `default.nix` under `plugins.opt` (or `plugins.start` if eager)
2. Create plugin spec in appropriate `lua/plugins/*.lua`:
   ```lua
   {
     'plugin-name',
     event = 'DeferredUIEnter',  -- or keys, cmd, etc.
     after = function()
       require('plugin').setup {}
     end,
   }
   ```
3. If needed before another plugin loads, use `before` function with `LZN.trigger_load`

### Adding LSP/Formatter/Linter

1. Add tool to `extraBinPath` in `default.nix`
2. For LSP: Add config in `lua/plugins/lsp.lua` and enable via `vim.lsp.enable()`
3. For formatter: Add to `formatters_by_ft` in `lua/plugins/formatting.lua`
4. For linter: Add to `linters_by_ft` in `lua/plugins/linting.lua`

### Global Variables/Functions

Set early and used throughout:
- `Snacks` - Snacks.nvim instance (set in `lua/nvim/snacks.lua`)
- `Util` - Utility module (set in `lua/nvim/init.lua`)
- `LZN` - lz.n instance (set in `default.nix` initLua)

### Keymap Conventions

Leader key prefixes (defined in `lua/plugins/editor.lua` via which-key):
- `<leader>c` - code actions
- `<leader>f` - file/find operations
- `<leader>g` - git operations
- `<leader>s` - search operations
- `<leader>u` - UI toggles
- `<leader>x` - diagnostics/quickfix
- `<leader>b` - buffer operations
- `<leader>w` - window operations

## Development Notes

- Plugin specs return a table (or list of tables) with lz.n configuration
- The `after` function runs when plugin loads; `before` runs just before
- Use `Snacks.picker.*` for fuzzy finding (replaces telescope)
- Use `Snacks.toggle()` for creating toggleable settings
- Icons defined in `lua/nvim/util/icons.lua`, accessed via `Util.icons`
