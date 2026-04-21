return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  dependencies = { 'catppuccin' },
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = false,
      theme = 'catppuccin-frappe',
      component_separators = '|',
      section_separators = '',
    },
  },
}
