local function find_root(files, ctx)
  return vim.fs.find(files, { path = ctx.dirname, upward = true, type = 'file' })[1] ~= nil
end

local function check_root(files)
  return function(self, ctx)
    return find_root(files, ctx)
  end
end

local js_formatters = {
  'biome',
  'prettierd',
  'prettier',
  stop_after_first = true,
}

local prettier_file_names = {
  -- https://prettier.io/docs/en/configuration.html
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.yml',
  '.prettierrc.yaml',
  '.prettierrc.json5',
  '.prettierrc.js',
  '.prettierrc.cjs',
  '.prettierrc.mjs',
  '.prettierrc.toml',
  'prettier.config.js',
  'prettier.config.cjs',
  'prettier.config.mjs',
}

require('conform').setup {
  default_format_opts = {
    timeout_ms = 2000,
    async = false,
    quiet = false,
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    fish = { 'fish_indent' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    nix = { 'alejandra' },
    javascript = js_formatters,
    javascriptreact = js_formatters,
    typescript = js_formatters,
    typescriptreact = js_formatters,
    json = { 'prettierd', 'prettier', stop_after_first = true },
    ruby = { 'standardrb', 'rubocop', stop_after_first = true },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
    biome = {
      condition = check_root { 'biome.json', 'biome.jsonc' },
      args = {
        'check',
        '--write',
        '--formatter-enabled=true',
        '--linter-enabled=false',
        '--assist-enabled=true',
        '--stdin-file-path',
        '$FILENAME',
      },
    },
    prettierd = {
      condition = check_root(prettier_file_names),
    },
    standardrb = {
      condition = check_root { '.standard.yml' },
    },
    rubocop = {
      condition = check_root { '.rubocop.yml' },
    },
  },
}

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local function autoformat_enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- If the buffer has a local value, use that
  if baf ~= nil then
    return baf
  end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

local function info(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autoformat == nil or vim.g.autoformat
  local baf = vim.b[buf].autoformat
  local enabled = autoformat_enabled(buf)
  local lines = {
    '# Status',
    ('- [%s] global **%s**'):format(gaf and 'x' or ' ', gaf and 'enabled' or 'disabled'),
    ('- [%s] buffer **%s**'):format(enabled and 'x' or ' ', baf == nil and 'inherit' or baf and 'enabled' or 'disabled'),
  }

  print(lines)
end

local function autoformat_enable(enable, buf)
  if enable == nil then
    enable = true
  end
  if buf then
    vim.b.autoformat = enable
  else
    vim.g.autoformat = enable
    vim.b.autoformat = nil
  end
  info()
end

local function snacks_toggle(buf)
  return Snacks.toggle {
    name = 'Auto Format (' .. (buf and 'Buffer' or 'Global') .. ')',
    get = function()
      if not buf then
        return vim.g.autoformat == nil or vim.g.autoformat
      end
      return autoformat_enabled()
    end,
    set = function(state)
      autoformat_enable(state, buf)
    end,
  }
end

snacks_toggle():map '<leader>uf'
snacks_toggle(true):map '<leader>uF'

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    local bufnr = args.buf
    local autoformat = autoformat_enabled(bufnr)

    if autoformat then
      require('conform').format { bufnr = bufnr }
    end
  end,
})
