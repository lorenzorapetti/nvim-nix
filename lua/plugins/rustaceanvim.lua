vim.g.rustaceanvim = {
  server = {
    on_attach = function(_, bufnr)
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true, buffer = bufnr })
      end

      map('n', '<leader>ca', function()
        vim.cmd.RustLsp 'codeAction'
      end, 'Code Action')
      map('n', '<leader>cm', function()
        vim.cmd.RustLsp 'expandMacro'
      end, 'Expand Macro')
      map('n', '<leader>ck', '<Plug>RustHoverAction', 'Hover Action')
      map('n', '<leader>ce', function()
        vim.cmd.RustLsp 'explainError'
      end, 'Explain Error')
      map('n', '<leader>cD', function()
        vim.cmd.RustLsp 'renderDiagnostic'
      end, 'Rust Diagnostic')

      map('n', '<leader>od', function()
        vim.cmd.RustLsp 'openDocs'
      end, 'Open docs.rs documentation')
      map('n', '<leader>oc', function()
        vim.cmd.RustLsp 'openCargo'
      end, 'Open Cargo.toml')
      map('n', '<leader>ot', function()
        vim.cmd.RustLsp 'relatedTests'
      end, 'Open related tests')

      map('n', 'J', function()
        vim.cmd.RustLsp 'joinLines'
      end, 'Join Lines')
      -- Required nvim-dap
      -- map('n', '<leader>dr', function()
      --   vim.cmd.RustLsp 'debuggables'
      -- end, 'Rust Debuggables')
      map('n', 'K', function()
        vim.cmd.RustLsp { 'hover', 'actions' }
      end, 'Hover Information')
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
