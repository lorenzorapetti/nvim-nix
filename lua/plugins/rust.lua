return {
  {
    'rustaceanvim',
    ft = 'rust',
    before = function()
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
              checkOnSave = diagnostics == 'rust-analyzer',
              -- Enable diagnostics if using rust-analyzer
              diagnostics = {
                enable = diagnostics == 'rust-analyzer',
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
    after = function()
      require('rustaceanvim').setup()
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
