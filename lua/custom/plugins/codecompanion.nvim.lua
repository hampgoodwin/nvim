return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup {
      opts = {
        log_level = 'WARN', -- TRACE|DEBUG|ERROR|INFO
        language = 'English',
      },

      adapters = {
        qwen25coder14b = function()
          return require('codecompanion.adapters').extend('ollama', {
            schema = {
              model = { default = 'qwen2.5-coder:14b' },
              num_ctx = { default = 16384 },
            },
            env = {
              url = 'http://hamp:11434', -- optional: default value is ollama url http://127.0.0.1:11434
            },
          })
        end,
        deepseekr114b = function()
          return require('codecompanion.adapters').extend('ollama', {
            schema = {
              model = { default = 'ishumilin/deepseek-r1-coder-tools:14b' },
              num_ctx = { default = 16384 },
            },
            env = {
              url = 'http://hamp:11434', -- optional: default value is ollama url http://127.0.0.1:11434
            },
          })
        end,
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            schema = {
              model = { default = 'gpt-4o-mini' },
            },
            env = {
              api_key = 'cmd:echo $OPENAI_API_KEY',
            },
          })
        end,
      },

      strategies = {
        chat = {
          adapter = 'qwen25coder14b',
        },
        inline = {
          adapter = 'qwen25coder14b',
          keymaps = {
            accept_change = { modes = { n = 'ga' }, description = 'CodeCompanion: Accept change' },
            reject_change = { modes = { n = 'gr' }, description = 'CodeCompanion: Reject change' },
          },
        },
      },

      display = {
        action_palette = { provider = 'default' }, -- 'default' for native, also 'telescope' and 'mini_pick'
        chat = {
          intro_message = '✨CodeCompanion✨ ? for Opts',
          show_header_separator = false,
          show_settings = false,
          start_in_insert_mode = true,
        },
        diff = {
          enabled = true,
          provider = 'default', -- default|mini_diff
        },
      },
    }
  end,
}
