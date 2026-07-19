-- Taken from https://github.com/MunsMan/kitty-navigator.nvim/blob/main/lua/kitty-navigator/init.lua

---@class Options
---@field keybindings Keybindings | nil

---@class Keybindings
---@field left string
---@field right string
---@field up string
---@field down string

local M = {}

local wezterm_dirs = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }
local kitty_dirs = { h = 'left', j = 'bottom', k = 'top', l = 'right' }
local zellij_dirs = { h = 'left', j = 'down', k = 'up', l = 'right' }

local function wezterm_cli_move(direction)
  vim.fn.system('wezterm cli activate-pane-direction ' .. wezterm_dirs[direction])
end

local function kitty_cli_move(direction)
  vim.fn.system('kitty @ kitten navigate_kitty.py ' .. kitty_dirs[direction])
end

local function zellij_cli_move(direction)
  vim.fn.system('zellij action move-focus ' .. zellij_dirs[direction])
end

local function is_wezterm()
  local term = vim.trim((vim.env.TERM_PROGRAM or ''):lower())
  return term == 'wezterm'
end

local function is_kitty()
  local term = vim.trim((vim.env.TERM_PROGRAM or ''):lower())
  return term == 'kitty'
end

local function is_zellij()
  return (vim.env.ZELLIJ or '') ~= ''
end

local function setup_user_var()
  if is_wezterm() then
    vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
      callback = function()
        local stdout = vim.loop.new_tty(1, false)
        stdout:write('\027]1337;SetUserVar=IS_NVIM=' .. vim.base64.encode 'true' .. '\007')
        stdout:close()
      end,
    })
    vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
      callback = function()
        local stdout = vim.loop.new_tty(1, false)
        stdout:write '\027]1337;SetUserVar=IS_NVIM=\007'
        stdout:close()
      end,
    })
  end
end

function M.navigate(direction)
  local left_win = vim.fn.winnr('1' .. direction)
  if vim.fn.winnr() ~= left_win then
    vim.api.nvim_command('wincmd ' .. direction)
  else
    if is_wezterm() then
      wezterm_cli_move(direction)
    elseif is_kitty() then
      kitty_cli_move(direction)
    elseif is_zellij() then
      zellij_cli_move(direction)
    end
  end
end

function M.navigateLeft()
  M.navigate 'h'
end

function M.navigateRight()
  M.navigate 'l'
end

function M.navigateUp()
  M.navigate 'k'
end

function M.navigateDown()
  M.navigate 'j'
end

---@param options Options
function M.setup(options)
  local keybindings = options.keybindings or {}

  setup_user_var()

  vim.keymap.set('n', keybindings.left or '<C-h>', M.navigateLeft, { silent = true })
  vim.keymap.set('n', keybindings.right or '<C-l>', M.navigateRight, { silent = true })
  vim.keymap.set('n', keybindings.up or '<C-k>', M.navigateUp, { silent = true })
  vim.keymap.set('n', keybindings.down or '<C-j>', M.navigateDown, { silent = true })
end

vim.api.nvim_create_user_command('NavigateLeft', M.navigateLeft, {})
vim.api.nvim_create_user_command('NavigateRight', M.navigateRight, {})

return M
