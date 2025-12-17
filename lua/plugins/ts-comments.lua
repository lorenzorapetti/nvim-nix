return {
  {
    'ts-comments.nvim',
    event = 'DeferredUIEnter',
    after = function()
      require('ts-comments').setup()
    end,
  },
}
