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
    local wk = require 'which-key'

    wk.add {
      { '<leader>a', group = '[a]i', icon = { icon = '󱚝', color = 'red' } },
      { '<leader>f', group = '[f]ind', icon = { icon = '', color = 'blue' } },
      { '<leader>fg', group = '[f]ind [g]it', icon = { icon = '', color = 'green' } },
      { '<leader>G', group = '[g]it', icon = { icon = '', color = 'green' } },
      { '<leader>l', group = '[l]sp', icon = { icon = '', color = 'green' } },
      { '<leader>r', group = '[r]ename', icon = { icon = '󰑕', color = 'red' } },
      { '<leader>rn', group = 're[n]ame', icon = { icon = '󰑕', color = 'red' } },
      { '<leader>s', group = '[s]earch', icon = { icon = '', color = 'red' } },
      { '<leader>u', group = 'toggle', icon = { icon = '󰔢', color = 'yellow' } },
      { '<leader>d', group = '[d]ebug', icon = { icon = '', color = 'red' } },
      { '<leader>dn', group = '[n]eotest', icon = { icon = '', color = 'orange' } },
    }
  end,
}
