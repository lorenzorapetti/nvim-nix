{
  pkgs,
  neovim,
  mnw,
  fff-nvim,
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

    # LSPs
    nixd
    lua-language-server
    dockerfile-language-server
    docker-compose-language-service
    vtsls
    tailwindcss-language-server
    ruby-lsp
    rust-analyzer
    vscode-langservers-extracted
    eslint_d
    prettierd
    prettier
    shfmt

    # Formatters
    stylua
    alejandra
  ];

  # all files in the `lua/lazy` folder are now autoloaded, so no need
  # for an init.lua in there
  initLua = ''
    require('nvim')
    LZN = require('lz.n')
    LZN.load('plugins')
  '';

  plugins = let
    codesettings-nvim = pkgs.vimUtils.buildVimPlugin {
      pname = "codesettings.nvim";
      version = "2026-02-17";
      src = pkgs.fetchFromGitHub {
        owner = "mrjones2014";
        repo = "codesettings.nvim";
        rev = "1e6c7f68abe0bda0d95353c572e31c86a910b459";
        sha256 = "sha256-XC0oxNcQze2jcKdJ5lpDQte6aZXAc2XNOKgx/y/WKJY=";
      };
      nvimSkipModules = [
        "codesettings.build.cli"
      ];
    };
  in {
    start = with pkgs.vimPlugins;
      [
        lz-n
        plenary-nvim
        snacks-nvim
        catppuccin-nvim
        mini-icons
        mini-files
        nui-nvim

        # Treesitter
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
      ]
      ++ [
        fff-nvim
      ];

    # Anything that you're loading lazily should be put here
    opt = with pkgs.vimPlugins; [
      # Coding
      mini-pairs
      mini-ai
      ts-comments-nvim
      blink-cmp
      colorful-menu-nvim
      mini-surround
      codediff-nvim
      rustaceanvim
      crates-nvim

      # Editor
      grug-far-nvim
      flash-nvim
      which-key-nvim
      gitsigns-nvim
      trouble-nvim
      todo-comments-nvim
      harpoon2
      dial-nvim
      other-nvim

      # LSP
      fidget-nvim
      nvim-lspconfig
      codesettings-nvim

      # Formatting
      conform-nvim

      # Linting
      nvim-lint

      # UI
      lualine-nvim
      noice-nvim
      render-markdown-nvim

      # Utils
      persistence-nvim

      # AI
      copilot-lua
      avante-nvim
      blink-cmp-avante
    ];

    dev.nvim = {
      # you can use lib.fileset to reduce rebuilds here
      # https://noogle.dev/f/lib/fileset/toSource
      pure = ./.;
      impure =
        # This is a hack it should be a absolute path
        # here it'll only work from this directory
        "/' .. vim.uv.cwd()  .. '/nvim";
    };
  };
}
