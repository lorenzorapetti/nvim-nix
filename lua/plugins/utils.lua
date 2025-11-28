return {
  {
    'smart-splits.nvim',
    lazy = false,
    after = function()
      require('smart-splits').setup()

      local function map(mode, lhs, rhs, desc)
        Snacks.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
      end

      Snacks.keymap.del('n', '<C-h>')
      Snacks.keymap.del('n', '<C-j>')
      Snacks.keymap.del('n', '<C-k>')
      Snacks.keymap.del('n', '<C-l>')

      map('n', '<C-h>', function()
        require('smart-splits').move_cursor_left()
      end)
      map('n', '<C-j>', function()
        require('smart-splits').move_cursor_down()
      end)
      map('n', '<C-k>', function()
        require('smart-splits').move_cursor_up()
      end)
      map('n', '<C-l>', function()
        require('smart-splits').move_cursor_right()
      end)
    end,
  },

  {
    'persistence.nvim',
    event = 'BufReadPre',
    after = function()
      require('persistence').setup()
    end,
  },
}
