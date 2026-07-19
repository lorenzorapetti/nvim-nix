require('oil').setup {
  default_file_explorer = false,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['q'] = { 'actions.close', mode = 'n' },
    ['gq'] = { 'actions.send_to_qflist', opts = { action = 'r' }, mode = 'n' },
    ['-'] = { 'actions.parent', mode = 'n' },
    ['gp'] = { 'actions.preview', mode = 'n' },
  },
  float = {
    max_width = 0.7,
    max_height = 0.8,
  },
}

vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory', silent = true })
