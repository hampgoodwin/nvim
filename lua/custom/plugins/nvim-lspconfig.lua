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
            -- analyses = {
            --   shadow = true,
            --   -- default off analyzers
            --   SA5011 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#sa5011-possible-nil-pointer-dereference
            --   SA6003 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#sa6003-converting-a-string-to-a-slice-of-runes-before-ranging-over-it
            --   SA9005 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#sa9005-trying-to-marshal-a-struct-with-no-public-fields-nor-custom-marshaling
            --   ST1000 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#st1000-incorrect-or-missing-package-comment
            --   ST1003 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#st1003-poorly-chosen-identifier
            --   ST1006 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#st1006-poorly-chosen-receiver-name
            --   ST1008 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#st1008-a-functions-error-value-should-be-its-last-return-value
            --   ST1016 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#st1016-use-consistent-method-receiver-names
            --   ST1021 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#st1021-the-documentation-of-an-exported-type-should-start-with-types-name
            --   ST1022 = true, -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md#st1022-the-documentation-of-an-exported-variable-or-constant-should-start-with-variables-name
            -- },
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
      ts_ls = {
        preferences = {},
      },
      terraformls = {},
      bashls = { filetypes = { 'sh' } },
    }

    for server_name, server_config in pairs(lsp_servers) do
      vim.lsp.config(server_name, server_config)
      vim.lsp.enable(server_name)
    end
  end,
}
