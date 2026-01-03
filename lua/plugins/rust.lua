return {
  {
    'rustaceanvim',
    ft = 'rust',
    before = function()
      LZN.trigger_load 'codesettings.nvim'
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', '<leader>ca', function()
              vim.cmd.RustLsp 'codeAction'
            end, { desc = 'Code Action', silent = true, buffer = bufnr })
            vim.keymap.set('n', '<leader>dr', function()
              vim.cmd.RustLsp 'debuggables'
            end, { desc = 'Rust Debuggables', silent = true, buffer = bufnr })
            vim.keymap.set('n', 'K', function()
              vim.cmd.RustLsp { 'hover', 'actions' }
            end, { desc = 'Hover Information', silent = true, buffer = bufnr })
          end,
          load_vscode_settings = false,
          -- the global hook doesn't work when configuring rust-analyzer with rustaceanvim
          settings = function(_, settings)
            -- Note the exact way this is invoked to work with rustaceanvim:
            -- - passed in settings are wrapped like `{ settings = settings }`
            -- - the returned value is the `.settings` subtable
            return require('codesettings').with_local_settings('rust-analyzer', { settings = settings }).settings
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              -- Add clippy lints for Rust if using rust-analyzer
              checkOnSave = true,
              -- Enable diagnostics if using rust-analyzer
              diagnostics = {
                enable = true,
              },
              procMacro = {
                enable = true,
              },
              files = {
                exclude = {
                  '.direnv',
                  '.git',
                  '.jj',
                  '.github',
                  '.gitlab',
                  'bin',
                  'node_modules',
                  'target',
                  'venv',
                  '.venv',
                },
                -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
                watcher = 'client',
              },
            },
          },
        },
      }
    end,
  },

  {
    'crates.nvim',
    event = { 'BufRead Cargo.toml' },
    after = function()
      require('crates').setup {
        completion = {
          crates = {
            enabled = true,
          },
        },
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
}
