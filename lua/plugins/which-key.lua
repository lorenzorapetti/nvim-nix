require('which-key').setup {
  preset = 'helix',
  defaults = {},
  spec = {
    {
      mode = { 'n', 'x' },
      { '<leader>a', group = 'ai' },
      { '<leader>c', group = 'code' },
      { '<leader>d', group = 'debug' },
      { '<leader>f', group = 'file/find' },
      { '<leader>g', group = 'git' },
      { '<leader>gh', group = 'hunks' },
      { '<leader>o', group = 'other', icon = { icon = '󰈔', color = 'blue' } },
      { '<leader>q', group = 'quit' },
      { '<leader>s', group = 'search' },
      { '<leader>u', group = 'ui' },
      { '<leader>x', group = 'diagnostics/quickfix' },
      { '[', group = 'prev' },
      { ']', group = 'next' },
      { 'g', group = 'goto' },
      { 'gs', group = 'surround' },
      { 'z', group = 'fold' },
      {
        '<leader>b',
        group = 'buffer',
        expand = function()
          return require('which-key.extras').expand.buf()
        end,
      },
      {
        '<leader>w',
        group = 'windows',
        proxy = '<c-w>',
        expand = function()
          return require('which-key.extras').expand.win()
        end,
      },
      -- better descriptions
      { 'gx', desc = 'Open with system app' },
    },
  },
}

vim.keymap.set('n', '<leader>?', function()
  require('which-key').show()
end, { desc = 'Buffer Keymaps', silent = true })
