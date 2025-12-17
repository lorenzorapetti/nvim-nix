return {
  {
    'other.nvim',
    cmd = { 'Other', 'OtherSplit', 'OtherVSplit', 'OtherTab' },
    after = function()
      require('other-nvim').setup {
        mappings = {
          'rails',
        },
        rememberBuffers = false,
      }
    end,
    keys = {
      {
        '<leader>oo',
        '<cmd>:Other<CR>',
        desc = 'Other',
      },
      {
        '<leader>os',
        '<cmd>:OtherSplit<CR>',
        desc = 'Other horizontal split',
      },
      {
        '<leader>ov',
        '<cmd>:OtherVSplit<CR>',
        desc = 'Other vertical split',
      },
      {
        '<leader>ot',
        '<cmd>:Other test<CR>',
        desc = 'Other test',
      },
    },
  },
}
