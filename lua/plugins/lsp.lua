return {
  {
    'nvim-lspconfig',
    event = 'DeferredUIEnter',
    before = function()
      LZN.trigger_load 'fidget.nvim'
    end,
    after = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(mode, lhs, rhs, opts)
            opts = opts or {}
            Snacks.keymap.set(mode, lhs, rhs, opts)
          end

          -- Code
          map('n', '<leader>cl', function()
            Snacks.picker.lsp_config()
          end, { desc = 'Lsp Info' })
          map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action', lsp = { method = 'codeAction' } })
          map({ 'n', 'x' }, '<leader>cc', vim.lsp.codelens.run, { desc = 'Run Codelens', lsp = { method = 'codeLens' } })
          map('n', '<leader>cC', vim.lsp.codelens.refresh, { desc = 'Refresh Codelens', lsp = { method = 'codeLens' } })
          map('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', lsp = { method = 'rename' } })
          map('n', '<leader>cR', function()
            Snacks.rename.rename_file()
          end, { desc = 'Rename File', lsp = { method = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' } } })

          -- Goto
          map('n', 'gd', function()
            Snacks.picker.lsp_definitions()
          end, { desc = 'Goto Definition', lsp = { method = { 'definition' } } })
          map('n', 'gr', function()
            Snacks.picker.lsp_references()
          end, { nowait = true, desc = 'References' })
          map('n', 'gI', function()
            Snacks.picker.lsp_implementations()
          end, { desc = 'Goto Implementation' })
          map('n', 'gy', function()
            Snacks.picker.lsp_type_definitions()
          end, { desc = 'Goto T[y]pe Definition' })

          -- Search
          map('n', '<leader>ss', function()
            Snacks.picker.lsp_symbols()
          end, { desc = 'LSP Symbols', lsp = { method = 'documentSymbol' } })
          map('n', '<leader>sS', function()
            Snacks.picker.lsp_workspace_symbols()
          end, { desc = 'LSP Workspace Symbols', lsp = { method = 'workspace/symbols' } })
          map('n', 'gai', function()
            Snacks.picker.lsp_incoming_calls()
          end, { desc = 'C[a]lls Incoming', lsp = { method = 'callHierarchy/incomingCalls' } })
          map('n', 'gao', function()
            Snacks.picker.lsp_outgoing_calls()
          end, { desc = 'C[a]lls Outgoing', lsp = { method = 'callHierarchy/outgoingCalls' } })

          -- Hover
          map('n', 'K', function()
            return vim.lsp.buf.hover()
          end, { desc = 'Hover' })
          map('n', 'gK', function()
            return vim.lsp.buf.signature_help()
          end, { desc = 'Signature Help', lsp = { method = 'signatureHelp' } })
          map('i', '<c-k>', function()
            return vim.lsp.buf.signature_help()
          end, { desc = 'Signature Help', lsp = { method = 'signatureHelp' } })

          -- Jumps
          map('n', ']]', function()
            Snacks.words.jump(vim.v.count1)
          end, {
            lsp = { method = 'documentHighlight' },
            desc = 'Next Reference',
            enabled = function()
              return Snacks.words.is_enabled()
            end,
          })
          map('n', '[[', function()
            Snacks.words.jump(-vim.v.count1)
          end, {
            lsp = { method = 'documentHighlight' },
            desc = 'Prev Reference',
            enabled = function()
              return Snacks.words.is_enabled()
            end,
          })
          map('n', '<a-n>', function()
            Snacks.words.jump(vim.v.count1, true)
          end, {
            lsp = { method = 'documentHighlight' },
            desc = 'Next Reference',
            enabled = function()
              return Snacks.words.is_enabled()
            end,
          })
          map('n', '<a-p>', function()
            Snacks.words.jump(-vim.v.count1, true)
          end, {
            lsp = { method = 'documentHighlight' },
            desc = 'Prev Reference',
            enabled = function()
              return Snacks.words.is_enabled()
            end,
          })

          -- Diagnostic Config
          -- See :help vim.diagnostic.Opts
          vim.diagnostic.config {
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
              text = {
                [vim.diagnostic.severity.ERROR] = '󰅚 ',
                [vim.diagnostic.severity.WARN] = '󰀪 ',
                [vim.diagnostic.severity.INFO] = '󰋽 ',
                [vim.diagnostic.severity.HINT] = '󰌶 ',
              },
            } or {},
            virtual_text = {
              source = 'if_many',
              spacing = 2,
              format = function(diagnostic)
                local diagnostic_message = {
                  [vim.diagnostic.severity.ERROR] = diagnostic.message,
                  [vim.diagnostic.severity.WARN] = diagnostic.message,
                  [vim.diagnostic.severity.INFO] = diagnostic.message,
                  [vim.diagnostic.severity.HINT] = diagnostic.message,
                }
                return diagnostic_message[diagnostic.severity]
              end,
            },
          }
        end,
      })

      -- ############################## LSP CONFIGS ##############################

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using (most
              -- likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Tell the language server how to find Lua modules same way as Neovim
              -- (see `:h lua-module-load`)
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths
                -- here.
                -- '${3rd}/luv/library'
                -- '${3rd}/busted/library'
              },
              -- Or pull in all of 'runtimepath'.
              -- NOTE: this is a lot slower and will cause issues when working on
              -- your own configuration.
              -- See https://github.com/neovim/nvim-lspconfig/issues/3189
              -- library = {
              --   vim.api.nvim_get_runtime_file('', true),
              -- }
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      vim.lsp.enable {
        'lua_ls',
        'nixd',
        'dockerls',
        'docker_compose_language_service',
        'vtsls',
        'tailwindcss',
      }
    end,
  },

  {
    'fidget.nvim',
    lazy = true,
    after = function()
      require('fidget').setup()
    end,
  },
}
