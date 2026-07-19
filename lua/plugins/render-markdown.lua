require('render-markdown').setup {
  patterns = { markdown = { disable = false } },
  completions = {
    lsp = { enabled = true },
  },
  file_types = { 'markdown' },
}
