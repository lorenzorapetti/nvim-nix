require('harpoon').setup {
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  },
  settings = {
    save_on_toggle = true,
  },
}

Util.keymap.set('n', '<leader>H', function()
  require('harpoon'):list():add()
end, { desc = 'Harpoon File' })
Util.keymap.set('n', '<leader>h', function()
  local harpoon = require 'harpoon'
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon Quick Menu' })
Util.keymap.set('n', '<leader>1', function()
  require('harpoon'):list():select(1)
end, { desc = 'Harpoon to File 1' })
Util.keymap.set('n', '<leader>2', function()
  require('harpoon'):list():select(2)
end, { desc = 'Harpoon to File 2' })
Util.keymap.set('n', '<leader>3', function()
  require('harpoon'):list():select(3)
end, { desc = 'Harpoon to File 3' })
Util.keymap.set('n', '<leader>4', function()
  require('harpoon'):list():select(4)
end, { desc = 'Harpoon to File 4' })
Util.keymap.set('n', '<leader>5', function()
  require('harpoon'):list():select(5)
end, { desc = 'Harpoon to File 5' })
