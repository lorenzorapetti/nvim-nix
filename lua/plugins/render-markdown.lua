return {
  {
    'render-markdown.nvim',
    ft = { 'Avante', 'markdown' },
    before = function()
      LZN.trigger_load 'nvim-treesitter'
      LZN.trigger_load 'mini.icons'
    end,
    after = function()
      require('render-markdown').setup {
        patterns = { markdown = { disable = false } },
        completions = {
          lsp = { enabled = true },
        },
        file_types = { 'markdown', 'Avante' },
      }
    end,
  },
}
