vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    --FormatDisable will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

return {
  'stevearc/conform.nvim',
  lazy = true,
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      '<leader>F',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    formatters_by_ft = {
      -- go = { "gofumpt" },
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      json = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      nix = { 'nixfmt' },
      lua = { 'stylua' },
      -- sql = { 'sql_formatter' },
      sql = { 'sql_formatter' },
      terraform = { 'terraform_fmt' },
      tf = { 'terraform_fmt' },
      ['terraform-vars'] = { 'terraform_fmt' },
    },
    formatters = {
      sqlfluff = {
        command = 'sqlfluff',
        args = { 'fix', '--dialect=postgres', '-' },
        stdin = true,
        require_cwd = false,
      },
      sql_formatter = {
        -- Adds environment args to the yamlfix formatter
        command = 'sql-formatter',
        -- args = { '--fix', '-l', 'postgresql' },
      },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local disable_filetypes = { c = true, cpp = true }
      return {
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        async = false,
        timeout_ms = 1000,
      }
    end,
  },
}
