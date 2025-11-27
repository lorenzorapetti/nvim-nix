local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = true
  Snacks.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window' })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Move Lines
map('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
map('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
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

map({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd 'noh'
  if vim.snippet then
    vim.snippet.stop()
  end
  return '<esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / Clear hlsearch / Diff Update' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

--keywordprg
map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

-- better indenting
map('x', '<', '<gv')
map('x', '>', '>gv')

-- commenting
map('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
map('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

-- new file
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- location list
map('n', '<leader>xl', function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Location List' })

-- quickfix list
map('n', '<leader>xq', function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Quickfix List' })

map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump {
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    }
  end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

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

map('n', '<leader>q', '<cmd>qa<cr>', { desc = 'Quit All' })

-- Yank
map({ 'n', 'x' }, '<leader>p', '"0p', { desc = 'Paste from the last yank' })
map({ 'n', 'x' }, '<leader>y', function()
  local regs = {}
  for regnum = 1, 10 do
    table.insert(regs, regnum, vim.fn.getreg(tostring(regnum - 1)))
  end

  vim.ui.select(regs, {
    prompt = 'Select from the yank ring:',
  }, function(choice)
    if choice == nil then
      return
    end

    vim.api.nvim_paste(choice, false, -1)
  end)
end, { desc = 'Select Yank Ring' })

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

-- Window Management
map('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
map('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })

map({ 'n', 'x' }, '<localleader>r', function()
  Snacks.debug.run()
end, { desc = 'Run Lua', ft = 'lua' })
