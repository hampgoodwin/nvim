return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',

    -- adapters
    'nvim-neotest/neotest-jest',
  },

  config = function()
    -- kemaps
    vim.keymap.set('n', '<leader>dn', function()
      require('neotest').run.run()
    end, { desc = '[d]ebug [n]eotest run' })

    require('neotest').setup {
      adapters = {
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
