return {
  {
    'markview.nvim',
    lazy = false,
    before = function()
      LZN.trigger_load 'mini.icons'
    end,
    after = function()
      require('markview').setup {
        preview = {
          icon_provider = 'mini',
        },
      }
    end,
    keys = {
      {
        '<leader>mp',
        '<cmd>Markview<cr>',
        ft = 'markdown',
        desc = 'Toggle markdown preview',
      },
      {
        '<leader>ms',
        '<cmd>Markview splitToggle<cr>',
        ft = 'markdown',
        desc = 'Toggle markdown split view',
      },
    },
  },
}
