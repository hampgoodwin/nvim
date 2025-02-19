return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

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
            analyses = {
              unusedvariable = true,
              shadow = true,
              useany = true,
            },
            hints = {
              assignVariableTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            completeUnimported = true,
            usePlaceholders = true,
            buildFlags = { '-tags=integration' },
            vulncheck = 'Imports',
          },
        },
      },
      rust_analyzer = {},
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
        init_options = { hostInfo = 'neovim' },
        filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
      },
      bashls = { filetypes = { 'sh' } },
    }

    for server_name, server_config in pairs(lsp_servers) do
      server_config.capabilities = require('blink.cmp').get_lsp_capabilities(server_config.capabilities)
      require('lspconfig')[server_name].setup(server_config)
    end
  end,
}
