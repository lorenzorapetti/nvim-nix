local icons = Util.icons

vim.o.laststatus = vim.g.lualine_laststatus

-- Custom Lualine component to show attached language server
local lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients { bufnr = bufnr }
  if next(clients) == nil then
    return ''
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return ' ' .. table.concat(c, ' - ')
end

local lualine = require 'lualine'

local function refresh_lualine()
  lualine.refresh {
    place = { 'statusline' },
  }
end

lualine.setup {
  options = {
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    globalstatus = vim.o.laststatus == 3,
    disabled_filetypes = { statusline = { 'snacks_dashboard', 'Fyler', 'codecompanion' } },
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(str)
          return str:sub(1, 1)
        end,
        icon = '',
      },
    },
    lualine_b = {
      { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
      { 'filename', separator = '', path = 4 },
    },
    lualine_c = {
      { 'branch', icon = '' },
      {
        'diff',
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          removed = icons.git.removed,
        },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },
    },

    lualine_x = {
      {
        'diagnostics',
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        update_in_insert = true,
      },
      {
        function()
          return require('noice').api.status.command.get()
        end,
        cond = function()
          return package.loaded['noice'] and require('noice').api.status.command.has()
        end,
        color = function()
          return { fg = Snacks.util.color 'Statement' }
        end,
      },
      {
        function()
          local recording_register = vim.fn.reg_recording()

          if recording_register == '' then
            return ''
          else
            return 'Recording @' .. recording_register
          end
        end,
      },
    },
    lualine_y = { lsp_clients },
    lualine_z = {
      { 'location', icon = '' },
      { 'progress' },
    },
  },
}

vim.api.nvim_create_autocmd('RecordingEnter', { callback = refresh_lualine })
vim.api.nvim_create_autocmd('RecordingLeave', {
  callback = function()
    local timer = vim.loop.new_timer()
    timer:start(50, 0, vim.schedule_wrap(refresh_lualine))
  end,
})
