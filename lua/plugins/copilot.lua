return {
  {
    'copilot.lua',
    event = 'BufReadPost',
    cmd = { 'Copilot' },
    after = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = '<S-CR>',
          },
        },
        panel = { enabled = false },
        filetypes = {
          sh = function()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
              -- disable for .env files
              return false
            end
            return true
          end,
          markdown = true,
          help = true,
        },
        copilot_model = 'gemini-3-pro-preview',
      }
    end,
  },
}
