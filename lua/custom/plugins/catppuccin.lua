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
      blink_cmp = true,
      cmp = true,
      fzf = true,
      gitsigns = true,
      dap = true,
      dap_ui = true,
      mini = { enabled = true, indentscope_color = 'macchiato' },
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
      neotest = true,
      treesitter = true,
      whick_key = true,
    },
  },
}
