return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',

    -- adapters
    'nvim-neotest/neotest-go',
    'nvim-neotest/neotest-jest',
  },

  config = function()
    -- kemaps
    -- https://www.lazyvim.org/extras/test/core
    vim.keymap.set('n', '<leader>dnt', function()
      require('neotest').run.run()
    end, { desc = '[d]ebug [n]eotest nearest [t]est' })
    vim.keymap.set('n', '<leader>dnf', function()
      require('neotest').run.run(vim.fn.expand '%')
    end, { desc = '[d]ebug [n]eotest current [f]ile' })
    vim.keymap.set('n', '<leader>dnd', function()
      require('neotest').run.run { strategy = 'dap' }
    end, { desc = '[d]ebug [n]eotest nearest test [d]ap' })
    vim.keymap.set('n', '<leader>dnl', function()
      require('neotest').run.run_last { strategy = 'dap' }
    end, { desc = '[d]ebug [n]eotest [l]ast test dap' })
    vim.keymap.set('n', '<leader>dns', function()
      require('neotest').summary.toggle()
    end, { desc = '[d]ebug [n]eotest [s]ummary' })

    require('neotest').setup {
      adapters = {
        require 'neotest-go' {},
        require 'neotest-jest' {
          jestCommand = 'npm test --',
          jestConfigFile = 'custom.jest.config.ts',
          env = {
            CI = true,
            POSTGRES_PORT = '5441',
            POSTGRES_HOST = '127.0.0.1',
            POSTGRES_DB = 'ghost',
            POSTGRES_USER = 'ghost',
            POSTGRES_PASSWORD = 'ghost',
            NATS_SERVER_URLS = 'nats://localhost:14222',
            REDIS_CACHE_PORT = '6377',
            REDIS_CACHE_HOST = 'localhost',
            KEEPA_API_KEY = 'test',
          },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        },
      },
    }
  end,
}
