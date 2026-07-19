require('flash').setup {
  labels = 'fdsaghjklrewqtyuiopvcxzbnm',
  modes = {
    char = {
      enabled = false,
    },
    treesitter = {
      labels = 'fdsaghjklrewqtyuiopvcxzbnm',
    },
  },
}

Util.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash' })
Util.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })
Util.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })
Util.keymap.set({ 'n', 'x', 'o' }, '<c-space>', function()
  require('flash').treesitter {
    actions = {
      ['<c-space>'] = 'next',
      ['<BS>'] = 'prev',
    },
  }
end, { desc = 'Treesitter incremental selection' })
