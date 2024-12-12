return {
  'mistricky/codesnap.nvim',
  build = 'make',
  keys = {
    { '<leader>sc', ':CodeSnap<cr>', mode = 'v', desc = 'Save selected code snapshot into clipboard' },
  },
  config = function()
    require('codesnap').setup {
      has_breadcrumbs = true,
      has_line_number = true,
      bg_theme = 'bamboo',
      watermark = '',
    }
  end,
}
