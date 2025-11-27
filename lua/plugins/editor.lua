local M = {}

---@param increment boolean
---@param g? boolean
function M.dial(increment, g)
  local mode = vim.fn.mode(true)
  -- Use visual commands for VISUAL 'v', VISUAL LINE 'V' and VISUAL BLOCK '\22'
  local is_visual = mode == 'v' or mode == 'V' or mode == '\22'
  local func = (increment and 'inc' or 'dec') .. (g and '_g' or '_') .. (is_visual and 'visual' or 'normal')
  local group = vim.g.dials_by_ft[vim.bo.filetype] or 'default'
  return require('dial.map')[func](group)
end

return {
  {
    'fyler.nvim',
    lazy = false,
    before = function()
      LZN.trigger_load 'mini.icons'
    end,
    after = function()
      require('fyler').setup {}
    end,
    keys = {
      {
        '-',
        '<cmd>Fyler kind=float<cr>',
        desc = 'Open Floating File Explorer',
      },
    },
  },

  {
    'grug-far.nvim',
    cmd = { 'GrugFar', 'GrugFarWithin' },
    after = function()
      require('grug-far').setup {
        headerMaxWidth = 80,
      }
    end,
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require 'grug-far'
          local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
          }
        end,
        mode = { 'n', 'x' },
        desc = 'Search and Replace',
      },
    },
  },

  {
    'flash.nvim',
    event = 'DeferredUIEnter',
    after = function()
      require('flash').setup()
    end,
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
      -- Simulate nvim-treesitter incremental selection
      {
        '<c-space>',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').treesitter {
            actions = {
              ['<c-space>'] = 'next',
              ['<BS>'] = 'prev',
            },
          }
        end,
        desc = 'Treesitter Incremental Selection',
      },
    },
  },

  {
    'which-key.nvim',
    event = 'DeferredUIEnter',
    after = function()
      require('which-key').setup {
        preset = 'helix',
        defaults = {},
        spec = {
          {
            mode = { 'n', 'x' },
            { '<leader>c', group = 'code' },
            { '<leader>d', group = 'debug' },
            -- { "<leader>dp", group = "profiler" },
            { '<leader>f', group = 'file/find' },
            { '<leader>g', group = 'git' },
            { '<leader>gh', group = 'hunks' },
            { '<leader>q', group = 'quit' },
            { '<leader>s', group = 'search' },
            { '<leader>u', group = 'ui' },
            { '<leader>x', group = 'diagnostics/quickfix' },
            { '[', group = 'prev' },
            { ']', group = 'next' },
            { 'g', group = 'goto' },
            { 'gs', group = 'surround' },
            { 'z', group = 'fold' },
            {
              '<leader>b',
              group = 'buffer',
              expand = function()
                return require('which-key.extras').expand.buf()
              end,
            },
            {
              '<leader>w',
              group = 'windows',
              proxy = '<c-w>',
              expand = function()
                return require('which-key.extras').expand.win()
              end,
            },
            -- better descriptions
            { 'gx', desc = 'Open with system app' },
          },
        },
      }
    end,
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Keymaps (which-key)',
      },
    },
  },

  {
    'gitsigns.nvim',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    after = function()
      local gs = require 'gitsigns'
      gs.setup {
        signs = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
          untracked = { text = '▎' },
        },
        signs_staged = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
        },
        on_attach = function(buffer)
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
          end

          map('n', ']h', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gs.nav_hunk 'next'
            end
          end, 'Next Hunk')
          map('n', '[h', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gs.nav_hunk 'prev'
            end
          end, 'Prev Hunk')
          map('n', ']H', function()
            gs.nav_hunk 'last'
          end, 'Last Hunk')
          map('n', '[H', function()
            gs.nav_hunk 'first'
          end, 'First Hunk')
          map({ 'n', 'x' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
          map({ 'n', 'x' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
          map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
          map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
          map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
          map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
          map('n', '<leader>ghb', function()
            gs.blame_line { full = true }
          end, 'Blame Line')
          map('n', '<leader>ghB', function()
            gs.blame()
          end, 'Blame Buffer')
          map('n', '<leader>ghd', gs.diffthis, 'Diff This')
          map('n', '<leader>ghD', function()
            gs.diffthis '~'
          end, 'Diff This ~')
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
        end,
      }

      Snacks.toggle({
        name = 'Git Signs',
        get = function()
          return require('gitsigns.config').config.signcolumn
        end,
        set = function(state)
          require('gitsigns').toggle_signs(state)
        end,
      }):map '<leader>uG'
    end,
  },

  {
    'trouble.nvim',
    cmd = { 'Trouble' },
    after = function()
      require('trouble').setup {
        modes = {
          lsp = {
            win = { position = 'right' },
          },
        },
      }
    end,
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cS', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP references/definitions/... (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').prev { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next Trouble/Quickfix Item',
      },
    },
  },

  {
    'todo-comments.nvim',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    after = function()
      require('todo-comments').setup()
    end,
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next Todo Comment',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous Todo Comment',
      },
      { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
      { '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        '<leader>sT',
        function()
          Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = 'Todo/Fix/Fixme',
      },
    },
  },

  {
    'harpoon2',
    after = function()
      require('harpoon').setup {
        menu = {
          width = vim.api.nvim_win_get_width(0) - 4,
        },
        settings = {
          save_on_toggle = true,
        },
      }
    end,
    keys = {
      {
        '<leader>H',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Harpoon File',
      },
      {
        '<leader>h',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon Quick Menu',
      },
      {
        '<leader>1',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Harpoon to File 1',
      },
      {
        '<leader>2',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Harpoon to File 2',
      },
      {
        '<leader>3',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Harpoon to File 3',
      },
      {
        '<leader>4',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'Harpoon to File 4',
      },
      {
        '<leader>5',
        function()
          require('harpoon'):list():select(5)
        end,
        desc = 'Harpoon to File 5',
      },
    },
  },

  {
    'dial.nvim',
    keys = {
      {
        '<C-a>',
        function()
          return M.dial(true)
        end,
        expr = true,
        desc = 'Increment',
        mode = { 'n', 'v' },
      },
      {
        '<C-x>',
        function()
          return M.dial(false)
        end,
        expr = true,
        desc = 'Decrement',
        mode = { 'n', 'v' },
      },
      {
        'g<C-a>',
        function()
          return M.dial(true, true)
        end,
        expr = true,
        desc = 'Increment',
        mode = { 'n', 'x' },
      },
      {
        'g<C-x>',
        function()
          return M.dial(false, true)
        end,
        expr = true,
        desc = 'Decrement',
        mode = { 'n', 'x' },
      },
    },
    after = function()
      local augend = require 'dial.augend'

      local logical_alias = augend.constant.new {
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
      }

      local ordinal_numbers = augend.constant.new {
        -- elements through which we cycle. When we increment, we go down
        -- On decrement we go up
        elements = {
          'first',
          'second',
          'third',
          'fourth',
          'fifth',
          'sixth',
          'seventh',
          'eighth',
          'ninth',
          'tenth',
        },
        -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
        word = false,
        -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
        -- Otherwise nothing will happen when there are no further values
        cyclic = true,
      }

      local weekdays = augend.constant.new {
        elements = {
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        },
        word = true,
        cyclic = true,
      }

      local months = augend.constant.new {
        elements = {
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        },
        word = true,
        cyclic = true,
      }

      local capitalized_boolean = augend.constant.new {
        elements = {
          'True',
          'False',
        },
        word = true,
        cyclic = true,
      }

      local opts = {
        dials_by_ft = {
          css = 'css',
          vue = 'vue',
          javascript = 'typescript',
          typescript = 'typescript',
          typescriptreact = 'typescript',
          javascriptreact = 'typescript',
          json = 'json',
          lua = 'lua',
          markdown = 'markdown',
          sass = 'css',
          scss = 'css',
          python = 'python',
        },
        groups = {
          default = {
            augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
            augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
            augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
            augend.date.alias['%Y/%m/%d'], -- date (2022/02/19, etc.)
            ordinal_numbers,
            weekdays,
            months,
            capitalized_boolean,
            augend.constant.alias.bool, -- boolean value (true <-> false)
            logical_alias,
          },
          vue = {
            augend.constant.new { elements = { 'let', 'const' } },
            augend.hexcolor.new { case = 'lower' },
            augend.hexcolor.new { case = 'upper' },
          },
          typescript = {
            augend.constant.new { elements = { 'let', 'const' } },
          },
          css = {
            augend.hexcolor.new {
              case = 'lower',
            },
            augend.hexcolor.new {
              case = 'upper',
            },
          },
          markdown = {
            augend.constant.new {
              elements = { '[ ]', '[x]' },
              word = false,
              cyclic = true,
            },
            augend.misc.alias.markdown_header,
          },
          json = {
            augend.semver.alias.semver, -- versioning (v1.1.2)
          },
          lua = {
            augend.constant.new {
              elements = { 'and', 'or' },
              word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
              cyclic = true, -- "or" is incremented into "and".
            },
          },
          python = {
            augend.constant.new {
              elements = { 'and', 'or' },
            },
          },
        },
      }

      -- copy defaults to each group
      for name, group in pairs(opts.groups) do
        if name ~= 'default' then
          vim.list_extend(group, opts.groups.default)
        end
      end
      require('dial.config').augends:register_group(opts.groups)
      vim.g.dials_by_ft = opts.dials_by_ft
    end,
  },
}
