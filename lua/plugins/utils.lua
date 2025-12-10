return {
  {
    'persistence.nvim',
    event = 'BufReadPre',
    after = function()
      require('persistence').setup()
    end,
  },
}
