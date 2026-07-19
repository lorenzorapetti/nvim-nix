local ai = require 'mini.ai'

ai.setup {
  -- Number of lines within which textobject is searched
  n_lines = 500,

  custom_textobjects = {
    a = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },

    o = ai.gen_spec.treesitter { -- code block
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    },

    c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },

    f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },

    t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags

    d = { '%f[%d]%d+' }, -- digits

    -- snake_case, camelCase, PascalCase, etc; all capitalizations
    e = {
      -- Lua 5.1 character classes and the undocumented frontier pattern:
      -- https://www.lua.org/manual/5.1/manual.html#5.4.1
      -- http://lua-users.org/wiki/FrontierPattern
      -- note: when I say "letter" I technically mean "letter or digit"
      {
        -- Matches a single uppercase letter followed by 1+ lowercase letters.
        -- This covers:
        -- - PascalCaseWords (or the latter part of camelCaseWords)
        '%u[%l%d]+%f[^%l%d]', -- An uppercase letter, 1+ lowercase letters, to end of lowercase letters

        -- Matches lowercase letters up until not lowercase letter.
        -- This covers:
        -- - start of camelCaseWords (just the `camel`)
        -- - snake_case_words in lowercase
        -- - regular lowercase words
        '%f[^%s%p][%l%d]+%f[^%l%d]', -- after whitespace/punctuation, 1+ lowercase letters, to end of lowercase letters
        '^[%l%d]+%f[^%l%d]', -- after beginning of line, 1+ lowercase letters, to end of lowercase letters

        -- Matches uppercase or lowercase letters up until not letters.
        -- This covers:
        -- - SNAKE_CASE_WORDS in uppercase
        -- - Snake_Case_Words in titlecase
        -- - regular UPPERCASE words
        -- (it must be both uppercase and lowercase otherwise it will
        -- match just the first letter of PascalCaseWords)
        '%f[^%s%p][%a%d]+%f[^%a%d]', -- after whitespace/punctuation, 1+ letters, to end of letters
        '^[%a%d]+%f[^%a%d]', -- after beginning of line, 1+ letters, to end of letters
      },
      '^().*()$',
    },

    u = ai.gen_spec.function_call(), -- u for "Usage"

    -- Whole buffer
    g = function()
      local from = { line = 1, col = 1 }
      local to = {
        line = vim.fn.line '$',
        col = math.max(vim.fn.getline('$'):len(), 1),
      }
      return { from = from, to = to }
    end,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Main textobject prefixes
    around = 'a',
    inside = 'i',

    -- Next/last variants
    -- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
    -- Map LSP selection manually to use it (see `:h MiniAi.config`)
    around_next = 'an',
    inside_next = 'in',
    around_last = 'al',
    inside_last = 'il',

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = 'g[',
    goto_right = 'g]',
  },

  search_method = 'cover_or_next',

  silent = true,
}
