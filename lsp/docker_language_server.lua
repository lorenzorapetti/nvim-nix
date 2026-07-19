local exe = "docker-language-server"

---@type vim.lsp.Config
return {
  cmd = { exe, 'start', '--stdio' },
  filetypes = { 'dockerfile', 'yaml.docker-compose' },
  get_language_id = function(_, ftype)
    if ftype == 'yaml.docker-compose' or ftype:lower():find('ya?ml') then
      return 'dockercompose'
    else
      return ftype
    end
  end,
  root_dir = function(bufnr, ondir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, {
      'Dockerfile',
      'docker-compose.yaml',
      'docker-compose.yml',
      'compose.yaml',
      'compose.yml',
      'docker-bake.json',
      'docker-bake.hcl',
      'docker-bake.override.json',
      'docker-bake.override.hcl',
    })

    if root and vim.fn.executable(exe) == 1 then
      ondir(root)
    end
  end,
  root_markers = {
  },
}
