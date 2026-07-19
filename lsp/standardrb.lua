local exe = 'standardrb'

---@type vim.lsp.Config
return {
  cmd = { exe, '--lsp' },
  filetypes = { 'ruby' },
  root_dir = function(bufnr, ondir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, {
      '.standard.yml',
      '.standard.yaml'
    })

    if root and vim.fn.executable(exe) == 1 then
      ondir(root)
    end
  end,
}
