vim.g.sidekick_nes = false

require('sidekick').setup()

Util.keymap.set('n', '<leader>aa', function()
  require('sidekick.cli').toggle()
end, { desc = 'Toggle Sidekick' })
Util.keymap.set('n', '<leader>as', function()
  require('sidekick.cli').select { filter = { installed = true } }
end, { desc = 'Select CLI' })
Util.keymap.set('n', '<leader>ad', function()
  require('sidekick.cli').close()
end, { desc = 'Detach a CLI session' })
Util.keymap.set({ 'x', 'n' }, '<leader>at', function()
  require('sidekick.cli').send { msg = '{this}' }
end, { desc = 'Send this' })
Util.keymap.set('n', '<leader>af', function()
  require('sidekick.cli').send { msg = '{file}' }
end, { desc = 'Send file' })
Util.keymap.set('x', '<leader>av', function()
  require('sidekick.cli').send { msg = '{selection}' }
end, { desc = 'Send visual selection' })
Util.keymap.set({ 'x', 'n' }, '<leader>ap', function()
  require('sidekick.cli').prompt()
end, { desc = 'Select prompt' })
