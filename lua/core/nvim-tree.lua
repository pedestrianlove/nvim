return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  cmd = { 'NvimTreeToggle' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true

    require('nvim-tree').setup {
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    }

    local api = require 'nvim-tree.api'
    vim.keymap.set('n', '<Esc>1', function()
      api.tree.toggle { find_file = true, focus = true }
    end, { desc = 'Toggle NvimTree sidebar.', noremap = true })
    vim.keymap.set('i', '<Esc>1', function()
      api.tree.toggle { find_file = true, focus = true }
    end, { desc = 'Toggle NvimTree sidebar.', noremap = true })
  end,
}
