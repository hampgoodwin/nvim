return {
  {
    'saghen/blink.compat',
    lazy = true,
    opts = {},
    config = function()
      -- monkeypatch cmp.ConfirmBehavior for Avante
      require('cmp').ConfirmBehavior = {
        Insert = 'insert',
        Replace = 'replace',
      }
    end,
  },
}
