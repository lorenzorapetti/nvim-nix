require('nvim-treesitter-textobjects').setup {
  move = {
    set_jumps = true,
  },
}

local swap = require 'nvim-treesitter-textobjects.swap'
local move = require 'nvim-treesitter-textobjects.move'

local function map(key, func, query, desc, mode)
  vim.keymap.set(mode or 'n', key, function()
    func(query)
  end, { silent = true, desc = desc })
end

local map_move = function(key, func, query, desc, mode)
  map(key, func, query, 'Goto ' .. desc, { 'n', 'x', 'o' })
end

map('<leader>csa', swap.swap_next, '@parameter.inner', 'Swap with next parameter')
map('<leader>csf', swap.swap_next, '@function.inner', 'Swap with next function')
map('<leader>csA', swap.swap_previous, '@parameter.inner', 'Swap with previous parameter')
map('<leader>csF', swap.swap_previous, '@function.inner', 'Swap with previous function')

map_move(']f', move.goto_next_start, '@function.outer', 'next function start')
map_move(']c', move.goto_next_start, '@class.outer', 'next class start')
map_move(']a', move.goto_next_start, '@parameter.inner', 'next parameter start')
map_move(']F', move.goto_next_end, '@function.outer', 'next function end')
map_move(']C', move.goto_next_end, '@class.outer', 'next class end')
map_move(']A', move.goto_next_end, '@parameter.inner', 'next parameter end')
map_move('[f', move.goto_previous_start, '@function.outer', 'previous function start')
map_move('[c', move.goto_previous_start, '@class.outer', 'previous class start')
map_move('[a', move.goto_previous_start, '@parameter.inner', 'previous parameter start')
map_move('[F', move.goto_previous_end, '@function.outer', 'previous function end')
map_move('[C', move.goto_previous_end, '@class.outer', 'previous class end')
map_move('[A', move.goto_previous_end, '@parameter.inner', 'previous parameter end')
