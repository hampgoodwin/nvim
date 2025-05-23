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

      -- set keymaps
      vim.keymap.set('n', '<Leader>a\\', '<cmd>CodeCompanionChat toggle<CR>', { noremap = true, silent = true, desc = '[a]i toggle chat' }),
      vim.keymap.set('v', '<Leader>aE', function()
        require('codecompanion').prompt 'Explain'
      end, { noremap = true, silent = true, desc = '[a]i [E]xplain selected...' }),

      adapters = {
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
          slash_commands = {
            ['file'] = { opts = { provider = 'snacks' } },
          },
          tools = {
            ['mcp'] = {
              -- Prevent mcphub from loading before needed
              callback = function()
                return require 'mcphub.extensions.codecompanion'
              end,
              description = 'Call tools and resources from the MCP Servers',
              opts = {
                requires_approval = true,
              },
            },
          },
        },
        inline = {
          adapter = 'openrouter_gemini',
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

      prompt_library = {
        ['Explain'] = {
          strategy = 'chat',
          description = 'Explain the code in the file type',
          opts = {
            mapping = '<LocalLeader>aE',
            modes = { 'v' },
            short_name = 'Explain',
            auto_submit = false,
            stop_context_insertion = true,
            user_promp = true,
          },
          prompts = {
            {
              role = 'system',
              content = function(context)
                return 'You are an experienced '
                  .. context.filetype
                  .. ' engineer. I will ask you specific question and I want you to return concise explanations, codeblock examples, and excerpts from source documentation.'
              end,
            },
            {
              role = 'user',
              content = function(context)
                local visual = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. visual .. '\n```\n\nPlease explain '
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    }
  end,
}
