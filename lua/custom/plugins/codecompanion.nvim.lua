return {
  'olimorris/codecompanion.nvim',
  -- version = 'v12.2.0',
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
              url = 'http://hampgoodwin.asuscomm.com:11434', -- optional: default value is ollama url http://127.0.0.1:11434
            },
          })
        end,
        openrouter = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'https://openrouter.ai/api',
              api_key = 'cmd:echo $OPENROUTER_API_KEY', -- name (openrouter) + _API_KEY
              chat_url = '/v1/chat/completions',
            },
            schema = {
              model = {
                default = 'anthropic/claude-3.7-sonnet',
              },
            },
          })
        end,
      },

      strategies = {
        chat = {
          adapter = 'openrouter',
          keymaps = {
            -- open = { modes = { n = '<LocalLeader>oc' }, description = 'CodeCompanion: Start chat with default adapter' },
            -- accept_change = { modes = { n = 'ga' }, description = 'CodeCompanion: Accept change' },
            -- reject_change = { modes = { n = 'gr' }, description = 'CodeCompanion: Reject change' },
          },
        },
        inline = {
          adapter = 'openrouter',
          keymaps = {
            -- accept_change = { modes = { n = 'ga' }, description = 'CodeCompanion: Accept change' },
            -- reject_change = { modes = { n = 'gr' }, description = 'CodeCompanion: Reject change' },
          },
        },
      },

      display = {
        action_palette = { provider = 'default' }, -- 'default' for native, also 'telescope' and 'mini_pick'
        chat = {
          intro_message = '✨CodeCompanion✨ ? for Opts',
          show_header_separator = false,
          show_settings = false,
          start_in_insert_mode = false,
        },
        diff = {
          enabled = true,
          provider = 'mini_diff', -- default|mini_diff
        },
      },
    }
  end,
}
