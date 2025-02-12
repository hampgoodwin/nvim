return { -- optional blink completion source for require statements and module annotations
  'saghen/blink.cmp',
  version = '*',
  lazy = false,
  dependencies = 'rafamadriz/friendly-snippets',
  -- dir = '~/github.com/Saghen/blink.cmp',
  -- url = 'https://github.com/Saghen/blink.cmp',
  -- dev = true,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },
    signature = { enabled = true },
    sources = {
      -- add lazydev to your completion providers
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
  opts_extend = { 'sources.default' },
  config = function()
    require('blink-cmp').setup {
      keymap = {
        -- Manually invoke minuet completion.
        ['<A-y>'] = require('minuet').make_blink_map(),
      },
      sources = {
        -- Enable minuet for autocomplete
        default = { 'lsp', 'path', 'buffer', 'snippets', 'minuet' },
        -- For manual completion only, remove 'minuet' from default
        providers = {
          minuet = {
            name = 'minuet',
            module = 'minuet.blink',
            score_offset = 8, -- Gives minuet higher priority among suggestions
          },
        },
      },
      -- Recommended to avoid unnecessary request
      completion = { trigger = { prefetch_on_insert = false } },
    }
  end,
}
