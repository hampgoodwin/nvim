-- nvim-lsp
--
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    vim.keymap.set('n', '<leader>lrs', vim.lsp.buf.rename, { buffer = event.buf, desc = '[l]sp [r]ename [s]ymbol' })
    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    vim.keymap.set({ 'n', 'x' }, '<leader>lca', function()
      require('tiny-code-action').code_action()
    end, { buffer = event.buf, desc = '[l]sp [c]ode [a]ction' })
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
            semanticTokens = true,
            vulncheck = 'Imports',
            -- https://github.com/golang/vscode-go/wiki/settings#uicodelenses
            codelenses = { generate = true, run_govulncheck = true, test = true, tidy = true },
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
      nixd = {},
      jsonls = {},
      ts_ls = {},
      terraformls = {},
      bashls = { filetypes = { 'sh' } },
      -- python
      ruff = {},
      pyright = {},
    }

    for server_name, server_config in pairs(lsp_servers) do
      vim.lsp.config(server_name, server_config)
      vim.lsp.enable(server_name)
    end

    vim.diagnostic.config {
      -- virtual_lines = true,
      -- virtual_text = true,
      underline = true,
      update_in_insert = true,
      severity_sort = true,
      float = {
        border = 'rounded',
        source = true,
      },
    }
  end,
}
