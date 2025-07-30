return {
  { -- optional blink completion source for require statements and module annotations
    'saghen/blink.cmp',
    version = '*',
    lazy = false,
    dependencies = {
      'rafamadriz/friendly-snippets',
      'echasnovski/mini.icons',
    },
    config = function()
      require('blink.cmp').setup {
        keymap = {
          preset = 'default',
          -- Manually invoke snippets completion
          ['<C-\\>'] = {
            function(cmp)
              cmp.show { providers = { 'snippets' } }
            end,
          },
        },
        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- Will be removed in a future release
          use_nvim_cmp_as_default = false,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',
        },
        signature = { enabled = true },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        completion = {
          documentation = {
            auto_show = false, -- to display documentation automatically, set to true
            auto_show_delay_ms = 500,
          },
          menu = {
            draw = {
              treesitter = { 'lsp' },
              align_to = 'kind_icon',
              -- columns = {
              --   { 'kind_icon' },
              --   { 'source_name', gap = 1 },
              --   { 'label', 'label_description', gap = 1 },
              -- },
              components = {
                kind_icon = {
                  text = function(ctx)
                    local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                    return kind_icon
                  end,
                  -- (optional) use highlights from mini.icons
                  highlight = function(ctx)
                    local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                    return hl
                  end,
                },
                kind = {
                  -- (optional) use highlights from mini.icons
                  highlight = function(ctx)
                    local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                    return hl
                  end,
                },
              },
            },
          },
        },
      }
    end,
    opts_extend = { 'sources.default' },
  },
}
