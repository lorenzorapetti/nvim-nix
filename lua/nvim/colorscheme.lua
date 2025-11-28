require('catppuccin').setup {
  flavour = 'mocha',
  default_integrations = false,
  integrations = {
    blink_cmp = true,
    gitsigns = true,
    fidget = true,
    flash = true,
    grug_far = true,
    harpoon = true,
    markview = true,
    mini = {
      enabled = true,
    },
    noice = true,
    snacks = {
      enabled = true,
    },
    lsp_trouble = true,
    which_key = true,
  },
}
vim.cmd.colorscheme 'catppuccin'
