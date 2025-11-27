return {
  {
    'nvim-treesitter',
    after = function()
      require('nvim-treesitter.configs').setup {
        sync_install = false,
        ignore_install = {},
        ensure_installed = {},
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(lang, bufnr) -- Disable in large buffers
            return vim.api.nvim_buf_line_count(bufnr) > 10000
          end,
        },
        indent = {
          enable = true,
        },
      }
    end,
  },

  {
    'nvim-treesitter-textobjects',
    before = function()
      LZN.trigger_load 'nvim-treesitter'
    end,
    after = function()
      require('nvim-treesitter.configs').setup {
        indent = {
          enable = true,
        },
        textobjects = {
          swap = {
            enable = true,
            swap_next = {
              ['<leader>csa'] = { query = '@parameter.inner', desc = 'Swap with next parameter' },
              ['<leader>csf'] = { query = '@function.inner', desc = 'Swap with next function' },
            },
            swap_previous = {
              ['<leader>csA'] = { query = '@parameter.inner', desc = 'Swap with previous parameter' },
              ['<leader>csF'] = { query = '@function.inner', desc = 'Swap with previous function' },
            },
          },
          move = {
            enable = true,
            set_jumps = true,

            goto_next_start = {
              [']f'] = { query = '@function.outer', desc = 'Goto next function start' },
              [']c'] = { query = '@class.outer', desc = 'Goto next class start' },
              [']a'] = { query = '@parameter.inner', desc = 'Goto next parameter start' },
            },
            goto_next_end = {
              [']F'] = { query = '@function.outer', desc = 'Goto next function end' },
              [']C'] = { query = '@class.outer', desc = 'Goto next class end' },
              [']A'] = { query = '@parameter.inner', desc = 'Goto next parameter end' },
            },
            goto_previous_start = {
              ['[f'] = { query = '@function.outer', desc = 'Goto previous function start' },
              ['[c'] = { query = '@class.outer', desc = 'Goto previous class start' },
              ['[a'] = { query = '@parameter.inner', desc = 'Goto previous parameter start' },
            },
            goto_previous_end = {
              ['[F'] = { query = '@function.outer', desc = 'Goto previous function end' },
              ['[C'] = { query = '@class.outer', desc = 'Goto previous class end' },
              ['[A'] = { query = '@parameter.inner', desc = 'Goto previous parameter end' },
            },
          },
        },
      }
    end,
  },
}
