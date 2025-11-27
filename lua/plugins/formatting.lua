return {
  {
    'conform.nvim',
    event = 'DeferredUIEnter',
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cF',
        function()
          require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
        end,
        mode = { 'n', 'x' },
        desc = 'Format Injected Langs',
      },
    },
    after = function()
      require('conform').setup {
        default_format_opts = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = 'fallback',
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          fish = { 'fish_indent' },
          sh = { 'shfmt' },
          nix = { 'alejandra' },
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
    end,
  },
}
