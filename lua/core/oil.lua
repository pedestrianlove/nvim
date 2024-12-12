return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  dependencies = {
    { 'echasnovski/mini.icons', opts = {} },
    -- { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    -- helper function to parse output
    local function parse_output(proc)
      local result = proc:wait()
      local ret = {}
      if result.code == 0 then
        for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
          -- Remove trailing slash
          line = line:gsub('/$', '')
          ret[line] = true
        end
      end
      return ret
    end

    -- build git status cache
    local function new_git_status()
      return setmetatable({}, {
        __index = function(self, key)
          local ignore_proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, {
            cwd = key,
            text = true,
          })
          local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, {
            cwd = key,
            text = true,
          })
          local ret = {
            ignored = parse_output(ignore_proc),
            tracked = parse_output(tracked_proc),
          }

          rawset(self, key, ret)
          return ret
        end,
      })
    end
    local git_status = new_git_status()

    -- Clear git status cache on refresh
    local refresh = require('oil.actions').refresh
    local orig_refresh = refresh.callback
    refresh.callback = function(...)
      git_status = new_git_status()
      orig_refresh(...)
    end

    require('oil').setup {
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
      default_file_explorer = false,
      use_default_keymaps = false,
      -- Set to true to watch the filesystem for changes and reload oil
      columns = {
        'icon',
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      watch_for_changes = false,
      delete_to_trash = true,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
        ['<C-x>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
        ['<Esc>'] = 'actions.close',
        ['-'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory', mode = 'n' },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
      },
      -- Oil will automatically delete hidden buffers after this delay
      -- You can set the delay to false to disable cleanup entirely
      -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
      },

      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          local dir = require('oil').get_current_dir(bufnr)
          local is_dotfile = vim.startswith(name, '.') and name ~= '..'
          -- if no local directory (e.g. for ssh connections), just hide dotfiles
          if not dir then
            return is_dotfile
          end
          -- dotfiles are considered hidden unless tracked
          if is_dotfile then
            return not git_status[dir].tracked[name]
          else
            -- Check if file is gitignored
            return git_status[dir].ignored[name]
          end
        end,
      },
    }

    local api = require 'oil'
    vim.keymap.set('n', '-', function()
      api.toggle_float()
    end, { desc = 'Toggle Oil.nvim window.', noremap = true })
  end,
}
