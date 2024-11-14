return { -- optional blink completion source for require statements and module annotations
  "saghen/blink.cmp",
  -- version = 'v0.*',
  lazy = false,
  dependencies = 'rafamadriz/friendly-snippets',
  dir = '~/github.com/Saghen/blink.cmp',
  url = 'https://github.com/Saghen/blink.cmp',
  dev = true,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    nerd_font_vraiant = 'mono',
    keymap = { preset = 'default' },
    accept = { auto_brackets = { enabled = true } },
    trigger = { signature_help = { enabled = true } },
    -- configure the fuzzy finder for blink
    -- fuzzy = {
    --   prebuilt_binaries = { download = true, force_version = 'v0.5.1' },
    -- },
    sources = {
      -- add lazydev to your completion providers
      completion = {
        enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
      },
      providers = {
        -- dont show LuaLS require statements when lazydev has items
        lsp = { name = 'LSP', fallback_for = { "lazydev" } },
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
      },
    },
  },
}
