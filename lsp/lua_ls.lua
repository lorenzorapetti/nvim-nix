local exe = 'lua-language-server'

---@type vim.lsp.Config
return {
  cmd = { exe },
  filetypes = { 'lua' },
  root_dir = function(bufnr, ondir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, {
      '.emmyrc.json',
      '.luarc.json',
      '.luarc.jsonc',
      '.luacheckrc',
      '.stylua.toml',
      'stylua.toml',
      'selene.toml',
      'selene.yml',
    })

    if root and vim.fn.executable(exe) == 1 then
      ondir(root)
    end
  end,
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = 'Disable' },
      runtime = {
        version = 'Lua 5.4',
      },
      diagnostics = {
        enable = true,
        globals = { 'vim' },
      },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
    },
  },
}
