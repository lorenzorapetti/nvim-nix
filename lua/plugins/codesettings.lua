return {
  {
    'codesettings.nvim',
    ft = { 'json', 'jsonc', 'lua' },
    after = function()
      require('codesettings').setup()
    end,
  },
}
