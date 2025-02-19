return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  dependencies = { 'echasnovski/mini.icons' },
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()
  end,
}
