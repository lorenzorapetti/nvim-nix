return {
  {
    'codediff.nvim',
    cmd = { 'CodeDiff' },
    beforeAll = function()
      -- Expand 'cd' into 'CodeDiff' in the command line
      vim.cmd [[cab cd CodeDiff]]
    end,
    before = function()
      LZN.trigger_load 'nui.nvim'
    end,
    after = function()
      require('codediff').setup {
        diff = {
          disable_inlay_hints = true,
        },
      }
    end,
  },
}
