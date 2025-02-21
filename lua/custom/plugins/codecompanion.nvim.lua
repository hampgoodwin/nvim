return {
  'olimorris/codecompanion.nvim',
  version = 'v12.2.0',
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
          start_in_insert_mode = false,
        },
        diff = {
          enabled = true,
          provider = 'default', -- default|mini_diff
        },
      },
      prompt_library = {
        ['Explain Visual Buffer'] = {
          strategy = 'chat',
          description = 'Explain the given visual buffer to my background',
          opts = {
            mapping = '<LocalLeader>-i',
            short_name = 'explainer',
            auto_submit = true,
            user_prompt = true,
          },
          prompts = {
            {
              role = 'system',
              content = function(context)
                return 'I want you to act as a senior'
                  .. context.filetype
                  .. ' engineer. I will ask you specific questions and want you to return explanations to me understanding that I am a golang engineer.'
              end,
            },
            {
              role = 'user',
              content = function(context)
                local visualblock = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                return '#buffer\nIn the provided buffer I have the following code:\n\n````' .. context.filetype .. '\n' .. visualblock .. '\n```\n\n`'
              end,
              options = {
                contains_code = true,
              },
            },
          },
        },
      },
    }
  end,
}
