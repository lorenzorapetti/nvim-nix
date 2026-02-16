vim.g.fff = {
  max_threads = 8,
  keymaps = {
    move_up = { '<Up>', '<C-p>', '<C-k>' },
    move_down = { '<Down>', '<C-n>', '<C-j>' },
  },
  grep = {
    modes = { 'fuzzy', 'plain', 'regex' },
  },
}

vim.keymap.set('n', '<leader><space>', function()
  require('fff').find_files()
end, { desc = 'Find files', silent = true })
vim.keymap.set('n', '<leader>/', function()
  require('fff').live_grep()
end, { desc = 'Find files', silent = true })
