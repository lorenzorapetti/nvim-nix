return {
  name = 'Typecheck',
  builder = function()
    return {
      cmd = { 'npx', 'tsc', '--noEmit' },
      components = {
        { 'on_output_quickfix', items_only = true, open = true, focus = true, close = true },
        'default',
      },
    }
  end,
  condition = {
    filetype = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
  },
}
