require('overseer').setup {
  dap = false,
  task_list = {
    keymaps = {
      ['<C-j>'] = false,
      ['<C-k>'] = false,
    },
  },
  form = {
    win_opts = {
      winblend = 0,
    },
  },
  task_win = {
    win_opts = {
      winblend = 0,
    },
  },
}

Util.keymap.set('n', '<leader>ow', '<cmd>OverseerToggle!<cr>', { desc = 'Task list' })
Util.keymap.set('n', '<leader>oo', '<cmd>OverseerRun<cr>', { desc = 'Run task' })
Util.keymap.set('n', '<leader>ot', '<cmd>OverseerTaskAction<cr>', { desc = 'Task action' })
