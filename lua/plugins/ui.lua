return {
  {
    'mini.icons',
    lazy = true,
    after = function()
      local icons = require 'mini.icons'
      icons.setup {
        file = {
          ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
          ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        },
        filetype = {
          dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        },
      }
      icons.mock_nvim_web_devicons()
    end,
  },

  {
    'lualine.nvim',
    event = 'DeferredUIEnter',
    before = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
      LZN.trigger_load 'nvim-web-devicons'
    end,
    after = function()
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

      require('lualine').setup {
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
            { 'filename', separator = '' },
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
            { 'harpoon2' },
          },
          lualine_y = { lsp_clients },
          lualine_z = {
            { 'location', icon = '' },
            { 'progress' },
          },
        },
      }
    end,
  },

  {
    'noice.nvim',
    event = 'DeferredUIEnter',
    after = function()
      require('noice').setup {
        cmdline = { view = 'cmdline' },
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
              },
            },
            view = 'mini',
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      }
    end,
    keys = {
      { '<leader>sn', '', desc = '+noice' },
      {
        '<S-Enter>',
        function()
          require('noice').redirect(vim.fn.getcmdline())
        end,
        mode = 'c',
        desc = 'Redirect Cmdline',
      },
      {
        '<leader>snl',
        function()
          require('noice').cmd 'last'
        end,
        desc = 'Noice Last Message',
      },
      {
        '<leader>snh',
        function()
          require('noice').cmd 'history'
        end,
        desc = 'Noice History',
      },
      {
        '<leader>sna',
        function()
          require('noice').cmd 'all'
        end,
        desc = 'Noice All',
      },
      {
        '<leader>snd',
        function()
          require('noice').cmd 'dismiss'
        end,
        desc = 'Dismiss All',
      },
      {
        '<leader>snt',
        function()
          require('noice').cmd 'pick'
        end,
        desc = 'Noice Picker (Telescope/FzfLua)',
      },
      {
        '<c-f>',
        function()
          if not require('noice.lsp').scroll(4) then
            return '<c-f>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll Forward',
        mode = { 'i', 'n', 's' },
      },
      {
        '<c-b>',
        function()
          if not require('noice.lsp').scroll(-4) then
            return '<c-b>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll Backward',
        mode = { 'i', 'n', 's' },
      },
    },
  },

  {
    'markview.nvim',
    lazy = false,
    before = function()
      LZN.trigger_load 'mini.icons'
    end,
    after = function()
      require('markview').setup {
        preview = {
          icon_provider = 'mini',
        },
      }
    end,
    keys = {
      {
        '<leader>mp',
        '<cmd>Markview<cr>',
        ft = 'markdown',
        desc = 'Toggle markdown preview',
      },
      {
        '<leader>ms',
        '<cmd>Markview splitToggle<cr>',
        ft = 'markdown',
        desc = 'Toggle markdown split view',
      },
    },
  },
}
