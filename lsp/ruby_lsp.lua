local exe = 'ruby-lsp'

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { exe },
      dispatchers,
      config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir }
    )
  end,
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  root_dir = function(bufnr, ondir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, {
      'Gemfile',
      '.git'
    })

    if root and vim.fn.executable(exe) == 1 then
      ondir(root)
    end
  end,
  init_options = {
    enabledFeatures = {
      formatting = false
    },
    formatter = 'none'
  },
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd
  end,
}
