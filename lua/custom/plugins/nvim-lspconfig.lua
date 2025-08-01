-- nvim-lsp
--
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = event.buf, desc = '[LSP] [R]e[n]ame' })
    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    vim.keymap.set({ 'n', 'x' }, '<leader>ca', function()
      require('tiny-code-action').code_action()
    end, { buffer = event.buf, desc = '[LSP] [C]ode [A]ction' })
  end,
})

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- lazydev configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/lazydev.nvim', opts = {} },

    -- blink is the completion plugin we use
    { 'saghen/blink.cmp' },
  },
  config = function()
    local lsp_servers = {
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              ignoredError = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            completeUnimported = true,
            usePlaceholders = true,
            buildFlags = { '-tags=integration' },
            semanticTokens = true,
            vulncheck = 'Imports',
            -- https://github.com/golang/vscode-go/wiki/settings#uicodelenses
            codelenses = { test = true },
          },
        },
      },
      -- rust_analyzer = {},
      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      nil_ls = {},
      jsonls = {},
      ts_ls = {},
      terraformls = {},
      bashls = { filetypes = { 'sh' } },
    }

    for server_name, server_config in pairs(lsp_servers) do
      vim.lsp.config(server_name, server_config)
      vim.lsp.enable(server_name)
    end
  end,
}
