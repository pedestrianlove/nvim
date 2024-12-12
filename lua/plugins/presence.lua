return {
  'andweeb/presence.nvim',
  config = function()
    -- The setup config table shows all available config options with their default values:
    require('presence').setup {
      auto_update = true,
    }
  end,
}
