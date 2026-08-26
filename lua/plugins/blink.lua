local cmp = require 'blink.cmp'

require('colorful-menu').setup()

cmp.setup {
  snippets = {
    preset = 'default',
  },

  appearance = {
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',

    kind_icons = Util.icons.kinds,
  },

  cmdline = {
    keymap = {
      preset = 'inherit',
      ['<Tab>'] = { 'show', 'accept' },
    },
    completion = {
      menu = {
        auto_show = function(ctx)
          return vim.fn.getcmdtype() == ':'
          -- enable for inputs as well, with:
          -- or vim.fn.getcmdtype() == '@'
        end,
      },
    },
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

  fuzzy = {
    implementation = 'rust',
  },

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
      markdown = {
        inherit_defaults = true,
        'dictionary',
      },
    },
  },
}
