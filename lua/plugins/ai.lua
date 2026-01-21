return {
  {
    'avante.nvim',
    event = 'DeferredUIEnter',
    before = function()
      LZN.trigger_load 'plenary.nvim'
      LZN.trigger_load 'nui.nvim'
      LZN.trigger_load 'blink.cmp'
      LZN.trigger_load 'render-markdown.nvim'
      LZN.trigger_load 'mini.icons'
    end,
    after = function()
      require('avante').setup {
        provider = 'copilot',
        behaviour = {
          auto_suggestions = false,
        },
        selector = {
          provider = 'snacks',
        },
        input = {
          provider = 'snacks',
        },
      }
    end,
  },
}
