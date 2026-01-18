return {
  {
    'nvim-treesitter',
    after = function()
      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then
          return
        end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` enable it after ensuring it is installed
            require('nvim-treesitter').install(language):await(function()
              treesitter_try_attach(buf, language)
            end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })

      -- ensure basic parser are installed
      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'yaml',
        'json',
        'toml',
        'javascript',
        'typescript',
        'jsx',
        'tsx',
        'css',
        'scss',
        'ruby',
        'rust',
      }
      require('nvim-treesitter').install(parsers)
    end,
  },

  {
    'nvim-treesitter-textobjects',
    beforeAll = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
    before = function()
      LZN.trigger_load 'nvim-treesitter'
    end,
    after = function()
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
    end,
  },
}
