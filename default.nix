{
  pkgs,
  neovim,
  mnw,
}:
mnw.lib.wrap pkgs {
  inherit neovim;

  enable = true;
  desktopEntry = false;

  providers = {
    nodeJs = {
      enable = true;
      package = pkgs.nodejs_24;
    };
  };

  aliases = [
    "v"
    "vi"
    "vim"
  ];

  extraBinPath = with pkgs; [
    ripgrep
    fzf
    fd
    tree-sitter
    lazygit
    fish # fish_indent

    # LSPs
    nixd
    lua-language-server
    docker-language-server
    vtsls
    tailwindcss-language-server
    ruby-lsp
    rust-analyzer
    vscode-langservers-extracted
    bash-language-server
    yaml-language-server
    hyprls
    eslint_d
    prettierd
    prettier
    shfmt

    # Formatters / linters
    stylua
    alejandra
    biome
    rubocop
  ];

  # Mirrors ~/.config/nvim/init.lua. Plugins are eagerly loaded by
  # lua/plugins/init.lua; nix installs them (see `plugins` below).
  initLua = ''
    vim.loader.enable()

    Util = require 'util'

    require 'options'
    require 'ui2'
    require 'keymaps'
    require 'autocmds'
    require 'plugins'
  '';

  plugins = let
    # Not yet in nixpkgs.
    splitjoin-nvim = pkgs.vimUtils.buildVimPlugin {
      pname = "splitjoin.nvim";
      version = "2026-07-19";
      src = pkgs.fetchFromGitHub {
        owner = "bennypowers";
        repo = "splitjoin.nvim";
        rev = "f3aaf61e5126668cb081af3bdd889a40ad7058e7";
        hash = "sha256-q3X1bxFutoREMaKKBh15gkIIX/RCkPv0MS5H3YY8Hp0=";
      };
    };
  in {
    # The config loads everything eagerly (see lua/plugins/init.lua), so all
    # plugins are `start` plugins (always on the runtimepath).
    start = with pkgs.vimPlugins; [
      catppuccin-nvim
      plenary-nvim
      mini-icons
      which-key-nvim
      snacks-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      lualine-nvim

      # Completion
      blink-cmp
      colorful-menu-nvim

      # LSP / settings
      codesettings-nvim
      conform-nvim

      # Coding
      rustaceanvim
      crates-nvim
      mini-ai
      mini-pairs
      mini-surround
      ts-comments-nvim
      splitjoin-nvim

      # Editor
      trouble-nvim
      gitsigns-nvim
      flash-nvim
      grug-far-nvim
      harpoon2
      todo-comments-nvim
      overseer-nvim
      oil-nvim
      diffs-nvim

      # UI
      render-markdown-nvim

      # Utils
      persistence-nvim

      # AI
      copilot-lua
      sidekick-nvim
    ];

    dev.nvim = {
      # you can use lib.fileset to reduce rebuilds here
      # https://noogle.dev/f/lib/fileset/toSource
      pure = ./.;
      impure =
        # This is a hack it should be a absolute path
        # here it'll only work from this directory
        "/' .. vim.uv.cwd()  .. '";
    };
  };
}
