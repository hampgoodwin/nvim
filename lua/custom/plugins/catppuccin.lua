return {
  'catppuccin/nvim',
  branch = 'main',
  name = 'catppuccin',
  priority = 1000,
  opts = {
    flavour = 'auto',
    background = {
      light = 'frappe',
      dark = 'macchiato',
    },
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = 'dark',
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    integrations = {
      blink_cmp = {
        style = 'bordered',
      },
      dap = true,
      dap_ui = true,
      fzf = true,
      gitsigns = true,
      mini = { enabled = true, indentscope_color = 'frappe' },
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
      snacks = { enabled = true, indent_scope_color = 'lavender' },
      treesitter = true,
      which_key = true,
    },
  },
}
