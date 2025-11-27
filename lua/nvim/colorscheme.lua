require('catppuccin').setup {
  flavour = 'mocha',
  default_integrations = false,
  integrations = {
    blink_cmp = true,
  },
}
vim.cmd.colorscheme 'catppuccin'
