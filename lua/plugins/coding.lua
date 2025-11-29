return {
  {
    'mini.pairs',
    event = 'DeferredUIEnter',
    after = function()
      require('mini.pairs').setup {
        modes = { insert = true, command = false, terminal = false },
      }
    end,
  },

  {
    'mini.surround',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    after = function()
      require('mini.surround').setup {
        mappings = {
          add = 'gsa', -- Add surrounding in Normal and Visual modes
          delete = 'gsd', -- Delete surrounding
          find = 'gsf', -- Find surrounding (to the right)
          find_left = 'gsF', -- Find surrounding (to the left)
          highlight = 'gsh', -- Highlight surrounding
          replace = 'gsr', -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`
        },
      }
    end,
  },

  {
    'ts-comments.nvim',
    event = 'DeferredUIEnter',
    after = function()
      require('ts-comments').setup()
    end,
  },

  {
    'mini.ai',
    event = 'DeferredUIEnter',
    after = function()
      local ai = require 'mini.ai'

      ai.setup {
        -- Number of lines within which textobject is searched
        n_lines = 500,

        custom_textobjects = {
          a = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },

          o = ai.gen_spec.treesitter { -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },

          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },

          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },

          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Main textobject prefixes
          around = 'a',
          inside = 'i',

          -- Next/last variants
          -- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
          -- Map LSP selection manually to use it (see `:h MiniAi.config`)
          around_next = 'an',
          inside_next = 'in',
          around_last = 'al',
          inside_last = 'il',

          -- Move cursor to corresponding edge of `a` textobject
          goto_left = 'g[',
          goto_right = 'g]',
        },

        search_method = 'cover_or_next',

        silent = true,
      }
    end,
  },

  {
    'colorful-menu.nvim',
    lazy = true,
    after = function()
      require('colorful-menu').setup()
    end,
  },

  {
    'blink.cmp',
    event = { 'BufReadPost', 'InsertEnter', 'CmdlineEnter' },
    before = function()
      LZN.trigger_load 'colorful-menu.nvim'
    end,
    after = function()
      require('blink-cmp').setup {
        cmdline = { enabled = false },

        snippets = {
          preset = 'default',
        },

        appearance = {
          -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',

          kind_icons = Util.icons.kinds,
        },

        completion = {
          accept = { auto_brackets = { enabled = false } },
          menu = {
            scrollbar = false,
            draw = {
              columns = { { 'kind_icon' }, { 'label', gap = 1 } },
              components = {
                label = {
                  text = function(ctx)
                    return require('colorful-menu').blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require('colorful-menu').blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = false,
            window = {
              scrollbar = false,
            },
          },
          ghost_text = {
            enabled = false,
          },
          list = {
            selection = {
              preselect = true,
              auto_insert = false,
            },
          },
        },

        fuzzy = { implementation = 'prefer_rust_with_warning' },

        keymap = {
          preset = 'default',

          ['<C-o>'] = { 'select_and_accept', 'fallback' },
          ['<Tab>'] = {
            function(cmp)
              if not cmp.is_visible() then
                return
              end

              local keyword = require('blink.cmp.completion.list').context.get_keyword()
              local accept_index = nil

              for index, item in ipairs(cmp.get_items()) do
                if item.source_id == 'snippets' and item.label == keyword then
                  accept_index = index
                  break
                end
              end

              if accept_index then
                cmp.accept { index = accept_index }
                return true
              end
            end,
            'snippet_forward',
            'fallback',
          },
        },

        signature = { enabled = true },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },

          per_filetype = {
            codecompanion = { 'codecompanion' },
          },

          providers = {
            snippets = {
              opts = {
                search_paths = { '~/nvim-nix/snippets' },
              },
            },
          },
        },
      }
    end,
  },
}
