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

  {
    'codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionToggle', 'CodeCompanionAdd', 'CodeCompanionChat' },
    before = function()
      LZN.trigger_load 'plenary.nvim'
      LZN.trigger_load 'markview.nvim'
      LZN.trigger_load 'copilot.lua'
      LZN.trigger_load 'blink.cmp'
    end,
    after = function()
      require('codecompanion').setup {
        adapters = {
          acp = {
            gemini_cli = function()
              return require('codecompanion.adapters').extend('gemini_cli', {
                defaults = {
                  auth_method = 'oauth-personal',
                },
              })
            end,
          },
          http = {
            copilot = function()
              return require('codecompanion.adapters').extend('copilot', {
                schema = {
                  model = {
                    default = 'claude-sonnet-4.5',
                  },
                },
              })
            end,
          },
        },
        memory = {
          default = {
            files = {
              'AGENTS.md',
              { path = 'AGENTS.md', parser = 'claude' },
            },
          },
          opts = {
            chat = {
              enabled = true,
            },
          },
        },
        strategies = {
          chat = {
            name = 'copilot',
            model = 'gemini-3-pro-preview',
            opts = {
              ---Decorate the user message before it's sent to the LLM
              ---@param message string
              ---@param adapter CodeCompanion.Adapter
              ---@param context table
              ---@return string
              prompt_decorator = function(message, adapter, context)
                return string.format([[<prompt>%s</prompt>]], message)
              end,
            },
            roles = {
              ---The header name for the LLM's messages
              ---@type string|fun(adapter: CodeCompanion.Adapter): string
              llm = function(adapter)
                return 'CodeCompanion (' .. adapter.formatted_name .. ')'
              end,
            },
            slash_commands = {
              ['git_files'] = {
                description = 'List git files',
                ---@param chat CodeCompanion.Chat
                callback = function(chat)
                  local handle = io.popen 'git ls-files'
                  if handle ~= nil then
                    local result = handle:read '*a'
                    handle:close()
                    chat:add_context({ role = 'user', content = result }, 'git', '<git_files>')
                  else
                    return vim.notify('No git files available', vim.log.levels.INFO, { title = 'CodeCompanion' })
                  end
                end,
                opts = {
                  contains_code = false,
                },
              },
            },
            variables = {
              ['previous_commits'] = {
                callback = function()
                  local previous_commits = vim.fn.system 'get_commits_with_diffs'

                  return [[
The following are previous commits in this branch that are not present in `main`.
Each commit includes its commit message and the corresponding code changes (diff).
Commits are separated by a line containing only `---`.

Please use this information as context for understanding the branch history and code evolution.

]] .. previous_commits
                end,
                description = 'Shares previous commits and their code changes unique to this branch',
                opts = {
                  contains_code = true,
                },
              },
              ['staged_diff'] = {
                callback = function()
                  local staged_diff = vim.fn.system 'GIT_PAGER=cat git diff --no-ext-diff --staged --no-color'

                  return string.format(
                    [[
The following is the diff of all code changes currently staged for commit in this branch:

```diff
%s
```
]],
                    staged_diff
                  )
                end,
                description = 'Shares the current staged code changes',
                opts = {
                  contains_code = false,
                },
              },
            },
          },
          inline = {},
        },
        prompt_library = {
          ['Generate a Commit Message'] = {
            strategy = 'chat',
            description = 'Generate a commit message',
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = 'commit',
              auto_submit = false,
            },
            prompts = {
              {
                role = 'user',
                content = function()
                  return string.format [[
#{previous_commits}
#{staged_diff}

Write a single, high-quality commit message for the staged changes.

Output only the commit message, wrapped in a ```gitcommit``` code block.
]]
                end,
                opts = {
                  contains_code = true,
                  auto_submit = false,
                },
              },
            },
          },
        },
      }

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd [[cab cc CodeCompanion]]
    end,
    keys = {
      { '<leader>aa', '<cmd>CodeCompanionChat toggle<cr>', desc = 'Toggle Code Companion Chat' },
      { '<leader>aa', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add Message to Code Companion Chat', mode = { 'v' } },
      { '<leader>ai', '<cmd>CodeCompanion<cr>', desc = 'Code Companion Inline Assistant', mode = { 'n', 'x' } },
      { '<leader>ap', '<cmd>CodeCompanionActions<cr>', desc = 'Code Companion Actions' },
    },
  },
}
