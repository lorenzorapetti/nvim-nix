vim.g.lualine_laststatus = vim.o.laststatus
if vim.fn.argc(-1) > 0 then
  -- set an empty statusline till lualine loads
  vim.o.statusline = ' '
else
  -- hide the statusline on the starter page
  vim.o.laststatus = 0
end

require 'plugins/diffs'

-- Plugins are installed by nix (see default.nix); no vim.pack.add here.

package.preload['nvim-web-devicons'] = function()
  require('mini.icons').mock_nvim_web_devicons()
  return package.loaded['nvim-web-devicons']
end

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

require 'plugins/colorscheme'
require 'plugins/mini-icons'
require 'plugins/snacks'
require 'plugins/treesitter'
require 'plugins/treesitter-textobjects'
require 'plugins/lualine'
require 'plugins/blink'
require 'plugins/codesettings'
require 'plugins/lsp'
require 'plugins/conform'
require 'plugins/rustaceanvim'
require 'plugins/crates'
require 'plugins/mini-ai'
require 'plugins/mini-pairs'
require 'plugins/mini-surround'
require 'plugins/trouble'
require 'plugins/gitsigns'
require 'plugins/flash'
require 'plugins/grug-far'
require 'plugins/harpoon'
require 'plugins/persistence'
require 'plugins/render-markdown'
require 'plugins/todo-comments'
require 'plugins/ts-comments'
require 'plugins/overseer'
require 'plugins/oil'
require 'plugins/copilot'
require 'plugins/sidekick'
require 'plugins/splitjoin'
require 'plugins/obsidian'
require 'plugins/which-key'

vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#1E1E2E', fg = '#89B4FA', force = true })
vim.api.nvim_set_hl(0, 'PopupNormal', { bg = '#1E1E2E' })
vim.api.nvim_set_hl(0, 'SnacksPickerBorder', { bg = '#181825', fg = '#89B4FA', force = true })
