# Agent Instructions for Neovim-Nix Configuration

This repository hosts a declarative Neovim configuration built with Nix flakes and the `mnw` wrapper.

## 1. Build & Verification

Since this is a configuration repository, "testing" primarily involves building the derivation and verifying it launches correctly.

### Build Commands
- **Build Config:** `nix build` (Produces `./result`)
- **Run Built Neovim:** `./result/bin/nvim`
- **Aliases:** `./result/bin/v`, `./result/bin/vi`

### Verification
There is no automated unit test suite (e.g., busted). Verification is manual or build-based.
- **Check Syntax/Build:** If `nix build` succeeds, the Nix expressions are valid.
- **Runtime Check:** Launch `./result/bin/nvim --headless -c 'quit'` to verify startup without errors.
- **Impure Dev Mode:**
    - Lua changes in `lua/` apply immediately when running `nvim` from this directory if configured in `default.nix` (impure mode).
    - Nix changes always require `nix build`.

### Linting & Formatting
- **Lua:** `stylua lua/`
    - Style: 2 spaces indent, 160 char width, single quotes (`.stylua.toml`).
- **Nix:** `alejandra .`
    - Style: 2 spaces indent.

## 2. Code Style & Conventions

### Language Standards
- **Lua:** Use Lua 5.1/JIT compatible syntax.
    - Prefer local variables.
    - Use `vim.tbl_...` for table operations.
    - Use `vim.api.nvim_...` for Neovim API calls.
- **Nix:** Follow standard Nixpkgs conventions.
    - Organize inputs in `flake.nix`.
    - Configure plugins in `default.nix`.

### Plugin Architecture (Crucial)
This config uses a specific "Nix to Lua" bootstrap pattern.
1. **Definition:** Plugins must be declared in `default.nix` under `plugins.start` (eager) or `plugins.opt` (lazy).
2. **Configuration:** Lua config lives in `lua/plugins/*.lua`.
3. **Loader:** Uses `lz.n` (exposed as global `LZN`).
    - **Do NOT** use `lazy.nvim` syntax (e.g., `dependencies`, `opts` table automatic setup).
    - **DO** use `lz.n` syntax:
      ```lua
      {
        'plugin-name',
        event = 'DeferredUIEnter',
        after = function()
          require('plugin').setup({ ... })
        end
      }
      ```

### Key Globals & Modules
Do not re-implement existing utilities. Use the provided globals:
- **`Snacks`**: The central UI framework (fuzzy finder, notifications, etc.). Use `Snacks.picker` instead of Telescope.
- **`Util`**: Utility module (`lua/nvim/util`).
    - `Util.root()`: Get project root.
    - `Util.icons`: Access standard icons.

### Naming Conventions
- **Files:** snake_case (e.g., `lua/plugins/mini_ai.lua`).
- **Variables:** snake_case for locals, CamelCase for classes/modules (e.g., `local util = require('nvim.util')`).
- **Private:** Prefix with underscore `_local_function`.

### Adding New Tools (LSP/Formatters)
Do not just add Lua config. You must expose the binary via Nix:
1. Add the tool to `extraBinPath` in `default.nix`.
2. Configure the LSP in `lua/plugins/lsp.lua` or formatter in `lua/plugins/formatting.lua`.

## 3. Error Handling
- Use `pcall`/`xpcall` when requiring optional modules or running external commands that might fail.
- For UI notifications, prefer `Snacks.notify` over `vim.notify` if advanced formatting is needed, though `vim.notify` is aliased to Noice/Snacks usually.

## 4. Documentation
- Update `CLAUDE.md` if architectural patterns change.
- Comments should explain *why* a configuration exists, especially if it's a workaround for a specific plugin behavior or Nix idiosyncrasy.
