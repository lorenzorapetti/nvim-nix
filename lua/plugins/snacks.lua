Snacks = require 'snacks'

local function term_nav(dir)
  return function(self)
    return self:is_floating() and '<c-' .. dir .. '>' or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

Snacks.setup {
  indent = { enabled = false },
  explorer = {
    enabled = true,
    replace_netrw = true,
  },
  notifier = {},
  picker = {
    sources = {
      explorer = {
        hidden = true,
      },
      files = {
        hidden = true,
      },
    },
    win = {
      input = {
        keys = {
          ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
          ['<C-c>'] = 'cancel',
        },
      },
    },
  },
  zen = {
    toggles = {
      dim = false,
    },
  },
  dashboard = {
    preset = {
      header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      keys = {
        { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
        { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = ' ',
          key = 's',
          desc = 'Restore Session',
          action = function()
            require('persistence').load()
          end,
        },
        { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
    },
  },
  statuscolumn = {},
  terminal = {
    win = {
      keys = {
        nav_h = { '<C-h>', term_nav 'h', desc = 'Go to Left Window', expr = true, mode = 't' },
        nav_j = { '<C-j>', term_nav 'j', desc = 'Go to Lower Window', expr = true, mode = 't' },
        nav_k = { '<C-k>', term_nav 'k', desc = 'Go to Upper Window', expr = true, mode = 't' },
        nav_l = { '<C-l>', term_nav 'l', desc = 'Go to Right Window', expr = true, mode = 't' },
      },
    },
  },
  words = { enabled = true },
  styles = {
    zen = {
      backdrop = {
        transparent = false,
      },
    },
  },
}

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- buffers
map('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
map('n', '<leader>bo', function()
  Snacks.bufdelete.other()
end, { desc = 'Delete Other Buffers' })

-- Scratch buffer
map('n', '<leader>.', function()
  Snacks.scratch()
end, { desc = 'Toggle Scratch Buffer' })
map('n', '<leader>S', function()
  Snacks.scratch.select()
end, { desc = 'Select Scratch Buffer' })

Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
Snacks.toggle.diagnostics():map '<leader>ud'
Snacks.toggle.line_number():map '<leader>ul'
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' }):map '<leader>uc'
Snacks.toggle.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' }):map '<leader>uA'
Snacks.toggle.treesitter():map '<leader>uT'
Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
Snacks.toggle.dim():map '<leader>uD'
Snacks.toggle.animate():map '<leader>ua'
Snacks.toggle.indent():map '<leader>ug'
Snacks.toggle.scroll():map '<leader>uS'
Snacks.toggle.profiler():map '<leader>dpp'
Snacks.toggle.profiler_highlights():map '<leader>dph'
Snacks.toggle.zoom():map('<leader>wm'):map '<leader>uZ'
Snacks.toggle.zen():map '<leader>uz'
Snacks.toggle({
  name = 'Copilot Suggestions (Buffer)',
  get = function()
    return not vim.b.copilot_suggestion_hidden
  end,
  set = function(value)
    vim.b.copilot_suggestion_hidden = not value
  end,
}):map '<leader>uA'

Snacks.toggle({
  name = 'Copilot Suggestions',
  get = function()
    return not require('copilot.client').is_disabled()
  end,
  set = function(value)
    local c = require 'copilot.command'
    if value then
      c.enable()
    else
      c.disable()
    end
  end,
}):map '<leader>ua'

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map '<leader>uh'
end

if vim.fn.executable 'lazygit' == 1 then
  map('n', '<leader>gg', function()
    Snacks.lazygit { cwd = Util.root.git() }
  end, { desc = 'Lazygit (Root Dir)' })
  map('n', '<leader>gG', function()
    Snacks.lazygit()
  end, { desc = 'Lazygit (cwd)' })
end

if vim.fn.executable 'tuxedo' == 1 then
  map('n', '<leader>gt', function()
    Snacks.terminal('tuxedo', { cwd = Util.root.git() })
  end)
end

map('n', '<leader>gL', function()
  Snacks.picker.git_log()
end, { desc = 'Git Log (cwd)' })
map('n', '<leader>gb', function()
  Snacks.picker.git_log_line()
end, { desc = 'Git Blame Line' })
map('n', '<leader>gf', function()
  Snacks.picker.git_log_file()
end, { desc = 'Git Current File History' })
map('n', '<leader>gl', function()
  Snacks.picker.git_log { cwd = Util.root.git() }
end, { desc = 'Git Log' })
map({ 'n', 'x' }, '<leader>gB', function()
  Snacks.gitbrowse()
end, { desc = 'Git Browse (open)' })
map({ 'n', 'x' }, '<leader>gY', function()
  Snacks.gitbrowse {
    open = function(url)
      vim.fn.setreg('+', url)
    end,
    notify = false,
  }
end, { desc = 'Git Browse (copy)' })

-- Terminal
map('n', '<leader>fT', function()
  Snacks.terminal()
end, { desc = 'Terminal (cwd)' })
map('n', '<leader>ft', function()
  Snacks.terminal(nil, { cwd = Util.root() })
end, { desc = 'Terminal (Root Dir)' })
map({ 'n', 't' }, '<c-/>', function()
  Snacks.terminal(nil, { cwd = Util.root() })
end, { desc = 'Terminal (Root Dir)' })

-- Pickers and explorers
map('n', '<leader>e', function()
  Snacks.explorer { cwd = Util.root() }
end, { desc = 'Open Explorer (root dir)' })
map('n', '<leader>E', function()
  Snacks.explorer()
end, { desc = 'Open Explorer (cwd)' })
map('n', '<leader><space>', function()
  Snacks.picker.smart()
end, { desc = 'Find Files (root dir)' })
map('n', '<leader>,', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
map('n', '<leader>:', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
map('n', '<leader>/', function()
  Snacks.picker.grep()
end, { desc = 'Grep (root dir)' })
map('n', '<leader>n', function()
  Snacks.picker.notifications()
end, { desc = 'Notification History' })

-- Find
map('n', '<leader>fb', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
map('n', '<leader>fB', function()
  Snacks.picker.buffers { hidden = true, nofile = true }
end, { desc = 'Buffers (all)' })
map('n', '<leader>ff', function()
  Snacks.picker.files { cwd = Util.root() }
end, { desc = 'Find Files (Root Dir)' })
map('n', '<leader>fF', function()
  Snacks.picker.files()
end, { desc = 'Find Files (cwd)' })
map('n', '<leader>fg', function()
  Snacks.picker.git_files()
end, { desc = 'Find Files (git-files)' })
map('n', '<leader>fr', function()
  Snacks.picker.recent()
end, { desc = 'Recent' })
map('n', '<leader>fR', function()
  Snacks.picker.recent { filter = { cwd = true } }
end, { desc = 'Recent (cwd)' })
map('n', '<leader>fp', function()
  Snacks.picker.projects()
end, { desc = 'Projects' })

-- git
map('n', '<leader>gb', function()
  Snacks.picker.git_branches()
end, { desc = 'Git Branches' })
map('n', '<leader>gl', function()
  Snacks.picker.git_log()
end, { desc = 'Git Log' })
map('n', '<leader>gL', function()
  Snacks.picker.git_log_line()
end, { desc = 'Git Log Line' })
map('n', '<leader>gs', function()
  Snacks.picker.git_status()
end, { desc = 'Git Status' })
map('n', '<leader>gS', function()
  Snacks.picker.git_stash()
end, { desc = 'Git Stash' })
map('n', '<leader>gd', function()
  Snacks.picker.git_diff()
end, { desc = 'Git Diff (Hunks)' })
map('n', '<leader>gD', function()
  Snacks.picker.git_diff { base = 'origin', group = true }
end, { desc = 'Git Diff (Origin)' })
map('n', '<leader>gf', function()
  Snacks.picker.git_log_file()
end, { desc = 'Git Log File' })

-- gh
map('n', '<leader>gi', function()
  Snacks.picker.gh_issue()
end, { desc = 'GitHub Issues (open)' })
map('n', '<leader>gI', function()
  Snacks.picker.gh_issue { state = 'all' }
end, { desc = 'GitHub Issues (all)' })
map('n', '<leader>gp', function()
  Snacks.picker.gh_pr()
end, { desc = 'GitHub Pull Requests (open)' })
map('n', '<leader>gP', function()
  Snacks.picker.gh_pr { state = 'all' }
end, { desc = 'GitHub Pull Requests (all)' })

-- grep
map('n', '<leader>sb', function()
  Snacks.picker.lines()
end, { desc = 'Buffer Lines' })
map('n', '<leader>sB', function()
  Snacks.picker.grep_buffers()
end, { desc = 'Grep Open Buffers' })
map('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
map({ 'n', 'x' }, '<leader>sw', function()
  Snacks.picker.grep_word()
end, { desc = 'Visual selection or word' })

-- search
map('n', '<leader>s"', function()
  Snacks.picker.registers()
end, { desc = 'Registers' })
map('n', '<leader>s/', function()
  Snacks.picker.search_history()
end, { desc = 'Search History' })
map('n', '<leader>sa', function()
  Snacks.picker.autocmds()
end, { desc = 'Autocmds' })
map('n', '<leader>sb', function()
  Snacks.picker.lines()
end, { desc = 'Buffer Lines' })
map('n', '<leader>sc', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
map('n', '<leader>sC', function()
  Snacks.picker.commands()
end, { desc = 'Commands' })
map('n', '<leader>sd', function()
  Snacks.picker.diagnostics()
end, { desc = 'Diagnostics' })
map('n', '<leader>sD', function()
  Snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer Diagnostics' })
map('n', '<leader>sh', function()
  Snacks.picker.help()
end, { desc = 'Help Pages' })
map('n', '<leader>sH', function()
  Snacks.picker.highlights()
end, { desc = 'Highlights' })
map('n', '<leader>si', function()
  Snacks.picker.icons()
end, { desc = 'Icons' })
map('n', '<leader>sj', function()
  Snacks.picker.jumps()
end, { desc = 'Jumps' })
map('n', '<leader>sk', function()
  Snacks.picker.keymaps()
end, { desc = 'Keymaps' })
map('n', '<leader>sl', function()
  Snacks.picker.loclist()
end, { desc = 'Location List' })
map('n', '<leader>sm', function()
  Snacks.picker.marks()
end, { desc = 'Marks' })
map('n', '<leader>sM', function()
  Snacks.picker.man()
end, { desc = 'Man Pages' })
map('n', '<leader>sq', function()
  Snacks.picker.qflist()
end, { desc = 'Quickfix List' })
map('n', '<leader>sR', function()
  Snacks.picker.resume()
end, { desc = 'Resume' })
map('n', '<leader>su', function()
  Snacks.picker.undo()
end, { desc = 'Undo History' })
map('n', '<leader>uC', function()
  Snacks.picker.colorschemes()
end, { desc = 'Colorschemes' })
