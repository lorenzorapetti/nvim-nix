return {
  {
    'mini.files',
    lazy = false,
    before = function()
      LZN.trigger_load 'mini.icons'
    end,
    after = function()
      require('mini.files').setup {
        options = {
          use_as_default_explorer = true,
        },
      }

      local show_dotfiles = true

      local filter_show = function(fs_entry)
        return true
      end

      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require('mini.files').refresh { content = { filter = new_filter } }
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local new_target_window
          local cur_target_window = require('mini.files').get_explorer_state().target_window
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd('belowright ' .. direction .. ' split')
              new_target_window = vim.api.nvim_get_current_win()
            end)

            require('mini.files').set_target_window(new_target_window)
            require('mini.files').go_in { close_on_file = close_on_file }
          end
        end

        local desc = 'Open in ' .. direction .. ' split'
        if close_on_file then
          desc = desc .. ' and close'
        end
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      local yank_path = function()
        local path = (require('mini.files').get_fs_entry() or {}).path
        if path == nil then
          return vim.notify 'Cursor is not on valid entry'
        end
        vim.fn.setreg(vim.v.register, path)
      end

      local ui_open = function()
        vim.ui.open(require('mini.files').get_fs_entry().path)
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
          vim.keymap.set('n', 'gX', ui_open, { buffer = buf_id, desc = 'OS open' })
          vim.keymap.set('n', 'gy', yank_path, { buffer = buf_id, desc = 'Yank path' })

          map_split(buf_id, '<C-s>', 'horizontal', false)
          map_split(buf_id, '<C-v>', 'vertical', false)
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })

      -- Window width based on the offset from the center, i.e. center window
      -- is 60, then next over is 20, then the rest are 10.
      -- Can use more resolution if you want like { 60, 20, 20, 10, 5 }
      local widths = { 60, 20, 10 }

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowUpdate',
        callback = function(ev)
          local state = MiniFiles.get_explorer_state()
          if state == nil then
            return
          end

          -- Compute "depth offset" - how many windows are between this and focused
          local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match '^minifiles://%d+/(.*)$'
          local depth_this
          for i, path in ipairs(state.branch) do
            if path == path_this then
              depth_this = i
            end
          end
          if depth_this == nil then
            return
          end
          local depth_offset = depth_this - state.depth_focus

          -- Adjust config of this event's window
          local i = math.abs(depth_offset) + 1
          local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
          win_config.width = i <= #widths and widths[i] or widths[#widths]

          win_config.zindex = 99
          win_config.col = math.floor(0.5 * (vim.o.columns - widths[1]))
          local sign = depth_offset == 0 and 0 or (depth_offset > 0 and 1 or -1)
          for j = 1, math.abs(depth_offset) do
            -- widths[j+1] for the negative case because we don't want to add the center window's width
            local prev_win_width = (sign == -1 and widths[j + 1]) or widths[j] or widths[#widths]
            -- Add an extra +2 each step to account for the border width
            local new_col = win_config.col + sign * (prev_win_width + 2)
            if (new_col < 0) or (new_col + win_config.width > vim.o.columns) then
              win_config.zindex = win_config.zindex - 1
              break
            end
            win_config.col = new_col
          end

          win_config.height = depth_offset == 0 and 24 or 20
          win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
          -- win_config.border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
          win_config.footer = { { tostring(depth_offset), 'Normal' } }
          vim.api.nvim_win_set_config(ev.data.win_id, win_config)
        end,
      })
    end,
    keys = {
      {
        '-',
        function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = 'Open mini.files (Directory of Current File)',
      },
      {
        '<leader>fm',
        function()
          require('mini.files').open(Util.root(), true)
        end,
        desc = 'Open mini.files (Root)',
      },
      {
        '<leader>fM',
        function()
          require('mini.files').open(vim.uv.cwd(), true)
        end,
        desc = 'Open mini.files (cwd)',
      },
    },
  },
}
