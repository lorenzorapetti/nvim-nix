return {
  {
    'mini.pairs',
    event = 'DeferredUIEnter',
    after = function()
      require('mini.pairs').setup {
        modes = { insert = true, command = false, terminal = false },
      }
    end,
  },
}
