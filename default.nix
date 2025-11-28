{
  pkgs,
  mnw,
}:
mnw.lib.wrap pkgs {
  neovim = pkgs.neovim-unwrapped;

  enable = true;
  desktopEntry = false;

  aliases = [
    "v"
    "vi"
    "vim"
  ];

  extraBinPath = with pkgs; [
    ripgrep
    fzf

    # LSPs
    nixd
    lua-language-server
    dockerfile-language-server
    docker-compose-language-service

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

  plugins = {
    start = with pkgs.vimPlugins; [
      lz-n
      plenary-nvim
      snacks-nvim
      catppuccin-nvim
      mini-icons
      fyler-nvim
      smart-splits-nvim

      # Treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
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

      # Editor
      grug-far-nvim
      flash-nvim
      which-key-nvim
      gitsigns-nvim
      trouble-nvim
      todo-comments-nvim
      harpoon2
      dial-nvim

      # LSP
      fidget-nvim
      nvim-lspconfig

      # Formatting
      conform-nvim

      # Linting
      nvim-lint

      # UI
      lualine-nvim
      noice-nvim
      markview-nvim

      # Utils
      persistence-nvim
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
