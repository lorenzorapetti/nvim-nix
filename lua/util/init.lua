local M = {}

M.root = require 'util.root'

M.icons = require 'util.icons'

M.lsp = require 'util.lsp'

M.keymap = require 'util.keymap'

M.navigation = require 'util.navigation'

M.navigation.setup {}

return M
