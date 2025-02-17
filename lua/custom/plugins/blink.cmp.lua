return {
  { -- optional blink completion source for require statements and module annotations
    'saghen/blink.cmp',
    version = '*',
    lazy = false,
    dependencies = 'rafamadriz/friendly-snippets',
    -- dir = '~/github.com/Saghen/blink.cmp',
    -- url = 'https://github.com/Saghen/blink.cmp',
    -- dev = true,
    config = function()
      require('blink.cmp').setup {
        keymap = {
          preset = 'default',
          -- Manually invoke minuet completion.
          ['<A-y>'] = require('minuet').make_blink_map(),
        },
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
          -- Enable minuet for autocomplete
          -- default = { 'lsp', 'path', 'buffer', 'minuet' },
          default = { 'lsp', 'path', 'buffer', 'minuet' },
          -- For manual completion only, remove 'minuet' from default
          providers = {
            minuet = {
              name = 'minuet',
              module = 'minuet.blink',
              score_offset = 8,
            },
          },
        },
        -- Recommended to avoid unnecessary request
        completion = {
          menu = {
            draw = {
              align_to = 'kind_icon',
              columns = {
                { 'kind_icon', gap = 1 },
                { 'source_name', gap = 0 },
                { 'label', 'label_description', gap = 1 },
              },
            },
          },
          -- trigger = { prefetch_on_insert = false },
        },
      }
    end,
  },
}
