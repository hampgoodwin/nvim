return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    flavour = 'auto',
    background = {
      light = 'latte',
      dark = 'macchiato',
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      treesitter = true,
      blink_cmp = true,
      mini = { enabled = true },
      dap = true,
      dap_ui = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { 'italic' },
          hints = { 'italic' },
          warnings = { 'italic' },
          information = { 'italic' },
          ok = { 'italic' },
        },
        underlines = {
          errors = { 'underline' },
          hints = { 'underline' },
          warnings = { 'underline' },
          information = { 'underline' },
          ok = { 'underline' },
        },
        inlay_hints = {
          background = true,
        },
      },
      telescope = { enabled = true },
      -- whick_key = true,
    },
  },
}
